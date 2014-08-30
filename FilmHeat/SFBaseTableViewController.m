//
//  SFBaseTableViewController.m
//  Film Heat
//
//  Created by Spencer Fornaciari on 8/30/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFBaseTableViewController.h"

@interface SFBaseTableViewController ()

@property (nonatomic) NSArray *filmArray;
@property (nonatomic) NSArray *searchArray;
@property (nonatomic) NSArray *searchResultsArray;

@end

@implementation SFBaseTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.searchBar.delegate = self;
    
    self.filmArray = [CoreDataHelper findCategoryArray:@0];
    
//    self.filmArray = [CoreDataHelper filmsArray];
//    self.searchArray = [CoreDataHelper filmsArray];
    self.segmentedControl.selectedSegmentIndex = 1;

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"Base View Controller"
                                                      forKey:kGAIScreenName] build]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchArray.count;
//        return 5;
    } else {
        return self.filmArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    // Configure the cell...
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        Film *film = self.searchArray[indexPath.row];
//        [cell setFilm:film];
        cell.textLabel.text = film.title;
    } else {
        Film *film = self.filmArray[indexPath.row];
//        [cell setFilm:film];
        cell.textLabel.text = film.title;
    }
    
    
//    if (!cell) {
//        cell = [[SFMCTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
//        
//        // Remove inset of iOS 7 separators.
//        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//            cell.separatorInset = UIEdgeInsetsZero;
//        }
//        
//        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
//        
//        // Setting the background color of the cell.
//        cell.contentView.backgroundColor = [UIColor redColor];
//    }
    
//    NSMutableArray *selectedArray = [NSMutableArray new];
//    selectedArray = [self.theaterArray mutableCopy];
    //
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//Filters connections list based on the criteria from the selected scope
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
//    NSArray *tempArray = [CoreDataHelper filmsArray];
//    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", searchText];
    self.searchArray = [CoreDataHelper titleSearchWithString:searchText];
}

//Displaying search controller when user selects it
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

#pragma mark - Segmented Action

- (IBAction)segmentedAction:(id)sender {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        NSLog(@"Segment One");
    } else if (self.segmentedControl.selectedSegmentIndex == 1) {
        NSLog(@"Segment Two");
    } else if (self.segmentedControl.selectedSegmentIndex == 2) {
        NSLog(@"Segment Three");
    } else {
        NSLog(@"Segment Four");
    }
}

@end
