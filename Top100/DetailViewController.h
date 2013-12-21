//
//  DetailViewController.h
//  Top100
//
//  Created by Don Browning on 12/20/13.
//  Copyright (c) 2013 Don Browning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSDictionary *selectedShow;
@property (weak, nonatomic) IBOutlet UILabel *showName;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
