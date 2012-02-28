//
//  ZCDRViewController.m
//  zcdr
//
//  Created by Wang Qiang on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZCDRViewController.h"

@interface  ZCDRViewController()
@property (nonatomic) int timeleft;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backcounter;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong,nonatomic) NSTimer* backCounterTimer;
@property (strong,nonatomic) NSArray* lights;
@end

@implementation ZCDRViewController
@synthesize level=_level;
@synthesize levelview = _levelview;
@synthesize timeleft=_timeleft;
@synthesize backcounter = _backcounter;
@synthesize toolbar = _toolbar;
@synthesize delegate=_delegate;
@synthesize backCounterTimer=_backCounterTimer;
@synthesize lights=_lights;

- (IBAction)dismiss:(id)sender {
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(UIButton*)getMagicButton{
    UIImage *buttonImage = [UIImage imageNamed:@"mzd.png"];
	
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 30, 30);
    return button;
}

-(NSArray*)lights{
    if (!_lights){
        _lights=[NSArray arrayWithObjects:[self getMagicButton],
                 [self getMagicButton],
                 [self getMagicButton],nil];
    }
    return _lights;
}

-(void)setup{
    if (self.levelview.level!=self.level){
        self.levelview.level=self.level;
        self.timeleft=60;
        
        if(self.toolbar){
            NSMutableArray *items = [self.toolbar.items mutableCopy];
            if ([items count]<5){
                for (int i=0;i<3;i++){
                    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:[self.lights objectAtIndex:i]];    
                    [items insertObject:customBarItem atIndex:2];
                }
                self.toolbar.items=items;
            }
        }
        else{
            NSMutableArray *items = [self.navigationItem.rightBarButtonItems mutableCopy];
            if ([items count]<3){
                for (int i=0;i<3;i++){
                    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:[self.lights objectAtIndex:i]];    
                    [items addObject:customBarItem];
                }
                self.navigationItem.rightBarButtonItems=items;
            }
            
        }
        for (int i=0;i<3;i++){
            UIButton*btn=[self.lights objectAtIndex:i];
            [btn setImage:[UIImage imageNamed:@"mzd.png"] forState:UIControlStateNormal];
        }
    }
    if (self.backCounterTimer){
        [self.backCounterTimer invalidate];
    }
    self.backCounterTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doBackCounter) userInfo:nil repeats:YES];
}

-(void)checkLevelFail{
    if (self.timeleft<=0){
        self.timeleft=0;
        [self.backCounterTimer invalidate];
        self.backCounterTimer=nil;
        if (self.presentingViewController){
            [self.presentingViewController dismissModalViewControllerAnimated:YES];
            [self.delegate levelFailed:self];
        }
        else{
            [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                //self.view.backgroundColor=[UIColor blackColor];
                CGRect frame=self.levelview.frame;
                frame.origin.x-=500;
                self.levelview.frame=frame;
            } completion:^(BOOL finished){
                [self.delegate levelFailed:self];
            }];
        }
    }
}

-(void)doBackCounter{
    self.timeleft-=1;
    [self checkLevelFail];
}

-(void)viewWillAppear:(BOOL)animated{
    self.levelview.delegate=self;
    [self setup];
}

-(void) handlePositionGood:(id)sender total:(int) total rect:(CGRect)rect{
    for (int i=2;i>=(3-total);i--){
        UIButton*btn=[self.lights objectAtIndex:i];
        [btn setImage:[UIImage imageNamed:@"zd.png"] forState:UIControlStateNormal];
    }
    
    if (total>=3){
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.levelview.alpha=0.0;
        } completion:^(BOOL finished){
            self.levelview.alpha=1.0;
            [self.delegate levelSucc:self];
        }];
    }
}

-(void) setTimeleft:(int)timeleft{
    if (_timeleft!=timeleft){
        _timeleft=timeleft;
        self.backcounter.title=[NSString stringWithFormat:@"%d",_timeleft];
    }
}

-(void) handlePositionBad{
    self.timeleft-=6;
    [self checkLevelFail];
}

-(void) setLevel:(Level *)level{
    if (_level!=level){
        _level=level;
        [self setup];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.backCounterTimer){
        [self.backCounterTimer invalidate];
        self.backCounterTimer=nil;
    }
}

- (void)viewDidUnload {
    [self setLevelview:nil];
    [self setBackcounter:nil];
    [self setToolbar:nil];
    [super viewDidUnload];
}
@end
