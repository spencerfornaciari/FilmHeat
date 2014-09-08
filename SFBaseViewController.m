//
//  SFBaseViewController.m
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/6/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFFilmModelDataController.h"
#import "SFTutorialViewController.h"
#import "SearchDisplayDataController.h"
#import "Film.h"
#import "Actor.h"
#import "CoreDataHelper.h"


@interface SFBaseViewController ()
{
    NSArray *searchResults;
}

@property (nonatomic, strong) SFSeenTableViewController *seenController;
@property (nonatomic, strong) SFTheaterTableViewController *theaterController;
@property (nonatomic, strong) SFWantedTableViewController *wantedController;
@property (nonatomic, strong) SFNoneTableViewController *noneController;
@property (nonatomic, strong) SFCustomizeViewController *customController;

@property (nonatomic) SFTutorialViewController *tutorial;
@property (strong, nonatomic) NSMutableArray *searchArray;

@property (nonatomic, strong) NSArray *childVCArray;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentOutlet;
@property (weak, nonatomic) IBOutlet UIView *movieContainer;
//@property (weak, nonatomic) IBOutlet UISearchBar *filmSearchBar;

//@property (weak, nonatomic) IBOutlet UIBarButtonItem *sortButton;

@property (nonatomic) SearchDisplayDataController *searchData;


- (IBAction)segmentPicker:(UISegmentedControl *)sender;

@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic) NSString *seenItPath, *wantToSeeItPath, *dontWantToSeeItPath;

@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@end

@implementation SFBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    _searchArray = [NSMutableArray new];
    
    self.segmentOutlet.selectedSegmentIndex = 1;
    
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSString *filmHeatPath = [documentsURL path];
    _seenItPath = [filmHeatPath stringByAppendingPathComponent:kSEEN_IT_FILE];
    _wantToSeeItPath = [filmHeatPath stringByAppendingPathComponent:kWANT_TO_FILE];
    _dontWantToSeeItPath = [filmHeatPath stringByAppendingPathComponent:kDONT_WANT_IT_FILE];
    NSLog(@"Seen: %@", _seenItPath);
    
    self.seenController = [self.storyboard instantiateViewControllerWithIdentifier:@"SeenView"];
    self.theaterController = [self.storyboard instantiateViewControllerWithIdentifier:@"TheaterView"];
    self.wantedController = [self.storyboard instantiateViewControllerWithIdentifier:@"WantedView"];
    self.noneController = [self.storyboard instantiateViewControllerWithIdentifier:@"NoneView"];
    
//    self.filmSearchBar.delegate = self;
    self.theaterController.delegate = self;
    self.seenController.delegate = self;
    self.wantedController.delegate = self;
    self.noneController.delegate = self;
    
    self.currentViewController = self.theaterController;
    self.childVCArray = @[self.seenController, self.theaterController, self.wantedController, self.noneController];

    self.theaterController.strongArray = [NSMutableArray new];
    [self setupFirstView];
    [self rottenFilmData];

//    [self filmDoesExist];
    
    self.searchData = [[SearchDisplayDataController alloc] init];
    
    self.searchDisplayController.searchResultsDataSource = self.searchData;
    self.searchDisplayController.searchResultsDelegate = self.searchData;
    
    [self.searchData.searchArray addObjectsFromArray:self.theaterController.theaterArray];
    [self.searchData.searchArray addObjectsFromArray:self.seenController.seenArray];
    [self.searchData.searchArray addObjectsFromArray:self.wantedController.wantedArray];
    [self.searchData.searchArray addObjectsFromArray:self.noneController.noneArray];
//    NSLog(@"Search Array: %@", self.searchData.searchArray);
    
    for (FilmModel *model in self.searchData.searchArray) {
        NSLog(@"%@", model.title);
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = self.wantedController.wantedArray.count;
    self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)self.wantedController.wantedArray.count];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)setupFirstView
{
    [self addChildViewController:self.currentViewController];
    self.currentViewController.view.frame = self.movieContainer.bounds;
    [self.movieContainer addSubview:self.currentViewController.view];
    [self.currentViewController didMoveToParentViewController:self];
    
}


- (void)clearContainerView
{
    
    if (self.movieContainer.subviews.count > 0) {
        UIView *view = self.movieContainer.subviews[0];
        [view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentPicker:(UISegmentedControl *)sender {
    
    [self cycleFromViewController:self.currentViewController toViewController:self.childVCArray[sender.selectedSegmentIndex]];

}

- (void) cycleFromViewController: (UIViewController*) oldC
                toViewController: (UIViewController*) newC
{
    
    
    [oldC willMoveToParentViewController:nil];                        // 1
    [self addChildViewController:newC];
    
    newC.view.frame = oldC.view.frame;
    newC.view.alpha = 0;
    
    [self transitionFromViewController: oldC toViewController: newC   // 3
                              duration: 0.25 options:0
                            animations:^{
                                newC.view.alpha = 1;
                                oldC.view.alpha = 0;
                            }
                            completion:^(BOOL finished) {
                                [oldC removeFromParentViewController];                   // 5
                                [newC didMoveToParentViewController:self];
                                self.currentViewController = newC;
                            }];
    
}

-(void)passFilmFromTheater:(FilmModel *)film forIndex:(NSInteger)index
{
    
    if (index == 0) {
        if (!self.seenController.seenArray)
        {
            self.seenController.seenArray = [NSMutableArray new];
        }
        
        [self.seenController.seenArray addObject:film];
        [NSKeyedArchiver archiveRootObject:self.seenController.seenArray toFile:_seenItPath];

        
    } else if (index == 2) {
        if (!self.wantedController.wantedArray)
        {
            self.wantedController.wantedArray = [NSMutableArray new];
        }
    
        [self.wantedController.wantedArray addObject:film];
        
        [NSKeyedArchiver archiveRootObject:self.wantedController.wantedArray toFile:_wantToSeeItPath];
        
        if (self.wantedController.wantedArray.count > 0) {
            [self.segmentOutlet setEnabled:TRUE forSegmentAtIndex:0];
        } else {
            [self.segmentOutlet setEnabled:FALSE forSegmentAtIndex:0];
        }

    } else if (index == 3) {
        if (!self.noneController.noneArray)
        {
            self.noneController.noneArray = [NSMutableArray new];
        }
        
        [self.noneController.noneArray addObject:film];
        
        [NSKeyedArchiver archiveRootObject:self.noneController.noneArray toFile:_dontWantToSeeItPath];

    }
}

-(void)passFilmFromSeen:(FilmModel *)film forIndex:(NSInteger)index
{
    if (index == 1) {
        
        [self.theaterController.strongArray addObject:film];
        
    } else if (index == 2) {
        if (!self.wantedController.wantedArray)
        {
            self.wantedController.wantedArray = [NSMutableArray new];
        }
        
        [self.wantedController.wantedArray addObject:film];
        [NSKeyedArchiver archiveRootObject:self.wantedController.wantedArray toFile:_wantToSeeItPath];

    } else if (index == 3) {
        if (!self.noneController.noneArray)
        {
            self.noneController.noneArray = [NSMutableArray new];
        }
        
        [self.noneController.noneArray addObject:film];
        [NSKeyedArchiver archiveRootObject:self.noneController.noneArray toFile:_dontWantToSeeItPath];

    }
}

-(void)passFilmFromWanted:(FilmModel *)film forIndex:(NSInteger)index
{
    if (index == 0) {
        if (!self.seenController.seenArray)
        {
            self.seenController.seenArray = [NSMutableArray new];
        }
        
        [self.seenController.seenArray addObject:film];
        [NSKeyedArchiver archiveRootObject:self.seenController.seenArray toFile:_seenItPath];

    } else if (index == 1) {
        
        [self.theaterController.strongArray addObject:film];
    } else if (index == 3) {
        if (!self.noneController.noneArray)
        {
            self.noneController.noneArray = [NSMutableArray new];
        }
        
        [self.noneController.noneArray addObject:film];
        [NSKeyedArchiver archiveRootObject:self.noneController.noneArray toFile:_dontWantToSeeItPath];

    }
}

-(void)passFilmFromNone:(FilmModel *)film forIndex:(NSInteger)index
{
    if (index == 0) {
        if (!self.seenController.seenArray)
        {
            self.seenController.seenArray = [NSMutableArray new];
        }
        
        [self.seenController.seenArray addObject:film];
        [NSKeyedArchiver archiveRootObject:self.seenController.seenArray toFile:_seenItPath];
        
    } else if (index == 1) {
        
        [self.theaterController.strongArray addObject:film];
    } else if (index == 2) {
        if (!self.wantedController.wantedArray)
        {
            self.wantedController.wantedArray = [NSMutableArray new];
        }
        
        [self.wantedController.wantedArray addObject:film];
        [NSKeyedArchiver archiveRootObject:self.wantedController.wantedArray toFile:_wantToSeeItPath];
    }
}

#pragma mark - Sort

- (IBAction)buttonAction:(id)sender {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Sort Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"A-Z", @"Z-A", @"Date (Newest)", @"Date (Oldest)", @"Variance (Smallest)", @"Variance (Greatest)", nil];
    [action showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.segmentOutlet.selectedSegmentIndex == 0) {
        self.seenController.seenArray = [self sortSelection:buttonIndex withArray:self.seenController.seenArray];
        [self.seenController.tableView reloadData];
    } else if (self.segmentOutlet.selectedSegmentIndex == 1){
        self.theaterController.theaterArray = [self sortSelection:buttonIndex withArray:self.theaterController.theaterArray];
        [self.theaterController.tableView reloadData];
    } else if (self.segmentOutlet.selectedSegmentIndex == 2){
        self.wantedController.wantedArray = [self sortSelection:buttonIndex withArray:self.wantedController.wantedArray];
        [self.wantedController.tableView reloadData];
    } else if (self.segmentOutlet.selectedSegmentIndex == 3){
        self.noneController.noneArray = [self sortSelection:buttonIndex withArray:self.noneController.noneArray];
        [self.noneController.tableView reloadData];
    }
}

-(NSMutableArray *)sortSelection:(NSInteger)buttonIndex withArray:(NSMutableArray *)arrayToSort
{
    switch (buttonIndex)
    {
        case 0:
        {
            NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
            arrayToSort = [NSMutableArray arrayWithArray:[arrayToSort sortedArrayUsingDescriptors:@[nameSorter]]];
        }
            break;
            
        case 1:
        {
            NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO];
            arrayToSort = [NSMutableArray arrayWithArray:[arrayToSort sortedArrayUsingDescriptors:@[nameSorter]]];
        }
            break;
            
        case 2:
        {
            NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"releaseDate" ascending:NO];
            arrayToSort = [NSMutableArray arrayWithArray:[arrayToSort sortedArrayUsingDescriptors:@[nameSorter]]];
        }
            break;
            
        case 3:
        {
            NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"releaseDate" ascending:YES];
            arrayToSort = [NSMutableArray arrayWithArray:[arrayToSort sortedArrayUsingDescriptors:@[nameSorter]]];
        }
            break;
            
        case 4:
        {
            NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"ratingVariance" ascending:YES];
            arrayToSort = [NSMutableArray arrayWithArray:[arrayToSort sortedArrayUsingDescriptors:@[nameSorter]]];
            
        }
            break;
        case 5:
        {
            NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"ratingVariance" ascending:NO];
            arrayToSort = [NSMutableArray arrayWithArray:[arrayToSort sortedArrayUsingDescriptors:@[nameSorter]]];
            
        }
            break;
    }
    
    return arrayToSort;
}

#pragma mark - Dynamically search text as user enters it

-(void)filmDoesExist
{
    
//    NSArray *array = [NSArray arrayWithObject:@[[self.theaterController.theaterArray copy],[self.seenController.seenArray copy],[self.wantedController.wantedArray copy],[self.noneController.noneArray copy]]];
    
    //    NSArray *array = [NSArray arrayWithObject:@[[self.theaterController.theaterArray copy],[self.seenController.seenArray copy],[self.wantedController.wantedArray copy],[self.noneController.noneArray copy]]];
    
    NSMutableArray *arrayNewt = [NSMutableArray new];
    [arrayNewt addObjectsFromArray:self.theaterController.theaterArray];
    [arrayNewt addObjectsFromArray:self.seenController.seenArray];
    [arrayNewt addObjectsFromArray:self.wantedController.wantedArray];
    [arrayNewt addObjectsFromArray:self.noneController.noneArray];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", @"The"];
    NSArray *result = [NSArray arrayWithArray:[arrayNewt filteredArrayUsingPredicate:predicate]];
    
    for (FilmModel *model in result) {
        NSLog(@"%@", model.title);
    }
    
}

//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
//{
//    NSLog(@"Search Bar Should Begin Editing");
//    if (self.segmentOutlet.selectedSegmentIndex == 0) {
//        _searchArray = [self.seenController.seenArray copy];
//    } else if (self.segmentOutlet.selectedSegmentIndex == 1){
//        _searchArray = [self.theaterController.theaterArray copy];
//    } else if (self.segmentOutlet.selectedSegmentIndex == 2){
//        _searchArray = [self.wantedController.wantedArray copy];
//    } else if (self.segmentOutlet.selectedSegmentIndex == 3){
//        _searchArray = [self.noneController.noneArray copy];
//    }
//    
//    [self.seenController.tableView setUserInteractionEnabled:NO];
//    [self.theaterController.tableView setUserInteractionEnabled:NO];
//    [self.wantedController.tableView setUserInteractionEnabled:NO];
//    [self.noneController.tableView setUserInteractionEnabled:NO];
//
//    return YES;
//}

//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    [searchBar resignFirstResponder];
//}
//
//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
//{
//    NSLog(@"Search Bar Should End Editing");
//    [self.seenController.tableView setUserInteractionEnabled:YES];
//    [self.theaterController.tableView setUserInteractionEnabled:YES];
//    [self.wantedController.tableView setUserInteractionEnabled:YES];
//    [self.noneController.tableView setUserInteractionEnabled:YES];
//    
//    return YES;
//}

//Updates as user enters text
/*
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if (self.segmentOutlet.selectedSegmentIndex == 0) {
        self.seenController.seenArray = [self searchWithArray:self.seenController.seenArray textToSearch:searchText];
        [self.seenController.tableView reloadData];
    } else if (self.segmentOutlet.selectedSegmentIndex == 1){
        self.theaterController.theaterArray = [self searchWithArray:self.theaterController.theaterArray textToSearch:searchText];
        [self.theaterController.tableView reloadData];
    } else if (self.segmentOutlet.selectedSegmentIndex == 2){
        self.wantedController.wantedArray = [self searchWithArray:self.wantedController.wantedArray textToSearch:searchText];
        [self.wantedController.tableView reloadData];
    } else if (self.segmentOutlet.selectedSegmentIndex == 3){
        self.noneController.noneArray = [self searchWithArray:self.noneController.noneArray textToSearch:searchText];
        [self.noneController.tableView reloadData];
    }
    
}

-(NSMutableArray *)searchWithArray:(NSMutableArray *)arrayToSearch textToSearch:(NSString *)searchText
{
    NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", searchText];
    NSArray *predicateArray = [NSArray arrayWithArray:[_searchArray filteredArrayUsingPredicate:titlePredicate]];
    
    if (searchText.length == 0) {
        return _searchArray;
    } else {
       return [predicateArray mutableCopy];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches Began");
    [self.filmSearchBar resignFirstResponder];
}

-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}*/

- (void)rottenFilmData
{
    _downloadQueue = [NSOperationQueue new];
    
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
            film.posterURL = [thumbnailString stringByReplacingOccurrencesOfString:@"_tmb" withString:@"_ori"];
            
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
//                actor.character = characterArray[0];
                
                [film addNewActorObject:actor];
            }
            
            film.findSimilarFilms = [dictionary valueForKeyPath:@"links.similar"];
        }
    
    }
    
    [CoreDataHelper saveContext];
    
    NSArray *array = [CoreDataHelper findCategoryArray:@2];
    NSLog(@"Category: %lu", (unsigned long)array.count);
    

}

-(NSInteger)setRatingValue:(NSString *)mpaaRating
{
    if ([mpaaRating isEqualToString:@"G"]) {
        return 1;
    } else if ([mpaaRating isEqualToString:@"PG"]){
        return 2;
    } else if ([mpaaRating isEqualToString:@"PG-13"]) {
        return 3;
    } else if ([mpaaRating isEqualToString:@"R"]) {
        return 4;
    } else {
        return 5;
    }
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@", searchText];
    
    //    if (self.segmenting.selectedSegmentIndex == 0) {
    //        searchResults = [dataNew.array1 filteredArrayUsingPredicate:resultPredicate];
    //    } else {
    //        searchResults = [dataNew2.array2 filteredArrayUsingPredicate:resultPredicate];
    //    }
    
    searchResults = [[self.searchData.searchArray filteredArrayUsingPredicate:resultPredicate] copy];
    
    for (FilmModel *model in self.searchData.searchArray) {
        NSLog(@"Pre-Title: %@", model.title);
    }
    
    for (FilmModel *model in searchResults) {
        NSLog(@"Post-Search: %@", model.title);
    }
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}
@end
