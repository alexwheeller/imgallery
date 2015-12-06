//
//  AppDelegate.m
//  imgallery
//
//  Created by AK on 06/12/2015.
//  Copyright © 2015 AK. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataStack.h"
#import "RestService.h"
#import "PhotosTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.coreDataStack = [[CoreDataStack alloc] init];

    self.restService = [[RestService alloc] initWithContext:self.coreDataStack.serviceManagedObjectContext andBaseUrl:@"http://challenge.superfling.com"];
    
    [self.restService fetchPhotos];
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    PhotosTableViewController *controller = (PhotosTableViewController *) navigationController.topViewController;
    controller.managedObjectContext = self.coreDataStack.managedObjectContext;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveContext
{
    NSError *error = nil;
    [self.coreDataStack.managedObjectContext save:&error];
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
    }
}

@end
