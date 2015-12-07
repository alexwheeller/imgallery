//
//  TestTableView.m
//  imgallery
//
//  Created by AK on 07/12/2015.
//  Copyright © 2015 AK. All rights reserved.
//

#import "TestTableView.h"

@implementation TestTableView

- (void)endUpdates
{
    [super endUpdates];
    self.onTableUpdatesEnd();
}

@end
