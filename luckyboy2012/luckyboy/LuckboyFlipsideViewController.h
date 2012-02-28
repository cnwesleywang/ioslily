//
//  LuckboyFlipsideViewController.h
//  luckyboy
//
//  Created by Wang Qiang on 12-1-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LuckboyFlipsideViewController;

@protocol LuckboyFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(LuckboyFlipsideViewController *)controller;
@end

@interface LuckboyFlipsideViewController : UIViewController

@property (assign, nonatomic) IBOutlet id <LuckboyFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
