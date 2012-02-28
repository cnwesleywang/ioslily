//
//  LevelCat+ZCDR.m
//  zcdr
//
//  Created by  on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LevelCat+ZCDR.h"
#import "Level.h"

@implementation LevelCat (ZCDR)


+(LevelCat*) levelcatWithDictionary:(NSDictionary*)info inManagedObjectContext:(NSManagedObjectContext*)context{
    LevelCat* cat=nil;
    
    NSFetchRequest* request=[NSFetchRequest fetchRequestWithEntityName:@"LevelCat"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique=%@",[info objectForKey:@"id"]];
    request.sortDescriptors=[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"unique" ascending:YES], nil];
    NSError* error;
    NSArray* matches=[context executeFetchRequest:request error:&error];
    if ((!matches) || ([matches count]>1)){
        //handle error
    }
    else if ([matches count]==0){
        cat = [NSEntityDescription insertNewObjectForEntityForName:@"LevelCat" inManagedObjectContext:context];
        cat.fold=[info objectForKey:@"fold"];
        cat.unique=[NSNumber numberWithInt:[[info objectForKey:@"id"] intValue]];
        cat.name=[info objectForKey:@"name"];
        cat.passed=0;
    }
    else{
        cat = [matches lastObject];
    }
    return cat;
}

+(LevelCat*) levelcatWithUnique:(int )unique inManagedObjectContext:(NSManagedObjectContext*)context{
    LevelCat* cat=nil;
    
    NSFetchRequest* request=[NSFetchRequest fetchRequestWithEntityName:@"LevelCat"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique=%d",unique]; 
    NSError* error;
    NSArray* matches=[context executeFetchRequest:request error:&error];
    if ((!matches) || ([matches count]!=1)){
        NSLog(@"something wrong with cat:%d %d",unique,[matches count]);
    }
    else if ([matches count]==1){
        cat = [matches lastObject];
    }
    return cat;
}

-(int)getPassedTotal{
    int total=0;
    for (Level*l in self.levels){
        if (l.passed) total+=1;
    }
    return total;
}

@end
