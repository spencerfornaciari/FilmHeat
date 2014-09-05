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
@property (nonatomic) UIActivityIndicatorView *indicatorView;

@end

@implementation SFBaseTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setTranslucent:YES];
    self.searchBar.delegate = self;
    
    
//    self.filmArray = [[CoreDataHelper filmsArray] mutableCopy];
//    self.searchArray = [CoreDataHelper filmsArray];
    self.segmentedControl.selectedSegmentIndex = 1;
    
    [self rottenFilmData];
    
//    NSArray *array = [NetworkController movieSearchWithTitle:@"ghost"];
//    
//    for (Film *film in array) {
//        NSLog(@"Title: %@", film.title);
//    }

//    [NetworkController movieSearchWithTitle:@"ghost" andCallback:^(NSArray *results) {
//        
////        [TranslationController convertDictionaryArrayToFilmArray:results andCallback:^(NSArray *convertedArray) {
////            self.searchArray = convertedArray;
////            for (Film *film in self.searchArray) {
////                NSLog(@"Title: %@", film.title);
////            }
////            //                [self.indicatorView stopAnimating];
////            [self.searchDisplayController.searchResultsTableView reloadData];
////        }];
//    }];


//    [NetworkController movieSearchWithTitle:@"Jack"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.filmArray = [[CoreDataHelper findCategoryArray:@0] mutableCopy];

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
    if (self.tableView == self.searchDisplayController.searchResultsTableView) {
        film = self.searchArray[indexPath.row];
//        [cell setFilm:film];

        cell.filmTitle.text = film.title;
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
    
    //Seen It film
    [cell setSwipeGestureWithView:checkView color:[UIColor navigationBarColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        film.interestStatus = @1;

        [self.filmArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [CoreDataHelper saveContext];
    }];
    
    //Want to See film
    [cell setSwipeGestureWithView:crossView color:[UIColor navigationBarColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState2 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        film.interestStatus = @2;

        [self.filmArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [CoreDataHelper saveContext];
    }];
    
    //No Interest film
    [cell setSwipeGestureWithView:clockView color:[UIColor navigationBarColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Sad_Face\" cell");
        film.interestStatus = @3;

        [self.filmArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [CoreDataHelper saveContext];
    }];
    
    //No Decision film
    [cell setSwipeGestureWithView:listView color:[UIColor navigationBarColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState4 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        film.interestStatus = @0;
        
        [self.filmArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
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
        NSIndexPath *indexPath;
        Film *film;
        
        if (self.searchDisplayController.active) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            film = self.searchArray[indexPath.row];
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            film = self.filmArray[indexPath.row];
        }
        
        SFMovieDetailViewController *destViewController = segue.destinationViewController;
        destViewController.film = film;
    }
}


//Filters connections list based on the criteria from the selected scope
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if ([scope isEqualToString:@"My Collection"]) {
        self.searchArray = [CoreDataHelper titleSearchWithString:searchText];
    } else {
        self.searchArray = [NetworkController movieSearchWithTitle:searchText];

//        [NetworkController movieSearchWithTitle:searchText andCallback:^(NSArray *results) {
//
//            
//            [TranslationController convertDictionaryArrayToFilmArray:results andCallback:^(NSArray *convertedArray) {
//                self.searchArray = convertedArray;
//                for (Film *film in self.searchArray) {
//                    NSLog(@"Title: %@", film.title);
//                }
////                [self.indicatorView stopAnimating];
//                [self.searchDisplayController.searchResultsTableView reloadData];
//            }];
//        }];
        
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.indicatorView stopAnimating];
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.indicatorView startAnimating];
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
}

#pragma mark - UIActionSheet Delegate Methods

- (IBAction)sortAction:(id)sender {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Sort Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"A-Z", @"Z-A", @"Date (Newest)", @"Date (Oldest)", @"My Highest Rating", @"My Lowest Rating", nil];
        [action showInView:self.view];
    } else {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Sort Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"A-Z", @"Z-A", @"Date (Newest)", @"Date (Oldest)", @"Variance (Smallest)", @"Variance (Greatest)", nil];
        [action showInView:self.view];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
            self.filmArray = [[self.filmArray sortedArrayUsingDescriptors:@[nameSorter]] mutableCopy];
        }
            break;
            
        case 1:
        {
            NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO];
            self.filmArray = [[self.filmArray sortedArrayUsingDescriptors:@[nameSorter]] mutableCopy];
        }
            break;
            
        case 2:
        {
            NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"releaseDate" ascending:NO];
            self.filmArray = [[self.filmArray sortedArrayUsingDescriptors:@[nameSorter]] mutableCopy];
        }
            break;
            
        case 3:
        {
            NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"releaseDate" ascending:YES];
            self.filmArray = [[self.filmArray sortedArrayUsingDescriptors:@[nameSorter]] mutableCopy];
        }
            break;
            
        case 4:
        {
            if (self.segmentedControl.selectedSegmentIndex == 0) {
                NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"userRating" ascending:NO];
                self.filmArray = [[self.filmArray sortedArrayUsingDescriptors:@[nameSorter]] mutableCopy];
            } else {
                NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"ratingVariance" ascending:YES];
                self.filmArray = [[self.filmArray sortedArrayUsingDescriptors:@[nameSorter]] mutableCopy];
            }
            

            
        }
            break;
        case 5:
        {
            if (self.segmentedControl.selectedSegmentIndex == 0) {
                NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"userRating" ascending:YES];
                self.filmArray = [[self.filmArray sortedArrayUsingDescriptors:@[nameSorter]] mutableCopy];
            } else {
                NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"ratingVariance" ascending:NO];
                self.filmArray = [[self.filmArray sortedArrayUsingDescriptors:@[nameSorter]] mutableCopy];
            }
            
        }
            break;
    }
    
    [self.tableView reloadData];

}

#pragma mark - Search Bar Delegate Methods

#pragma mark - Grab Theater Data

- (void)rottenFilmData
{
    NSString *rottenString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=%@", kROTTEN_TOMATOES_API_KEY];
    
    NSURL *rottenURL = [NSURL URLWithString:rottenString];
    
    NSData *rottenData = [NSData dataWithContentsOfURL:rottenURL];
    
    NSError *error;
    
    NSDictionary *rottenDictionary = [NSDictionary new];
    
    
    @try {
        rottenDictionary = [NSJSONSerialization JSONObjectWithData:rottenData
                                                           options:NSJSONReadingMutableContainers
                                                    error:&error];
    }
    @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Error" message:@"The data source is currently down, try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"API Limit Reached? %@", exception.debugDescription);
        if (error) {
            NSLog(@"Error: %@", error.debugDescription);
        }
    }
    
    NSArray *rottenArray = [rottenDictionary objectForKey:@"movies"];
    
    for (NSDictionary *dictionary in rottenArray) {
        if ([CoreDataHelper doesFilmExist:[dictionary objectForKey:@"id"]]) {
            NSLog(@"It Exists!");
        } else {
        
            Film *film = [NSEntityDescription insertNewObjectForEntityForName:@"Film" inManagedObjectContext:[CoreDataHelper managedContext]];
            
            //Getting ID information
            film.rottenTomatoesID = [dictionary objectForKey:@"id"];
            
            film.imdbID = [NSString stringWithFormat:@"http://www.imdb.com/title/tt%@/",[dictionary valueForKeyPath:@"alternate_ids.imdb"]];
            
            //Set the film title
            film.title = [dictionary objectForKey:@"title"];
            
            //Set the critics rating of the film according to Rotten Tomatoes
            film.criticScore = [dictionary valueForKeyPath:@"ratings.critics_score"];
            film.criticRating = [dictionary valueForKeyPath:@"ratings.critics_rating"];
            
            //Set the audience rating of the film according to Rotten Tomatoes
            film.audienceScore = [dictionary valueForKeyPath:@"ratings.audience_score"];
            film.audienceRating = [dictionary valueForKeyPath:@"ratings.audience_rating"];
            
            NSInteger critics = [film.criticScore integerValue];
            NSInteger audience = [film.audienceScore integerValue];
            long variance = ABS(critics - audience);
            
            film.ratingVariance = [NSNumber numberWithLong:variance];
            
            //Grab the URL for the thumbnail of the film's poster
            NSString *thumbnailString = [dictionary valueForKeyPath:@"posters.detailed"];
            
            film.thumbnailPosterURL = [thumbnailString stringByReplacingOccurrencesOfString:@"_tmb" withString:@"_det"];
            film.thumbnailAvailable = @0;
            film.posterURL = [thumbnailString stringByReplacingOccurrencesOfString:@"_tmb" withString:@"_ori"];
            film.posterAvailable = @0;
            
            //[dictionary valueForKeyPath:@"posters.original"];
            
            //Set the film runtime
            film.runtime = [dictionary valueForKeyPath:@"runtime"];
            
            //Set the film's MPAA rating
            NSString *rating = [dictionary valueForKeyPath:@"mpaa_rating"];
            
            if (rating) {
                film.mpaaRating = rating;
            } else {
                film.mpaaRating = @"NR";
            }
            
            //Set film's release date
            NSDictionary *releaseDictionary = [dictionary valueForKeyPath:@"release_dates"];
            NSString *releaseDate = [releaseDictionary objectForKey:@"theater"];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd"];
            film.releaseDate = [df dateFromString:releaseDate];
            
            //Set the film's synopsis
            film.synopsis = [dictionary valueForKeyPath:@"synopsis"];
            film.criticalConsensus = [dictionary valueForKeyPath:@"critics_consensus"];
            
            film.interestStatus = @0;
            
            NSArray *castArray = [dictionary valueForKey:@"abridged_cast"];
            
            for (NSDictionary *castMember in castArray) {
                Actor *actor = [NSEntityDescription insertNewObjectForEntityForName:@"Actor" inManagedObjectContext:[CoreDataHelper managedContext]];
                
                actor.name = [castMember valueForKey:@"name"];
                NSArray *characterArray = [castMember valueForKey:@"characters"];
                actor.character = characterArray[0];
                
                [film addNewActorObject:actor];
            }
            
            film.findSimilarFilms = [dictionary valueForKeyPath:@"links.similar"];
        }
        
    }
    
    [CoreDataHelper saveContext];
    
    self.filmArray = [[CoreDataHelper findCategoryArray:@0] mutableCopy];

//    NSArray *array = [CoreDataHelper findCategoryArray:@2];
//    NSLog(@"Category: %lu", (unsigned long)array.count);
    
    
}


@end
