//
//  RatingsSummaryTableViewCell.h
//  Top100
//
//  Created by Don Browning on 12/21/13.
//  Copyright (c) 2013 Don Browning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingsSummaryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *show;
@property (weak, nonatomic) IBOutlet UILabel *airDate;

@end
