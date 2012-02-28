//
//  LevelCat.h
//  zcdr
//
//  Created by 强 王 on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Level;

@interface LevelCat : NSManagedObject

@property (nonatomic, retain) NSString * fold;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * unique;
@property (nonatomic, retain) NSNumber * passed;
@property (nonatomic, retain) NSSet *levels;
@end

@interface LevelCat (CoreDataGeneratedAccessors)

- (void)addLevelsObject:(Level *)value;
- (void)removeLevelsObject:(Level *)value;
- (void)addLevels:(NSSet *)values;
- (void)removeLevels:(NSSet *)values;

@end
