//
//  LevelViewDelegate.h
//  zcdr
//
//  Created by 强 王 on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LevelViewDelegate

-(void) handlePositionGood:(id)sender total:(int) total rect:(CGRect)rect;
-(void) handlePositionBad;

@end
