//
//  LuckboyMainViewController.h
//  luckyboy
//
//  Created by Wang Qiang on 12-1-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LuckboyFlipsideViewController.h"

@interface LuckboyMainViewController : UIViewController <LuckboyFlipsideViewControllerDelegate>{
    NSMutableArray *picArray;
    NSMutableArray *runtimeArray;
    NSTimer * pictimer;
    UIImageView* image;
    NSDictionary* currImage;
    CGRect imageFrame;
    UIScrollView * scrollView;
    CGRect workingFrame;
    NSDictionary* currTapDict;
    NSMutableArray *luckyboys;
    NSMutableArray *luckyboydicts;
    
    BOOL isflage;
}

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
@property (strong, nonatomic) NSMutableArray* picArray;
@property (strong,nonatomic)IBOutlet UIImageView* image;
@property (strong,nonatomic)IBOutlet UIScrollView* scrollView;
- (IBAction)null:(id)sender;

- (IBAction)showInfo:(id)sender;

@end
