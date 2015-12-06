//
//  User.m
//  imgallery
//
//  Created by AK on 04/12/2015.
//  Copyright © 2015 AK. All rights reserved.
//

#import "User.h"

@implementation User

@dynamic userId;
@dynamic name;
@dynamic photos;

+ (User *)fetchOrCreateWithDictionary:(NSDictionary *)data inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(self)];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"userId = %@", data[@"UserID"]];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
    }
    if (result.lastObject) {
        return result.lastObject;
    } else {
        User *user = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:context];
        user.userId = [data[@"UserID"] integerValue];
        user.name = data[@"UserName"];
        return user;
    }
}

@end
