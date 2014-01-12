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
        self.hutGauge = [[MSSimpleGauge alloc] initWithFrame:CGRectMake(10, 90, 150, 90)];
        self.hutGauge.fillArcFillColor = [UIColor colorWithRed:0.741 green:0.216 blue:0.196 alpha:1];
        self.hutGauge.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.hutGauge];
        
        // The sub collections
        NSDictionary *nt = [self.selectedShow objectForKey:@"NielsenTitle"];
        NSDictionary *acutal = [self.selectedShow objectForKey:@"Actual"];
        NSDictionary *national = [self.selectedShow objectForKey:@"National"];
        NSDictionary *young = [self.selectedShow objectForKey:@"Demos"][0];
        NSDictionary *old = [self.selectedShow objectForKey:@"Demos"][1];
        NSDictionary *indicators = [self.selectedShow objectForKey:@"Indicators"];
        
    
        // HUT
        float hut = [[national objectForKey:@"HouseholdsUsingTelevisionPercent"] floatValue];
        self.hutGauge.value = hut;
        self.hutLabel.text = [self formatHutFloat:hut];
        
        // Top Info
        NSString *rating =  [NSString stringWithFormat:@"%@", [national valueForKey:@"Rating"]];
        self.rating.text = [rating substringWithRange:NSMakeRange(0, 4)];
        NSString *ranking = [self.selectedShow objectForKey:@"ranking"];
        self.ranking.text = [@"#" stringByAppendingString:ranking];
        
        // Show Detail
        self.detailDescriptionLabel.text = [self.selectedShow objectForKey:@"NetworkCode"];
        self.showName.text = [nt objectForKey:@"FranchiseSeriesName"];
        NSString *tmp = [self.selectedShow objectForKey:@"AA"];
        NSString *theAA = [self convertToShortNumber:tmp];
        self.aa.text = theAA; //[NSString stringWithFormat:@"%@",[self.selectedShow objectForKey:@"AA"]];
        self.duration.text = [NSString stringWithFormat: @"%@",[self.selectedShow objectForKey:@"Duration"] ];
        NSString *startDate = [RatingsFormatUtils stringFromJSONDateString:[acutal objectForKey:@"StartDate"]];
        self.airDate.text = startDate;
        
        
        // Detail
        NSString *yDelivery = [self convertToShortNumber:[young objectForKey:@"Delivery"]];
        self.delivery.text = yDelivery;
        self.youngDelivery.text = yDelivery;
        self.oldDelivery.text = [self convertToShortNumber:[old objectForKey:@"Delivery"]];
        
        self.oldVPVH.text = [self friendlyStringFromFloat:[[old objectForKey:@"VPVH"] floatValue]];
        self.youngVPVH.text = [self friendlyStringFromFloat:[[young objectForKey:@"VPVH"] floatValue]];
        
        self.oldComposite.text = [self friendlyStringFromFloat:[[old objectForKey:@"Composite"] floatValue]];
        self.youngComposite.text = [self friendlyStringFromFloat:[[young objectForKey:@"Composite"] floatValue]];
        
        
        
        // Indicators
        BOOL repeat = [[indicators objectForKey:@"IsRepeat"] boolValue];
        self.repeatIndicator.textColor = (repeat) ? ACTIVE_COLOR : INACTIVE_COLOR;
        (repeat) ? [self.repeatIndicator setFont:BOLD_FONT] : [self.repeatIndicator setFont:NORMAL_FONT];
        
        BOOL special = [[indicators objectForKey:@"IsSpecial"] boolValue];
        self.specialIndicator.textColor = (special) ? ACTIVE_COLOR : INACTIVE_COLOR;
        (special) ? [self.specialIndicator setFont:BOLD_FONT] : [self.specialIndicator setFont:NORMAL_FONT];
        
        BOOL live = [[indicators objectForKey:@"IsLiveProgramming"] boolValue];
        self.liveIndicator.textColor = (live) ? ACTIVE_COLOR : INACTIVE_COLOR;
        (live) ? [self.liveIndicator setFont:BOLD_FONT] : [self.liveIndicator setFont:NORMAL_FONT];
        
        BOOL movie = [[indicators objectForKey:@"IsMovie"] boolValue];
        self.movieIndicator.textColor = (movie) ? ACTIVE_COLOR : INACTIVE_COLOR;
        (movie) ? [self.movieIndicator setFont:BOLD_FONT] : [self.movieIndicator setFont:NORMAL_FONT];
        
        
        BOOL premiere = [[indicators objectForKey:@"IsPremiere"] boolValue];
        self.premiereIndicator.textColor = (premiere) ? ACTIVE_COLOR : INACTIVE_COLOR;
        (premiere) ? [self.premiereIndicator setFont:BOLD_FONT] : [self.premiereIndicator setFont:NORMAL_FONT];
        
        BOOL commsat = [[indicators objectForKey:@"IsCommsat"] boolValue];
        self.comsatIndicator.textColor = (commsat) ? ACTIVE_COLOR : INACTIVE_COLOR;
        (commsat) ? [self.comsatIndicator setFont:BOLD_FONT] : [self.comsatIndicator setFont:NORMAL_FONT];
        
        BOOL breakout = [[indicators objectForKey:@"IsBreakout"]boolValue];
        self.breakoutIndicator.textColor = (breakout) ? ACTIVE_COLOR : INACTIVE_COLOR;
        (breakout) ? [self.breakoutIndicator setFont:BOLD_FONT] : [self.breakoutIndicator setFont:NORMAL_FONT];
        
        BOOL gapped = [[indicators objectForKey:@"IsGapped"] boolValue];
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

- (NSString *) convertToShortNumber:(NSString *) number {
    NSString *retval;
    
    @try {
        NSNumberFormatter *f = [[NSNumberFormatter alloc]init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        
        NSString *s = [f stringFromNumber:number];
        NSRange r = [s rangeOfString:@","];
        if(r.location > 1) {
            retval = [s substringWithRange:NSMakeRange(0, 3)];
        } else {
            retval = [s substringWithRange:NSMakeRange(0, 5)];
        }
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        return retval;
    }
}

- (NSString *) formatHutFloat:(float) hutValue {
    int i = (int)hutValue;
    NSString *retValue = [NSString stringWithFormat:@"%d%%", i];
    return retValue;
}

- (NSString *) friendlyStringFromFloat:(float) floatVal {
    NSNumber *n = [NSNumber numberWithFloat:floatVal];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setMaximumFractionDigits:2];
    
    return [formatter stringFromNumber:n];
}

@end
