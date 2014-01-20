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
    NSArray *searchResults;
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
    [dc setDay:-6];
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
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return [searchResults count];
    }else{
        return [self.top100 count];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *record = [self.top100 objectAtIndex:indexPath.row];
    cell.backgroundColor = record[@"Color"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    id tempCell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if([tempCell isKindOfClass:[RatingsSummaryTableViewCell class]]){
        RatingsSummaryTableViewCell *cell = (RatingsSummaryTableViewCell *)tempCell;
        
        NSDictionary *record;
        if(tableView == self.searchDisplayController.searchResultsTableView){
            record = [searchResults objectAtIndex:indexPath.row];
        }else{
            record = [self.top100 objectAtIndex:indexPath.row];
        }
        
        
        NSDictionary *nt = record[@"NielsenTitle"];
        NSDictionary *actual = record[@"Actual"];
        NSDictionary *national = record[@"National"];
        
        NSString *title = nt[@"FranchiseSeriesName"];
        NSString *ranking = record[@"ranking"];
        
        NSString *network = record[@"NetworkCode"];
        
        NSString *startDate = actual[@"StartDate"];
        NSString *prettyDate = [RatingsFormatUtils stringFromJSONDateString:startDate];
        
        cell.show.text = title;
        NSString *detail = [NSString stringWithFormat:@"%@ on %@", prettyDate, network];
        
        cell.airDate.text = detail;
        NSString *rating =  [NSString stringWithFormat:@"%@", [national valueForKey:@"Rating"]];
        
        cell.rating.text = [rating substringWithRange:NSMakeRange(0, 4)];
        cell.ranking.text = ranking;
        
        return cell;
    } else{
        UITableViewCell * c = (UITableViewCell *)tempCell;
        c.textLabel.text = @"help";
        
        return c;
    }

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectedItem;
    
    if (IS_IPAD) {
        if(tableView == self.searchDisplayController.searchResultsTableView){
            selectedItem = [searchResults objectAtIndex:indexPath.row];
            self.detailViewController.selectedShow = selectedItem;
        } else {
            selectedItem = [self.top100 objectAtIndex:indexPath.row];
            
            self.detailViewController.selectedShow = selectedItem;
        }
    } else {
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            [self performSegueWithIdentifier: @"showDetail" sender: self];
        }
    }
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        DetailViewController *destViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = nil;
        if([self.searchDisplayController isActive]){
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            NSDictionary *selectedItem = [searchResults objectAtIndex:indexPath.row];
            //[[segue destinationViewController] setSelectedShow:selectedItem];
            destViewController.selectedShow = selectedItem;
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            
            
            NSDictionary *selectedItem = [self.top100 objectAtIndex:indexPath.row];
            
            //[[segue destinationViewController] setSelectedShow:selectedItem];
            destViewController.selectedShow = selectedItem;
        }
        
    }
}

- (NSArray *)addCountToArray:(NSArray *)sourceArray {
    int c = 0;
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:sourceArray.count];
    
    for(NSDictionary *i in sourceArray) {
        // Set the count
        c++;
        [i setValue:[NSString stringWithFormat:@"%i", c] forKey:@"ranking"];
        
        // add an element for the background color
        // based on if it's a TNT/TBS/TRU airing
        NSString *network = i[@"NetworkCode"];
        BOOL isTBS = ([network rangeOfString:@"TBSC" options:NSLiteralSearch].location != NSNotFound);
        BOOL isTNT = ([network rangeOfString:@"TNT" options:NSLiteralSearch].location != NSNotFound);
        BOOL isTru = ([network rangeOfString:@"TRU" options:NSLiteralSearch].location != NSNotFound);
        BOOL isTOON = ([network rangeOfString:@"TOON" options:NSLiteralSearch].location != NSNotFound);
        UIColor *color = (isTBS || isTNT || isTru || isTOON) ? [UIColor colorWithRed:0.827 green:0.855 blue:0.886 alpha:1] : [UIColor whiteColor];
        
        [i setValue:color forKey:@"Color"];
        
        
        [newArray addObject:i];
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

#pragma mark - Search stuff

// Predicate method to determine match
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF.NielsenTitle.FranchiseSeriesName beginswith[c] %@",
                                    searchText];
    
    searchResults = [self.top100 filteredArrayUsingPredicate:resultPredicate];
    NSLog(@"---------results-----------");
    NSLog(@"%@", searchResults);
}

// does the filtering
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}




@end
