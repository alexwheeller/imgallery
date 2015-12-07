//
//  AppDelegate.h
//  imgallery
//
//  Created by AK on 06/12/2015.
//  Copyright © 2015 AK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CoreDataStack;
@class RestService;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) CoreDataStack *coreDataStack;
@property (nonatomic, strong) RestService *restService;

+ (AppDelegate *)appDelegate;

-(void) displayErrorMessage:(NSString*)message;

@end

