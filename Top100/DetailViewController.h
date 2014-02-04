//
//  DetailViewController.h
//  Top100
//
//  Created by Don Browning on 12/20/13.
//  Copyright (c) 2013 Don Browning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSimpleGauge.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) NSDictionary *selectedShow;
@property (weak, nonatomic) IBOutlet UILabel *showName;
@property (weak, nonatomic) IBOutlet UILabel *ranking;

// show detail
@property (weak, nonatomic) IBOutlet UILabel *airDate;
@property (weak, nonatomic) IBOutlet UILabel *aa;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *delivery;
@property (weak, nonatomic) IBOutlet UILabel *hutLabel;

// Demo Detail
@property (weak, nonatomic) IBOutlet UILabel *youngDelivery;
@property (weak, nonatomic) IBOutlet UILabel *oldDelivery;
@property (weak, nonatomic) IBOutlet UILabel *youngVPVH;
@property (weak, nonatomic) IBOutlet UILabel *oldVPVH;
@property (weak, nonatomic) IBOutlet UILabel *youngComposite;
@property (weak, nonatomic) IBOutlet UILabel *oldComposite;

// Indicators
@property (weak, nonatomic) IBOutlet UILabel *specialIndicator;
@property (weak, nonatomic) IBOutlet UILabel *liveIndicator;
@property (weak, nonatomic) IBOutlet UILabel *movieIndicator;
@property (weak, nonatomic) IBOutlet UILabel *premiereIndicator;
@property (weak, nonatomic) IBOutlet UILabel *comsatIndicator;
@property (weak, nonatomic) IBOutlet UILabel *repeatIndicator;
@property (weak, nonatomic) IBOutlet UILabel *breakoutIndicator;
@property (weak, nonatomic) IBOutlet UILabel *gappedIndicator;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;



@property (strong, nonatomic) MSSimpleGauge *hutGauge;

@end
