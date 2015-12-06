//
//  CoreDataStack.m
//  imgallery
//
//  Created by AK on 06/12/2015.
//  Copyright © 2015 AK. All rights reserved.
//

#import "CoreDataStack.h"

@interface CoreDataStack ()

@property (nonatomic,readwrite) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,readwrite) NSManagedObjectContext* serviceManagedObjectContext;

@end


@implementation CoreDataStack

- (id)init
{
    self = [super init];
    if (self) {
        [self createManagedObjectContexts];
    }
    return self;
}

// create two managedObjectContexts, one for populating from the REST API and another for reading from UI
- (void)createManagedObjectContexts
{
    NSURL* storeUrl = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                             inDomain:NSUserDomainMask
                                                    appropriateForURL:nil
                                                               create:YES
                                                                error:NULL];
    storeUrl = [storeUrl URLByAppendingPathComponent:@"photodb.sqlite"];
    
    NSURL* modelUrl = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];

    self.managedObjectContext = [self createManagedObjectContextWithConcurrencyType:NSMainQueueConcurrencyType andStoreUrl:storeUrl andModelUrl:modelUrl];
    self.managedObjectContext.undoManager = nil;
    
    self.serviceManagedObjectContext = [self createManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType andStoreUrl:storeUrl andModelUrl:modelUrl];
    self.serviceManagedObjectContext.undoManager = nil;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:nil queue:nil usingBlock:^(NSNotification* notification) {
         NSManagedObjectContext *context = self.managedObjectContext;
         if (notification.object != context) {
             [context performBlock:^(){
                 [context mergeChangesFromContextDidSaveNotification:notification];
             }];
         }
     }];
}

- (NSManagedObjectContext *)createManagedObjectContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType andStoreUrl:(NSURL*)storeUrl andModelUrl:(NSURL*)modelUrl
{
    // setup model
    NSManagedObjectModel* model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];

    // setup managedObjectContext and coordinator
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurrencyType];
    managedObjectContext.persistentStoreCoordinator =
    [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSError* error;
    [managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                  configuration:nil
                                                                            URL:storeUrl
                                                                        options:nil
                                                                          error:&error];
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
    }
    return managedObjectContext;
}

@end
