//
//  RestService.h
//  imgallery
//
//  Created by AK on 06/12/2015.
//  Copyright © 2015 AK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AFImageResponseSerializer;

@interface RestService : NSObject

@property (nonatomic, strong) AFImageResponseSerializer *imageJpegSerializer;

- (id)initWithContext:(NSManagedObjectContext *)context andBaseUrl:(NSString*)baseUrl;
- (void)fetchPhotos: (void (^)(NSError *error))completionHandler;
- (NSURLRequest*) imageRequestWithId:(NSInteger)imageId;

@end
