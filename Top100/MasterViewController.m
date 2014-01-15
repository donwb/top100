//
//  MasterViewController.m
//  Top100
//
//  Created by Don Browning on 12/20/13.
//  Copyright (c) 2013 Don Browning. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "RatingsSummaryTableViewCell.h"
#import "Rating.h"
#import "TopHundred.h"
#import "constants.h"
#import "RMDateSelectionViewController.h"
#import "MRProgress.h"
#import "RatingsFormatUtils.h"

@interface MasterViewController () <RMDateSelectionViewControllerDelegate>{
    //NSMutableArray *_objects;
}
@end

@implementation MasterViewController
- (IBAction)changeDate:(id)sender {
    
    if (IS_IPHONE) {
        RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
        dateSelectionVC.delegate = self;
        [dateSelectionVC show];

        dateSelectionVC.datePicker.datePickerMode = UIDatePickerModeDate;
        dateSelectionVC.datePicker.minuteInterval = 5;
        dateSelectionVC.datePicker.date = self.currentDate;
        
    } else if (IS_IPAD) {
        NSLog(@"IPad");
        
        RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
        dateSelectionVC.delegate = self;
        [dateSelectionVC show];
        
        dateSelectionVC.datePicker.datePickerMode = UIDatePickerModeDate;
        dateSelectionVC.datePicker.minuteInterval = 5;
        dateSelectionVC.datePicker.date = self.currentDate;

        
    }
}

- (void)downloadJSON:(NSDate *)date {
    NSString *dateString = [self convertDateToUrlString:date];
    
    // This code should be removed once external url settles down
    NSString *rootURL;
    if(USE_INTERNAL_URL)
    {
        rootURL = @"http://nielsenservice/api/top100/date/";
        NSLog(@"Using Internal URL");
    } else
    {
        rootURL = @"http://flow.tbs.io/nielsentop100/";
        NSLog(@"Using external URL");
    }
    
    NSString *url = [rootURL stringByAppendingString:dateString];
    

    NSLog(@"%@", url);
    
    NSURL *jsonURL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:jsonURL];
    
    __weak id weakSelf = self;
    
    MRProgressOverlayView *progressView = [MRProgressOverlayView new];
    [self.parentViewController.view addSubview:progressView];
    [progressView show:YES];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data) {
            NSLog(@"Got data");
            NSArray *tempArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *recipeArray = [self addCountToArray:tempArray];
            
            [weakSelf reloadTableViewWithRecipeRecords:recipeArray];
            
            self.navigationItem.title = [@"Top 100 for " stringByAppendingString: dateString];
            self.currentDate = date;
            
            progressView.mode = MRProgressOverlayViewModeCheckmark;
            progressView.titleLabelText = @"Succeed";
        }
        
        else if (connectionError) {
            NSLog(@"ERROR: %@", connectionError);
            progressView.mode = MRProgressOverlayViewModeCheckmark;
            progressView.titleLabelText = @"Failed!";
        }
        
        [progressView dismiss:YES];
        
    }];
}

- (void)reloadTableViewWithRecipeRecords:(NSArray *)records {
    self.top100 = records;
    [self.tableView reloadData];
    
    // Select the first item
    if(records.count > 0){
        if(IS_IPAD) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            if ([self.tableView.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
                [self.tableView.delegate tableView:self.tableView willSelectRowAtIndexPath:indexPath];
            }
            
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition: UITableViewScrollPositionNone];
            
            if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
                [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:indexPath];
            }
            
        }
    }
    
    NSLog(@"Reloaded!");
}


- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    NSDate *startDate = [NSDate date];
    NSDateComponents *dc = [[NSDateComponents alloc]init];
    [dc setDay:-10];
    NSDate *initialDate = [[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:startDate options:0];
    //NSString *initialDateString = [self convertDateToUrlString:initialDate];
    
    [self downloadJSON:initialDate];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.top100 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RatingsSummaryTableViewCell *cell = (RatingsSummaryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *record = [self.top100 objectAtIndex:indexPath.row];
    
    NSDictionary *nt = [record objectForKey:@"NielsenTitle"];
    NSDictionary *actual = [record objectForKey:@"Actual"];
    NSDictionary *national = [record objectForKey:@"National"];
    
    NSString *title = [nt objectForKey:@"FranchiseSeriesName"];
    NSString *ranking = [record objectForKey:@"ranking"];
    
    NSString *startDate = [actual objectForKey:@"StartDate"];
    NSString *prettyDate = [RatingsFormatUtils stringFromJSONDateString:startDate];
    
    cell.show.text = title;
    NSString *detail = [NSString stringWithFormat:@"%@ on %@", prettyDate, [record objectForKey:@"NetworkCode"]];
    
    cell.airDate.text = detail;
    NSString *rating =  [NSString stringWithFormat:@"%@", [national valueForKey:@"Rating"]];
    
    cell.rating.text = [rating substringWithRange:NSMakeRange(0, 4)];
    cell.ranking.text = ranking;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDictionary *selectedItem = [self.top100 objectAtIndex:indexPath.row];
        
        self.detailViewController.selectedShow = selectedItem;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        
        NSDictionary *selectedItem = [self.top100 objectAtIndex:indexPath.row];
        
        [[segue destinationViewController] setSelectedShow:selectedItem];
    }
}

- (NSArray *)addCountToArray:(NSArray *)sourceArray {
    int c = 0;
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:sourceArray.count];
    
    for(NSDictionary *i in sourceArray) {
        c++;
        [i setValue:[NSString stringWithFormat:@"%i", c] forKey:@"ranking"];
        
        [newArray addObject:i];
        
        //NSLog(@"%@", i);
    }

    
    return newArray;
}

#pragma mark - RMDAteSelectionViewController Delegates
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    NSLog(@"Successfully selected date: %@", aDate);
    
    [self downloadJSON:aDate];
    
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    NSLog(@"Date selection was canceled");
}

- (NSString *) convertDateToUrlString:(NSDate *) aDate {
    // 2013-12-27
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    // This code should be removed once external url settles down
    if(USE_INTERNAL_URL){
        [formatter setDateFormat:@"MM-dd-YYYY"];
    } else {
        [formatter setDateFormat:@"YYYY-MM-dd"];
    }
    
    NSString *str = [formatter stringFromDate:aDate];
    
    return str;
}

@end
