//
//  RestService.m
//  imgallery
//
//  Created by AK on 06/12/2015.
//  Copyright © 2015 AK. All rights reserved.
//

#import "RestService.h"
#import "AFNetworking.h"
#import "Photo.h"

@interface RestService ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic) BOOL retryAfterNetworkFailure;

@end

@implementation RestService

- (id)initWithContext:(NSManagedObjectContext *)context andBaseUrl:(NSString*)baseUrl
{
    self = [super init];
    if (self) {
        self.context = context;
        self.baseUrl = baseUrl;
        
        self.imageJpegSerializer = [AFImageResponseSerializer serializer];
        self.imageJpegSerializer.acceptableContentTypes = [self.imageJpegSerializer.acceptableContentTypes setByAddingObject:@"image/jpg"];
        
        [self startNetworkReachabilityMonitor];
    }
    return self;
}

-(void)startNetworkReachabilityMonitor
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        if (status > 0 && self.retryAfterNetworkFailure)
            [self fetchPhotos:nil];
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

-(void)fetchPhotos:(void (^)(NSError *error))completionHandler {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:self.baseUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *photos = responseObject;
        [self.context performBlock:^{
            for (NSDictionary *item in photos) {
                [Photo fetchOrCreateWithDictionary:item inContext:self.context];
            }
            NSError *error = nil;
            [self.context save:&error];
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            }
            if (completionHandler)
                completionHandler(error);
        }];
        self.retryAfterNetworkFailure = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.retryAfterNetworkFailure = YES;
        
        if (completionHandler)
            completionHandler(error);
        
        NSLog(@"Error: %@", error);
    }];
}

- (NSURLRequest*) imageRequestWithId:(NSInteger)imageId
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/photos/%ld", self.baseUrl, imageId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0f];
    return request;
}

@end
