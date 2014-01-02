//
//  DetailViewController.m
//  Top100
//
//  Created by Don Browning on 12/20/13.
//  Copyright (c) 2013 Don Browning. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item


- (void)setSelectedShow:(NSDictionary *)newSelectedShow
{
    if(_selectedShow != newSelectedShow) {
        _selectedShow = newSelectedShow;
        
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.selectedShow) {
        NSDictionary *nt = [self.selectedShow objectForKey:@"NielsenTitle"];
        NSDictionary *acutal = [self.selectedShow objectForKey:@"Actual"];
        NSDictionary *national = [self.selectedShow objectForKey:@"National"];
        
        self.detailDescriptionLabel.text = [self.selectedShow objectForKey:@"NetworkCode"];
        self.showName.text = [nt objectForKey:@"FranchiseSeriesName"];
        
        
        self.airDate.text = [acutal objectForKey:@"StartDateString"];
        NSString *ranking = [self.selectedShow objectForKey:@"ranking"];
        self.ranking.text = [@"#" stringByAppendingString:ranking];
        
        NSString *tmp = [self.selectedShow objectForKey:@"AA"];
        NSLog(@"%@", tmp);
        
        self.aa.text = [NSString stringWithFormat:@"%@",[self.selectedShow objectForKey:@"AA"]];
        
        self.duration.text = [NSString stringWithFormat: @"%@",[self.selectedShow objectForKey:@"Duration"] ];
        
        NSString *rating =  [NSString stringWithFormat:@"%@", [national valueForKey:@"Rating"]];
        self.rating.text = [rating substringWithRange:NSMakeRange(0, 4)];
        
                             
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
