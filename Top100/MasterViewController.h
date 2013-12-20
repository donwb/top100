//
//  MasterViewController.h
//  Top100
//
//  Created by Don Browning on 12/20/13.
//  Copyright (c) 2013 Don Browning. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
