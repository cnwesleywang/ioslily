//
//  ZCDRViewControllerDelegate.h
//  zcdr
//
//  Created by 强 王 on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZCDRViewControllerDelegate <NSObject>
-(void)levelFailed:(id)sender;
-(void)levelSucc:(id)sender;
@end
