//
//  PhotosTableViewController.m
//  imgallery
//
//  Created by AK on 06/12/2015.
//  Copyright © 2015 AK. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "ControllerDataSource.h"
#import "PhotoTableViewCell.h"

@interface PhotosTableViewController () <ControllerDataSourceDelegate>

@property (nonatomic, strong) ControllerDataSource *dataSource;

@end

@implementation PhotosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Photo gallery";
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"photoId" ascending:YES selector:@selector(compare:)]];
    
    self.dataSource = [[ControllerDataSource alloc] initWithTableView:self.tableView];
    self.dataSource.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.dataSource.delegate = self;
    self.dataSource.cellReuseIdentifier = @"PhotoTableViewCell";
    
}

#pragma ControllerDataSourceDelegate
- (void)prepareCell:(PhotoTableViewCell*)cell withObject:(id)object
{
    [cell configureWith:object];
}

- (void)abandonCell:(PhotoTableViewCell*)cell
{
    [cell cancelImageLoading];
}

@end
