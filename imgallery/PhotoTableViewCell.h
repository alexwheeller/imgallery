//
//  PhotoTableViewCell.h
//  imgallery
//
//  Created by AK on 06/12/2015.
//  Copyright © 2015 AK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface PhotoTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *progressView;
@property (nonatomic, weak) IBOutlet UIImageView *pictureView;

-(void)configureWith:(Photo*) photo;
-(void)cancelImageLoading;

@end
