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

@interface MasterViewController : UITableViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *top100;
//@property (nonatomic, strong) TopHundred *top100;
@property (nonatomic, strong) NSDate *currentDate;

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
