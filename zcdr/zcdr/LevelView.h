//
//  LevelView.h
//  zcdr
//
//  Created by 强 王 on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Level.h"
#import "LevelViewDelegate.h"

@interface LevelView : UIView
@property (nonatomic,strong)Level* level;
@property (nonatomic,weak) id<LevelViewDelegate> delegate;
@end
