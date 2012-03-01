//
//  LevelView.m
//  zcdr
//
//  Created by 强 王 on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LevelView.h"

@interface LevelView()
@property (nonatomic,strong) UIImage* imageA;
@property (nonatomic,strong) UIImage* imageB;
@property (nonatomic,strong) NSMutableSet* targets;
@property (nonatomic,strong) NSMutableSet* findedTargets;

@property (nonatomic) int imgxdelta;
@property (nonatomic) int imgydelta;
@property (nonatomic) int imgwidth;
@property (nonatomic) int imgheight;

@end

@implementation LevelView

@synthesize level=_level;
@synthesize imageA=_imageA;
@synthesize imageB=_imageB;
@synthesize targets=_targets;
@synthesize findedTargets=_findedTargets;

@synthesize imgxdelta=_imgxdelta;
@synthesize imgydelta=_imgydelta;
@synthesize imgwidth=_imgwidth;
@synthesize imgheight=_imgheight;

@synthesize delegate=_delegate;


-(void) setup{
    UITapGestureRecognizer* tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.numberOfTapsRequired=1;
    [self addGestureRecognizer:tapGesture];
}

- (void)handleTap:(UIGestureRecognizer *)sender
{  
    CGPoint p=[sender locationInView:self];
    int xinView=((int)p.x % (self.imgxdelta+self.imgwidth)) - self.imgxdelta;
    if (xinView>self.imgwidth) return;
    int yinView=((int)p.y % (self.imgydelta+self.imgheight))-self.imgydelta;
    if (yinView>self.imgheight) return;
    
    int xinImage=xinView*400/self.imgwidth;
    int yinImage=yinView*300/self.imgheight;
    
    for (NSValue* value in self.targets.allObjects){
        if (CGRectContainsPoint([value CGRectValue], CGPointMake(xinImage, yinImage))){
            [self.findedTargets addObject:value];
            [self.delegate handlePositionGood:self total:[self.findedTargets count] rect:[value CGRectValue]];
            [self setNeedsDisplay];
            return;
        }
    }
    
    [self.delegate handlePositionBad];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)awakeFromNib{
    [self setup];
}

-(NSMutableSet*)targets{
    if (!_targets){
        _targets=[[NSMutableSet alloc] init];
    }
    return _targets;
}

-(NSMutableSet*)findedTargets{
    if (!_findedTargets){
        _findedTargets=[[NSMutableSet alloc] init];
    }
    return _findedTargets;
}

-(void)setLevel:(Level *)level{
    if (_level!=level){
        _level=level;
        self.imageA=[UIImage imageNamed:[NSString stringWithFormat:@"%@a.jpg",_level.path]];
        self.imageB=[UIImage imageNamed:[NSString stringWithFormat:@"%@b.jpg",_level.path]];
        [self setNeedsDisplay];
        
        NSError* error;
        NSString* basepath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:_level.path]
                                                             ofType:@"txt"];
        NSString* content = [NSString  stringWithContentsOfFile:basepath 
                                                   encoding:NSASCIIStringEncoding 
                                                          error:&error];
        NSArray* lines=[content componentsSeparatedByString:@"\n"];
        [self.targets removeAllObjects];
        [self.findedTargets removeAllObjects];
        for (NSString* line in lines){
            NSArray* poses=[line componentsSeparatedByString:@" "];
            if ([poses count]!=4){
                NSLog(@"line format error:%@",line);
            }
            else{
                int x=[[poses objectAtIndex:0] intValue];
                int y=[[poses objectAtIndex:1] intValue];
                int w=[[poses objectAtIndex:2] intValue];
                int h=[[poses objectAtIndex:3] intValue];
                [self.targets addObject:[NSValue valueWithCGRect:CGRectMake(x, y, w, h)]];
            }
        }
        while ([self.targets count]>3){
            NSUInteger randomIndex = arc4random() % [self.targets count];
            [self.targets removeObject:[[self.targets allObjects] objectAtIndex:randomIndex]];
        }
    }
}

-(void) drawGoodInd:(CGRect)rect inContext:(CGContextRef)context{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

-(CGRect)rectFromImageToView:(CGRect)rect{
    int xinView=rect.origin.x*self.imgwidth/400+self.imgxdelta;
    int yinView=rect.origin.y*self.imgheight/300+self.imgydelta;
    int winView=rect.size.width*self.imgwidth/400;
    int hinView=rect.size.height*self.imgheight/300;
    return CGRectMake(xinView, yinView, winView, hinView);
}

-(CGRect)getImageRectInTable:(int)idx rownum:(int)rownum colnum:(int)colnum{
    int rowidx=idx/colnum;
    int colidx=idx%colnum;    
    
    int x=colidx*(self.imgxdelta+self.imgwidth)+self.imgxdelta;
    int y=rowidx*(self.imgydelta+self.imgheight)+self.imgydelta;
    
    return CGRectMake(x, y, self.imgwidth, self.imgheight);
    
}

- (void)drawRect:(CGRect)rect
{
    
    int rownum=2;
    int colnum=1;
    if (self.frame.size.width>self.frame.size.height){
        rownum=1;
        colnum=2;
    }
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    
#define IMAGE_DELTA_MIN 1
    
    int maxw=(self.bounds.size.width-(colnum+1)*IMAGE_DELTA_MIN)/colnum;
    int maxh=(self.bounds.size.height-(rownum+1)*IMAGE_DELTA_MIN)/rownum;
    
    int imgwidth=maxw;
    int imgheight=imgwidth*3/4;
    if (((float)maxw/maxh) > ((float)4/3)){
        imgheight=maxh;
        imgwidth=imgheight*4/3;
    }
    int imgxdelta=(self.bounds.size.width-colnum*imgwidth)/(colnum+1);
    int imgydelta=(self.bounds.size.height-rownum*imgheight)/(rownum+1);
    
    self.imgwidth=imgwidth;
    self.imgheight=imgheight;
    self.imgxdelta=imgxdelta;
    self.imgydelta=imgydelta;
    
    CGRect imgarect=[self getImageRectInTable:0 rownum:rownum colnum:colnum];
    [self.imageA drawInRect:imgarect];
    
    CGRect imgbrect=[self getImageRectInTable:1 rownum:rownum colnum:colnum];
    [self.imageA drawInRect:imgbrect];
    
    for (NSValue* value in [self.targets allObjects]){
        CGRect rect=[value CGRectValue];
        CGRect rectInView=[self rectFromImageToView:rect];
        UIImage *rectimg=[UIImage imageWithCGImage:CGImageCreateWithImageInRect([self.imageB CGImage], rect)];
        [rectimg drawInRect:rectInView];
    }
    
    int lw=(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?5:2;
    CGContextSetLineWidth(context, lw);
    [[UIColor redColor] setStroke];
    
    
    for (NSValue *value in [self.findedTargets allObjects]){
        CGRect rect=[value CGRectValue];
        rect =[self rectFromImageToView:rect];
        
        [self drawGoodInd:rect inContext:context];

        if (colnum>1){
            rect.origin.x+=self.imgxdelta+self.imgwidth;
        }
        else{
            rect.origin.y+=self.imgydelta+self.imgheight;
        }
        [self drawGoodInd:rect inContext:context];
        
    }
    
}

@end
