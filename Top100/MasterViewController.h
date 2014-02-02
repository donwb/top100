//
//  MasterViewController.h
//  Top100
//
//  Created by Don Browning on 12/20/13.
//  Copyright (c) 2013 Don Browning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopHundred.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (nonatomic, strong) NSArray *top100;
@property (nonatomic, strong) NSDate *currentDate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterButton;
@property (weak, nonatomic) IBOutlet UIButton *filterButtoniPad;

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
