//
//  Photo.m
//  imgallery
//
//  Created by AK on 04/12/2015.
//  Copyright © 2015 AK. All rights reserved.
//

#import "Photo.h"
#import "User.h"

@implementation Photo

@dynamic photoId;
@dynamic title;
@dynamic imageId;
@dynamic user;

+ (Photo *)fetchOrCreateWithDictionary:(NSDictionary *)data inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(self)];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"photoId = %d", [data[@"ID"] integerValue]];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
    }
    if (result.lastObject) {
        return result.lastObject;
    } else {
        Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:context];
        photo.photoId = [data[@"ID"] integerValue];
        photo.title = data[@"Title"];
        photo.imageId = [data[@"ImageID"] integerValue];
        photo.user = [User fetchOrCreateWithDictionary:data inContext:(NSManagedObjectContext *)context];
        return photo;
    }
}

@end
