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

    // setup Core Data Stack
    NSURL* modelUrl = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    
    NSURL* storeUrl = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                             inDomain:NSUserDomainMask
                                                    appropriateForURL:nil
                                                               create:YES
                                                                error:NULL];
    storeUrl = [storeUrl URLByAppendingPathComponent:@"photodb.sqlite"];

    self.coreDataStack = [[CoreDataStack alloc] initWithModelUrl:modelUrl andStoreUrl:storeUrl];

    // initialise rest service
    self.restService = [[RestService alloc] initWithContext:self.coreDataStack.serviceManagedObjectContext andBaseUrl:@"http://challenge.superfling.com"];
    
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

-(void) displayErrorMessage:(NSString*)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:defaultAction];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
