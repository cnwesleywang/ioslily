//
//  ZCDRViewController.h
//  zcdr
//
//  Created by Wang Qiang on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Level.h"
#import "LevelView.h"
#import "LevelViewDelegate.h"
#import "ZCDRViewControllerDelegate.h"

@interface ZCDRViewController : UIViewController<LevelViewDelegate>

@property (nonatomic,strong)Level* level;
@property (weak, nonatomic) IBOutlet LevelView *levelview;
@property (weak,nonatomic) id<ZCDRViewControllerDelegate> delegate;

@end
