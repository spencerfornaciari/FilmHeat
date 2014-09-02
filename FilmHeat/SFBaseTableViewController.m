//
//  SFBaseTableViewController.m
//  Film Heat
//
//  Created by Spencer Fornaciari on 8/30/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFBaseTableViewController.h"

@interface SFBaseTableViewController ()

@property (nonatomic) NSMutableArray *filmArray;
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
    
    self.filmArray = [[CoreDataHelper findCategoryArray:@0] mutableCopy];
    
//    self.filmArray = [CoreDataHelper filmsArray];
//    self.searchArray = [CoreDataHelper filmsArray];
    self.segmentedControl.selectedSegmentIndex = 1;


//    [NetworkController movieSearchWithTitle:@"Jack"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
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
//        if (self.segmentedControl.selectedSegmentIndex == 0) {
//            self.filmArray = [CoreDataHelper findCategoryArray:@3];
//            return self.filmArray.count;
//        } else if (self.segmentedControl.selectedSegmentIndex == 2) {
//            self.filmArray = [CoreDataHelper findCategoryArray:@1];
//            return self.filmArray.count;
//        } else if (self.segmentedControl.selectedSegmentIndex == 3) {
//            self.filmArray = [CoreDataHelper findCategoryArray:@2];
//            return self.filmArray.count;
//        } else {
//            self.filmArray = [CoreDataHelper findCategoryArray:@0];
//            return self.filmArray.count;
//        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFMCTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Film * film;
    // Configure the cell...
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        film = self.searchArray[indexPath.row];
        [cell setFilm:film];
        
//        NSDictionary *dictionary = self.searchArray[indexPath.row];
//        cell.textLabel.text = [dictionary objectForKey:@"title"];
////        cell.textLabel.text = film.title;
    } else {
        film = self.filmArray[indexPath.row];
        [cell setFilm:film];
//        cell.filmTitle.text = film.title;
//        cell.r
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
    
    
    // Configuring the views and colors.
    UIView *checkView = [self viewWithImageName:@"SeenExtraLarge"];
    UIView *crossView = [self viewWithImageName:@"WantExtraLarge"];
    UIView *clockView = [self viewWithImageName:@"DontExtraLarge"];
    UIView *listView = [self viewWithImageName:@"TheaterExtraLarge"];
    
    // Setting the default inactive state color to the tableView background color.
    [cell setDefaultColor:self.tableView.backgroundView.backgroundColor];
    
    // Adding gestures per state basis.
    [cell setSwipeGestureWithView:checkView color:[UIColor navigationBarColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        film.interestStatus = @1;
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        [CoreDataHelper saveContext];
    }];
    
    [cell setSwipeGestureWithView:crossView color:[UIColor navigationBarColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState2 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"List\" cell");
        film.interestStatus = @2;
        [CoreDataHelper saveContext];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

//        [CoreDataHelper saveContext];
    }];
    
    [cell setSwipeGestureWithView:clockView color:[UIColor navigationBarColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Sad_Face\" cell");
        film.interestStatus = @3;
//        [self.tableView reloadData];
        [self.filmArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [CoreDataHelper saveContext];
        [self.tableView reloadData];
    }];
    
    [cell setSwipeGestureWithView:listView color:[UIColor navigationBarColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState4 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        film.interestStatus = @0;
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [CoreDataHelper saveContext];
    }];

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84;
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        if (self.tableView == self.searchDisplayController.searchResultsTableView) {
            Film *film = self.searchArray[indexPath.row];
            [(SFMovieDetailViewController *)segue.destinationViewController setFilm:film];
            //        NSDictionary *dictionary = self.searchArray[indexPath.row];
            //        cell.textLabel.text = [dictionary objectForKey:@"title"];
            ////        cell.textLabel.text = film.title;
        } else {
            Film *film = self.filmArray[indexPath.row];
            [(SFMovieDetailViewController *)segue.destinationViewController setFilm:film];

            //        cell.filmTitle.text = film.title;
            //        cell.r
        }
    }
}


//Filters connections list based on the criteria from the selected scope
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if ([scope isEqualToString:@"My Collection"]) {
        self.searchArray = [CoreDataHelper titleSearchWithString:searchText];
    } else {
        [NetworkController movieSearchWithTitle:searchText andCallback:^(NSArray *results) {
            self.searchArray = [TranslationController convertDictionaryArrayToFilmArray:results];
            NSLog(@"Search results: %lu", (unsigned long)self.searchArray.count);
            [self.tableView reloadData];
        }];
        
    }
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
        self.filmArray = [[CoreDataHelper findCategoryArray:@1] mutableCopy];
        [self.tableView reloadData];
    } else if (self.segmentedControl.selectedSegmentIndex == 1) {
        NSLog(@"Segment Two");
        self.filmArray = [[CoreDataHelper findCategoryArray:@0] mutableCopy];
        [self.tableView reloadData];
    } else if (self.segmentedControl.selectedSegmentIndex == 2) {
        NSLog(@"Segment Three");
        self.filmArray = [[CoreDataHelper findCategoryArray:@2] mutableCopy];
        [self.tableView reloadData];
    } else {
        NSLog(@"Segment Four");
        self.filmArray = [[CoreDataHelper findCategoryArray:@3] mutableCopy];
        [self.tableView reloadData];
    }
    
//    if (self.segmentedControl.selectedSegmentIndex == 0) {
//        self.filmArray = [CoreDataHelper findCategoryArray:@3];
//        return self.filmArray.count;
//    } else if (self.segmentedControl.selectedSegmentIndex == 2) {
//        self.filmArray = [CoreDataHelper findCategoryArray:@1];
//        return self.filmArray.count;
//    } else if (self.segmentedControl.selectedSegmentIndex == 3) {
//        self.filmArray = [CoreDataHelper findCategoryArray:@2];
//        return self.filmArray.count;
//    } else {
//        self.filmArray = [CoreDataHelper findCategoryArray:@0];
//        return self.filmArray.count;
//    }
}

#pragma mark - Search Bar Delegate Methods

@end
