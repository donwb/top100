//
//  DetailViewController.m
//  Top100
//
//  Created by Don Browning on 12/20/13.
//  Copyright (c) 2013 Don Browning. All rights reserved.
//

#import "DetailViewController.h"
#import "constants.h"
#import "RatingsFormatUtils.h"

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
        
        // Setup the Gauge for HUT
        CGRect rect;
        if(IS_IPHONE) {
            rect = CGRectMake(10, 90, 150, 90);
        }else {
            rect = CGRectMake(3, 130, 230, 130);
        }
        
        self.hutGauge = [[MSSimpleGauge alloc] initWithFrame:rect];
        self.hutGauge.fillArcFillColor = [UIColor colorWithRed:0.741 green:0.216 blue:0.196 alpha:1];
        self.hutGauge.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.hutGauge];
        
        // The sub collections
        NSDictionary *nt = self.selectedShow[@"NielsenTitle"];
        NSDictionary *acutal = self.selectedShow[@"Actual"];
        NSDictionary *national = self.selectedShow[@"National"];
        NSDictionary *young = self.selectedShow[@"Demos"][0];
        NSDictionary *old = self.selectedShow[@"Demos"][1];
        NSDictionary *indicators = self.selectedShow[@"Indicators"];
        
    
        // HUT
        float hut = [national[@"HouseholdsUsingTelevisionPercent"] floatValue];
        self.hutGauge.value = hut;
        self.hutLabel.text = [RatingsFormatUtils formatHutFloat:hut];
        
        // Top Info
        NSString *rating =  [NSString stringWithFormat:@"%@", [national valueForKey:@"Rating"]];
        self.rating.text = [rating substringWithRange:NSMakeRange(0, 4)];
        NSString *ranking = self.selectedShow[@"ranking"];
        self.ranking.text = [@"#" stringByAppendingString:ranking];
        
        // Show Detail
        self.detailDescriptionLabel.text = self.selectedShow[@"NetworkCode"];
        self.showName.text = nt[@"FranchiseSeriesName"];
        NSString *tmp = self.selectedShow[@"AA"];
        NSString *theAA = [RatingsFormatUtils convertToShortNumber:tmp];
        self.aa.text = theAA;
        self.duration.text = [RatingsFormatUtils formatDuration:[self.selectedShow[@"Duration"] stringValue]];
        NSString *startDate = [RatingsFormatUtils stringFromJSONDateString:acutal[@"StartDate"]];
        self.airDate.text = startDate;
        
        
        // Detail
        NSString *yDelivery = [RatingsFormatUtils convertToShortNumber:young[@"Delivery"]];
        self.delivery.text = yDelivery;
        self.youngDelivery.text = yDelivery;
        self.oldDelivery.text = [RatingsFormatUtils convertToShortNumber:old[@"Delivery"]];
        
        self.oldVPVH.text = [RatingsFormatUtils friendlyStringFromFloat:[old[@"VPVH"] floatValue]];
        self.youngVPVH.text = [RatingsFormatUtils friendlyStringFromFloat:[young[@"VPVH"] floatValue]];
        
        self.oldComposite.text = [RatingsFormatUtils friendlyStringFromFloat:[old[@"Composite"] floatValue]];
        self.youngComposite.text = [RatingsFormatUtils friendlyStringFromFloat:[young[@"Composite"] floatValue]];
        
        
        
        // Indicators
        BOOL repeat = [indicators[@"IsRepeat"] boolValue];
        self.repeatIndicator.textColor = (repeat) ? ACTIVE_COLOR : INACTIVE_COLOR;
        (repeat) ? [self.repeatIndicator setFont:BOLD_FONT] : [self.repeatIndicator setFont:NORMAL_FONT];
        
        BOOL special = [indicators[@"IsSpecial"] boolValue];
        self.specialIndicator.textColor = (special) ? ACTIVE_COLOR : INACTIVE_COLOR;
        (special) ? [self.specialIndicator setFont:BOLD_FONT] : [self.specialIndicator setFont:NORMAL_FONT];
        
        BOOL live = [indicators[@"IsLiveProgramming"] boolValue];
        self.liveIndicator.textColor = (live) ? ACTIVE_COLOR : INACTIVE_COLOR;
        (live) ? [self.liveIndicator setFont:BOLD_FONT] : [self.liveIndicator setFont:NORMAL_FONT];
        
        BOOL movie = [indicators[@"IsMovie"] boolValue];
        self.movieIndicator.textColor = (movie) ? ACTIVE_COLOR : INACTIVE_COLOR;
        (movie) ? [self.movieIndicator setFont:BOLD_FONT] : [self.movieIndicator setFont:NORMAL_FONT];
        
        
        BOOL premiere = [indicators[@"IsPremiere"] boolValue];
        self.premiereIndicator.textColor = (premiere) ? ACTIVE_COLOR : INACTIVE_COLOR;
        (premiere) ? [self.premiereIndicator setFont:BOLD_FONT] : [self.premiereIndicator setFont:NORMAL_FONT];
        
        BOOL commsat = [indicators[@"IsCommsat"] boolValue];
        self.comsatIndicator.textColor = (commsat) ? ACTIVE_COLOR : INACTIVE_COLOR;
        (commsat) ? [self.comsatIndicator setFont:BOLD_FONT] : [self.comsatIndicator setFont:NORMAL_FONT];
        
        BOOL breakout = [indicators[@"IsBreakout"]boolValue];
        self.breakoutIndicator.textColor = (breakout) ? ACTIVE_COLOR : INACTIVE_COLOR;
        (breakout) ? [self.breakoutIndicator setFont:BOLD_FONT] : [self.breakoutIndicator setFont:NORMAL_FONT];
        
        BOOL gapped = [indicators[@"IsGapped"] boolValue];
        self.gappedIndicator.textColor = (gapped) ? ACTIVE_COLOR : INACTIVE_COLOR;
        (gapped) ? [self.gappedIndicator setFont:BOLD_FONT] : [self.gappedIndicator setFont:NORMAL_FONT];
                             
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

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return NO;
}



@end
