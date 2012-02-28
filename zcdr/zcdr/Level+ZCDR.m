//
//  Level+ZCDR.m
//  zcdr
//
//  Created by  on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Level+ZCDR.h"
#import "LevelCat+ZCDR.h"

@implementation Level (ZCDR)

+(Level*) levelWithDictionary:(NSDictionary*)info inManagedObjectContext:(NSManagedObjectContext*)context
{
    Level* level=nil;
    
    NSFetchRequest* request=[NSFetchRequest fetchRequestWithEntityName:@"Level"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique=%@",[info objectForKey:@"id"]]; 
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"unique" ascending:YES], nil];
    NSError* error;
    NSArray* matches=[context executeFetchRequest:request error:&error];
    if ((!matches) || ([matches count]>1)){
        //handle error
    }
    else if ([matches count]==0){
        level = [NSEntityDescription insertNewObjectForEntityForName:@"Level" inManagedObjectContext:context];
        level.passed=0;
        level.unique=[NSNumber numberWithInt:[[info objectForKey:@"id"] intValue]];
        level.path=[info objectForKey:@"path"];
        level.cat = [LevelCat levelcatWithUnique:[[info objectForKey:@"catid"] intValue] inManagedObjectContext:context];
    }
    else{
        level = [matches lastObject];
    }
    return level;
 }

@end
