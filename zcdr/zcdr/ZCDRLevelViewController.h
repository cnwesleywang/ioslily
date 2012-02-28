//
//  ZCDRLevelViewController.h
//  zcdr
//
//  Created by  on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LevelCat.h"
#import "LevelCatViewDelegate.h"
#import "ZCDRViewControllerDelegate.h"

@interface ZCDRLevelViewController : UIViewController<LevelCatViewDelegate,ZCDRViewControllerDelegate>

@property (nonatomic,strong) LevelCat* levelcat; 

@property (weak, nonatomic) IBOutlet UIPageControl *pagectrl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong,nonatomic) UIBarButtonItem* navBarItem;

@end
