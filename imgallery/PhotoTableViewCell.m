//
//  PhotoTableViewCell.m
//  imgallery
//
//  Created by AK on 06/12/2015.
//  Copyright © 2015 AK. All rights reserved.
//

#import "PhotoTableViewCell.h"
#import "User.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "RestService.h"
#import "AppDelegate.h"

@implementation PhotoTableViewCell

-(void)configureWith:(Photo*) photo {
    [self.titleLabel setText:[NSString stringWithFormat:@"%@ by %@", photo.title, photo.user.name]];

    self.pictureView.image = nil;
    
    self.progressView.hidden = NO;
    [self.progressView startAnimating];
    
    RestService* service = [AppDelegate appDelegate].restService;
    self.pictureView.imageResponseSerializer = service.imageJpegSerializer;
    
    __weak __typeof(self)weakSelf = self;
    [self.pictureView setImageWithURLRequest:[service imageRequestWithId:photo.imageId]
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       weakSelf.pictureView.image = image;
                                       [weakSelf.progressView stopAnimating];
                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       [weakSelf.progressView stopAnimating];
                                       NSLog(@"Error: %@", error);
                                   }];
}

-(void)cancelImageLoading
{
    [self.progressView stopAnimating];
    [self.pictureView cancelImageRequestOperation];
}

@end
