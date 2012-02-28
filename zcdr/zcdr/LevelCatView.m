//
//  LevelCatView.m
//  zcdr
//
//  Created by  on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LevelCatView.h"
#import "Level.h"

@interface LevelCatView()
@property (nonatomic) int imgxdelta;
@property (nonatomic) int imgydelta;
@property (nonatomic) int imgwidth;
@property (nonatomic) int imgheight;
@end

@implementation LevelCatView

@synthesize levels=_levels;
@synthesize pageidx=_pageidx;

@synthesize imgxdelta=_imgxdelta;
@synthesize imgydelta=_imgydelta;
@synthesize imgwidth=_imgwidth;
@synthesize imgheight=_imgheight;
@synthesize delegate=_delegate;


-(UIInterfaceOrientation)interfaceOrientation{
    if (self.frame.size.width>self.frame.size.height) return UIInterfaceOrientationLandscapeLeft;
    return UIInterfaceOrientationPortrait;
}

+(int)getColNum:(UIInterfaceOrientation) orientation{
    if (UIDeviceOrientationIsLandscape(orientation)){
        return 3;
    }
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?3:2;
}

+(int)getRowNum:(UIInterfaceOrientation) orientation{
    if (UIDeviceOrientationIsLandscape(orientation)){
        return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?3:2;
    }
    return 3;    
}


-(id) initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self){
        self.contentMode=UIViewContentModeRedraw;
        self.backgroundColor=[UIColor colorWithWhite:1 alpha:0];
        UITapGestureRecognizer* tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapGesture.numberOfTapsRequired=1;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)handleTap:(UIGestureRecognizer *)sender
{  
    CGPoint p=[sender locationInView:self];
    
    int xidx=((int)p.x-self.imgxdelta)/(self.imgwidth+self.imgxdelta);
    int xleft=((int)p.x-self.imgxdelta) % (self.imgwidth+self.imgxdelta);
    if (xleft>=self.imgwidth) return;//outside of x range

    int yidx=((int)p.y-self.imgydelta)/(self.imgheight+self.imgydelta);
    int yleft=((int)p.y-self.imgydelta) % (self.imgheight+self.imgydelta);
    if (yleft>=self.imgheight) return;//outside of y range
    
    [self.delegate levelCatView:self touchInIdx:self.pageidx*ZCDR_ROW_NUM*ZCDR_COL_NUM+yidx*ZCDR_COL_NUM+xidx];
    
}

-(void)setLevels:(NSArray *)levels{
    if (_levels != levels){
        _levels=levels;
    }
}

- (UIImage *) convertToGreyscale:(UIImage *)i {
    
    int kRed = 1;
    int kGreen = 2;
    int kBlue = 4;
    
    int colors = kGreen;
    int m_width = i.size.width;
    int m_height = i.size.height;
    
    uint32_t *rgbImage = (uint32_t *) malloc(m_width * m_height * sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [i CGImage]);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // now convert to grayscale
    uint8_t *m_imageData = (uint8_t *) malloc(m_width * m_height);
    for(int y = 0; y < m_height; y++) {
        for(int x = 0; x < m_width; x++) {
            uint32_t rgbPixel=rgbImage[y*m_width+x];
            uint32_t sum=0,count=0;
            if (colors & kRed) {sum += (rgbPixel>>24)&255; count++;}
            if (colors & kGreen) {sum += (rgbPixel>>16)&255; count++;}
            if (colors & kBlue) {sum += (rgbPixel>>8)&255; count++;}
            m_imageData[y*m_width+x]=sum/count;
        }
    }
    free(rgbImage);
    
    // convert from a gray scale image back into a UIImage
    uint8_t *result = (uint8_t *) calloc(m_width * m_height *sizeof(uint32_t), 1);
    
    // process the image back to rgb
    for(int i = 0; i < m_height * m_width; i++) {
        result[i*4]=0;
        int val=m_imageData[i];
        result[i*4+1]=val;
        result[i*4+2]=val;
        result[i*4+3]=val;
    }
    
    // create a UIImage
    colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate(result, m_width, m_height, 8, m_width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
    free(m_imageData);
    
    // make sure the data will be released by giving it to an autoreleased NSData
    [NSData dataWithBytesNoCopy:result length:m_width * m_height];
    
    return resultUIImage;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+(UIImage *)makeRoundCornerImage : (UIImage*) img : (int) cornerWidth : (int) cornerHeight
{
	UIImage * newImage = nil;
    
	if( nil != img)
	{
		int w = img.size.width;
		int h = img.size.height;
        
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
        
		CGContextBeginPath(context);
		CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
		addRoundedRectToPath(context, rect, cornerWidth, cornerHeight);
		CGContextClosePath(context);
		CGContextClip(context);
        
		CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
        
		CGImageRef imageMasked = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
        
		newImage = [UIImage imageWithCGImage:imageMasked];
		CGImageRelease(imageMasked);
        
	}
    
    return newImage;
}

-(UIImage*)scaleImage:(UIImage*)src toSize:(CGSize)size 
{ 
    // 创建一个bitmap的context 
    // 并把它设置成为当前正在使用的context 
    UIGraphicsBeginImageContext(size); 
    // 绘制改变大小的图片 
    [src drawInRect:CGRectMake(0, 0, size.width, size.height)]; 
    // 从当前context中创建一个改变大小后的图片 
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext(); 
    // 使当前的context出堆栈 
    UIGraphicsEndImageContext(); 
    // 返回新的改变大小后的图片 
    return scaledImage; 
} 

- (void)drawRect:(CGRect)rect
{
    
#define IMAGE_DELTA_MIN 5
    
    int maxw=(self.bounds.size.width-(ZCDR_COL_NUM+1)*IMAGE_DELTA_MIN)/ZCDR_COL_NUM;
    int maxh=(self.bounds.size.height-(ZCDR_ROW_NUM+1)*IMAGE_DELTA_MIN)/ZCDR_ROW_NUM;

    int imgwidth=maxw;
    int imgheight=imgwidth*3/4;
    if (((float)maxw/maxh) > ((float)4/3)){
        imgheight=maxh;
        imgwidth=imgheight*4/3;
    }
    int imgxdelta=(self.bounds.size.width-ZCDR_COL_NUM*imgwidth)/(ZCDR_COL_NUM+1);
    int imgydelta=(self.bounds.size.height-ZCDR_ROW_NUM*imgheight)/(ZCDR_ROW_NUM+1);
    
    self.imgwidth=imgwidth;
    self.imgheight=imgheight;
    self.imgxdelta=imgxdelta;
    self.imgydelta=imgydelta;
    
    for (int i=0;i<ZCDR_ROW_NUM*ZCDR_COL_NUM;i++){
        int idx=self.pageidx*ZCDR_ROW_NUM*ZCDR_COL_NUM+i;
        if (idx>=self.levels.count) break;

        int rowidx=i/ZCDR_COL_NUM;
        int colidx=i % ZCDR_COL_NUM;
        
        Level *l=[self.levels objectAtIndex:idx];
        
        UIImage* image=[UIImage imageNamed:[NSString stringWithFormat:@"%@a.jpg",l.path]];
        image=[self scaleImage:image toSize:CGSizeMake(imgwidth, imgheight)];
        if (!l.passed) image=[self convertToGreyscale:image];
        image=[LevelCatView makeRoundCornerImage:image :15 :15];
        
        [image drawInRect:CGRectMake(imgxdelta+colidx*(imgwidth+imgxdelta), imgydelta+rowidx*(imgheight+imgydelta), imgwidth, imgheight)];
    
    }
}
@end
