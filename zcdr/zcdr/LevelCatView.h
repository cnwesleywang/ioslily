//
//  LevelCatView.h
//  zcdr
//
//  Created by  on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LevelCat.h"
#import "LevelCatViewDelegate.h"

@interface LevelCatView : UIView

@property (nonatomic,strong) id<LevelCatViewDelegate> delegate;

@property (nonatomic,strong) NSArray* levels; // of level
@property (nonatomic) int pageidx;

#define ZCDR_ROW_NUM [LevelCatView getRowNum:self.interfaceOrientation]
#define ZCDR_COL_NUM [LevelCatView getColNum:self.interfaceOrientation]

+(int)getColNum:(UIInterfaceOrientation) orientation;
+(int)getRowNum:(UIInterfaceOrientation) orientation;

@end
