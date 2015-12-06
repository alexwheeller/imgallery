//
//  Photo.h
//  imgallery
//
//  Created by AK on 04/12/2015.
//  Copyright © 2015 AK. All rights reserved.
//

#import <CoreData/CoreData.h>

@class User;

@interface Photo : NSManagedObject

@property (nonatomic, assign) NSInteger photoId;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger imageId;
@property (nonatomic, strong) User * user;

+ (Photo *)fetchOrCreateWithDictionary:(NSDictionary *)data inContext:(NSManagedObjectContext *)context;

@end
