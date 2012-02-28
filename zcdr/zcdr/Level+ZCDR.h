//
//  Level+ZCDR.h
//  zcdr
//
//  Created by  on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Level.h"

@interface Level (ZCDR)

+(Level*) levelWithDictionary:(NSDictionary*)info inManagedObjectContext:(NSManagedObjectContext*)context;

@end
