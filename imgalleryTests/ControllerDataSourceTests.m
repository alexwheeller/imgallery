//
//  ControllerDataSourceTests.m
//  imgallery
//
//  Created by AK on 06/12/2015.
//  Copyright © 2015 AK. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CoreDataStack.h"
#import "ControllerDataSource.h"
#import "Photo.h"
#include "TestTableView.h"

@interface ControllerDataSourceTests : XCTestCase

@end

@implementation ControllerDataSourceTests
    CoreDataStack* coreDataStack;
    ControllerDataSource* dataSource;
    NSDictionary* testRcord;
    TestTableView* tableView;

- (void)setUp {
    [super setUp];
    
    [self deleteStore];
    
    // setup Core Data Stackё
    NSURL* modelUrl = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    
    coreDataStack = [[CoreDataStack alloc] initWithModelUrl:modelUrl andStoreUrl:[self storeUrl]];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"photoId" ascending:YES selector:@selector(compare:)]];
    
     tableView = [[TestTableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    dataSource = [[ControllerDataSource alloc] initWithTableView:tableView];
    dataSource.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    dataSource.cellReuseIdentifier = @"PhotoTableViewCell";
    
    NSString *jsonString = @"{\"ID\": 1,\"ImageID\": 300,\"Title\": \"Acton Town, Ealing\",\"UserID\": 10,\"UserName\": \"Benjamin\"}";
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    testRcord = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

- (void)tearDown {
    [self deleteStore];
    [super tearDown];
}

- (void)testAddingRecord {
    Photo* photo = [Photo fetchOrCreateWithDictionary:testRcord inContext:coreDataStack.serviceManagedObjectContext];
    XCTAssertNotNil(photo, @"error creating Photo object");
    XCTAssertNotNil(photo.user, @"error creating User object");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Adding item"];
    
    tableView.onTableUpdatesEnd = ^ {
        XCTAssertEqual([tableView.dataSource numberOfSectionsInTableView:tableView], 1, "Number of sections should be 1");
        XCTAssertEqual([tableView.dataSource tableView:tableView numberOfRowsInSection:0], 1, "Number of rows should be 1");
        [expectation fulfill];
    };
    
    NSError *error = nil;
    [coreDataStack.serviceManagedObjectContext save:&error];
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }
    
    XCTAssertNil(error, @"error saving context");
    
    [self waitForExpectationsWithTimeout:50.0 handler:^(NSError *error) {
        if(error)
            XCTFail(@"Expectation Failed with error: %@", error);
    }];
}

-(void)deleteStore
{
    NSError* error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[[self storeUrl] path] error:&error];
    
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
    }
}

-(NSURL*)storeUrl
{
    NSURL* storeUrl = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                             inDomain:NSUserDomainMask
                                                    appropriateForURL:nil
                                                               create:YES
                                                                error:NULL];
    
    storeUrl = [storeUrl URLByAppendingPathComponent:@"testdb.sqlite"];
    return storeUrl;
}

@end
