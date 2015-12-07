//
//  TestTableView.h
//  imgallery
//
//  Created by AK on 07/12/2015.
//  Copyright © 2015 AK. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void (^TableUbdatesEndBlock)(void);

@interface TestTableView : UITableView

@property (nonatomic, copy) void (^onTableUpdatesEnd)(void);
//@property (nonatomic, copy) TableUbdatesEndBlock onTableUpdatesEnd;

@end
