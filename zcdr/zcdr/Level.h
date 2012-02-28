//
//  Level.h
//  zcdr
//
//  Created by 强 王 on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LevelCat;

@interface Level : NSManagedObject

@property (nonatomic, retain) NSNumber * passed;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSNumber * unique;
@property (nonatomic, retain) LevelCat *cat;

@end
