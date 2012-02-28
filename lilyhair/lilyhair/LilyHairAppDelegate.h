//
//  LilyHairAppDelegate.h
//  lilyhair
//
//  Created by  on 11-10-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LilyhairMain.h"

@class LilyHairViewController;

@interface LilyHairAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LilyHairViewController *viewController;

@end
