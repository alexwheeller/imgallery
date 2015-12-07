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
#import "AppDelegate.h"
#import "RestService.h"

@interface PhotosTableViewController ()

@property (nonatomic, strong) ControllerDataSource *dataSource;

@end

@implementation PhotosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"photoId" ascending:YES selector:@selector(compare:)]];
    
    self.dataSource = [[ControllerDataSource alloc] initWithTableView:self.tableView];
    self.dataSource.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.dataSource.cellReuseIdentifier = @"PhotoTableViewCell";
    self.tableView.delegate = self;

    // setting the empty view showing when data is not yet ready
    UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                    self.tableView.bounds.size.width,
                                                                    self.tableView.bounds.size.height)];
    messageLbl.text = @"No photos";
    messageLbl.textAlignment = NSTextAlignmentCenter;
    [messageLbl sizeToFit];
    
    self.tableView.backgroundView = messageLbl;
    
    [self.refreshControl addTarget:self action:@selector(loadDataFromRestService) forControlEvents:UIControlEventValueChanged];
    
    [self loadDataFromRestService];
}

-(void)loadDataFromRestService
{
    [[AppDelegate appDelegate].restService fetchPhotos:^(NSError *error) {
        if (error!=nil)
            [[AppDelegate appDelegate] displayErrorMessage:error.localizedDescription];
        
        [self.refreshControl endRefreshing];
    }];
    
    [self.refreshControl beginRefreshing];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(id)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataSource objectAtIndexPath:indexPath];
    [self prepareCell:cell withObject:object];
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(id)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self abandonCell:cell];
}

- (void)prepareCell:(PhotoTableViewCell*)cell withObject:(id)object
{
    [cell configureWith:object];
}

- (void)abandonCell:(PhotoTableViewCell*)cell
{
    [cell cancelImageLoading];
}

@end
