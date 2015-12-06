//
//  User.h
//  imgallery
//
//  Created by AK on 04/12/2015.
//  Copyright © 2015 AK. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface User : NSManagedObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSSet *photos;

+ (User *)fetchOrCreateWithDictionary:(NSDictionary *)data inContext:(NSManagedObjectContext *)context;

@end
