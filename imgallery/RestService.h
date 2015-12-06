//
//  RestService.h
//  imgallery
//
//  Created by AK on 06/12/2015.
//  Copyright © 2015 AK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface RestService : NSObject

- (id)initWithContext:(NSManagedObjectContext *)context andBaseUrl:(NSString*)baseUrl;

-(void)fetchPhotos;

@end
