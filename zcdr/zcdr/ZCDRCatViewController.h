//
//  ZCDRCatViewController.h
//  zcdr
//
//  Created by Wang Qiang on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface ZCDRCatViewController : CoreDataTableViewController<UISplitViewControllerDelegate>

@property (nonatomic,strong) UIManagedDocument* leveldatabase;

@end
