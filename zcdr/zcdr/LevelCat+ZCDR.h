//
//  LevelCat+ZCDR.h
//  zcdr
//
//  Created by  on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LevelCat.h"

@interface LevelCat (ZCDR)

+(LevelCat*) levelcatWithDictionary:(NSDictionary*)info inManagedObjectContext:(NSManagedObjectContext*)context;
+(LevelCat*) levelcatWithUnique:(int )unique inManagedObjectContext:(NSManagedObjectContext*)context;

-(int)getPassedTotal;

@end
