//
//  ControllerDataSource.h
//  imgallery
//
//  Created by AK on 06/12/2015.
//  Copyright © 2015 AK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@class NSFetchedResultsController;

@protocol ControllerDataSourceDelegate

- (void)prepareCell:(id)cell withObject:(id)object;
- (void)abandonCell:(id)cell;

@end

@interface ControllerDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) id<ControllerDataSourceDelegate> delegate;
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, copy) NSString* cellReuseIdentifier;

- (id)initWithTableView:(UITableView*)tableView;
- (id)objectAtIndexPath:(NSIndexPath*)indexPath;

@end
