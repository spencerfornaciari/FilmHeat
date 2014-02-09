//
//  SFBaseViewController.m
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/6/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFFilmModelDataController.h"


@interface SFBaseViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *zipCode;

@property (nonatomic, strong) SFSeenTableViewController *seenController;
@property (nonatomic, strong) SFTheaterTableViewController *theaterController;
@property (nonatomic, strong) SFWantedTableViewController *wantedController;
@property (nonatomic, strong) SFNoneTableViewController *noneController;
@property (strong, nonatomic) NSMutableArray *searchArray;

@property (nonatomic, strong) NSArray *childVCArray;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentOutlet;
@property (weak, nonatomic) IBOutlet UIView *movieContainer;
@property (weak, nonatomic) IBOutlet UISearchBar *filmSearchBar;

- (IBAction)segmentPicker:(UISegmentedControl *)sender;

@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic) NSString *seenItPath, *wantToSeeItPath, *dontWantToSeeItPath;

@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@end

@implementation SFBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Declare CLLocation Manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    [self.locationManager startUpdatingLocation];
    
    self.location = [[CLLocation alloc] init];
    
    _searchArray = [NSMutableArray new];
    
    self.segmentOutlet.selectedSegmentIndex = 1;
    
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSString *filmHeatPath = [documentsURL path];
    _seenItPath = [filmHeatPath stringByAppendingPathComponent:kSEEN_IT_FILE];
    _wantToSeeItPath = [filmHeatPath stringByAppendingPathComponent:kWANT_TO_FILE];
    _dontWantToSeeItPath = [filmHeatPath stringByAppendingPathComponent:kDONT_WANT_IT_FILE];
    
    self.seenController = [self.storyboard instantiateViewControllerWithIdentifier:@"SeenView"];
    self.theaterController = [self.storyboard instantiateViewControllerWithIdentifier:@"TheaterView"];
    self.wantedController = [self.storyboard instantiateViewControllerWithIdentifier:@"WantedView"];
    self.noneController = [self.storyboard instantiateViewControllerWithIdentifier:@"NoneView"];

    self.filmSearchBar.delegate = self;
    self.theaterController.delegate = self;
    self.seenController.delegate = self;
    self.wantedController.delegate = self;
    self.noneController.delegate = self;
    
    self.currentViewController = self.theaterController;

    self.childVCArray = @[self.seenController, self.theaterController, self.wantedController, self.noneController];
    

    
    self.theaterController.strongArray = [NSMutableArray new];
    
	// Do any additional setup after loading the view.
}

-(void)setupFirstView
{
    [self addChildViewController:self.currentViewController];
    self.currentViewController.view.frame = self.movieContainer.frame;
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

-(void)viewWillAppear:(BOOL)animated
{
//    if ([[NSKeyedUnarchiver unarchiveObjectWithFile:_seenItPath] count] == 0) {
//        [self.segmentOutlet setEnabled:NO forSegmentAtIndex:0];
//    } else  {
//        [self.segmentOutlet setEnabled:YES forSegmentAtIndex:0];
//    }
//
//    if ([[NSKeyedUnarchiver unarchiveObjectWithFile:_wantToSeeItPath] count] == 0) {
//        [self.segmentOutlet setEnabled:NO forSegmentAtIndex:2];
//    } else {
//        [self.segmentOutlet setEnabled:YES forSegmentAtIndex:2];
//    }
//    
//    if ([[NSKeyedUnarchiver unarchiveObjectWithFile:_dontWantToSeeItPath] count] == 0) {
//        [self.segmentOutlet setEnabled:NO forSegmentAtIndex:3];
//    } else {
//        [self.segmentOutlet setEnabled:YES forSegmentAtIndex:3];
//    }
}

#pragma mark - Using GPS to look up user location

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = locations[0];
    
    CLGeocoder *geocoder = [CLGeocoder new];
    
    [geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray *placemarks, NSError *error) {
        self.zipCode = [placemarks[0] postalCode];
        [[NSUserDefaults standardUserDefaults] setObject:self.zipCode forKey:@"defaultZipCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.locationManager stopUpdatingLocation];
        [self populateFilmData:self.zipCode];
        self.theaterController.strongArray = self.theaterController.theaterArray;

        NSLog(@"%@", self.zipCode);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self setupFirstView];
            [self.theaterController.tableView reloadData];
        }];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentPicker:(UISegmentedControl *)sender {
    
//    [self clearContainerView];
    
    NSLog(@"%ld",(long)self.segmentOutlet.selectedSegmentIndex);
    
    if (self.segmentOutlet.selectedSegmentIndex == 0) {
        self.segmentOutlet.tintColor = [UIColor seenItColor];
    } else if (self.segmentOutlet.selectedSegmentIndex == 1) {
        self.segmentOutlet.tintColor = [UIColor theaterColor];
    } else if(self.segmentOutlet.selectedSegmentIndex == 2) {
        self.segmentOutlet.tintColor = [UIColor wantedColor];
    } else if (self.segmentOutlet.selectedSegmentIndex == 3){
        self.segmentOutlet.tintColor = [UIColor noInterestColor];
    }
    
    [self cycleFromViewController:self.currentViewController toViewController:self.childVCArray[sender.selectedSegmentIndex]];

//    [self addChildViewController:[self.childVCArray objectAtIndex:sender.selectedSegmentIndex]];
//    
//    UIViewController *viewController = self.childVCArray[self.segmentOutlet.selectedSegmentIndex];
//    viewController.view.frame = self.movieContainer.frame;
//    [self.movieContainer addSubview:viewController.view];
//    [viewController didMoveToParentViewController:self];
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
        if (!self.theaterController.theaterArray)
        {
            self.theaterController.theaterArray = [NSMutableArray new];
        }
        
        [self.theaterController.theaterArray addObject:film];
        
        if (self.seenController.seenArray.count> 0) {
             [self.segmentOutlet setEnabled:TRUE forSegmentAtIndex:0];
        } else {
            [self.segmentOutlet setEnabled:FALSE forSegmentAtIndex:0];
        }
        
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
        if (!self.theaterController.theaterArray)
        {
            self.theaterController.theaterArray = [NSMutableArray new];
        }
        
        [self.theaterController.theaterArray addObject:film];
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
        if (!self.theaterController.theaterArray)
        {
            self.theaterController.theaterArray = [NSMutableArray new];
        }
        
        [self.theaterController.theaterArray addObject:film];
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
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Test Sheet" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"A-Z", @"Z-A", @"Date (Newest)", @"Date (Oldest)", nil];
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
    }
    
    return arrayToSort;
}

#pragma mark - Dynamically search text as user enters it

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"Search Bar Should Begin Editing");
    if (self.segmentOutlet.selectedSegmentIndex == 0) {
        _searchArray = [self.seenController.seenArray copy];
    } else if (self.segmentOutlet.selectedSegmentIndex == 1){
        _searchArray = [self.theaterController.theaterArray copy];
    } else if (self.segmentOutlet.selectedSegmentIndex == 2){
        _searchArray = [self.wantedController.wantedArray copy];
    } else if (self.segmentOutlet.selectedSegmentIndex == 3){
        _searchArray = [self.noneController.noneArray copy];
    }
    
    [self.seenController.tableView setUserInteractionEnabled:NO];
    [self.theaterController.tableView setUserInteractionEnabled:NO];
    [self.wantedController.tableView setUserInteractionEnabled:NO];
    [self.noneController.tableView setUserInteractionEnabled:NO];

    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"Search Bar Should End Editing");
    [self.seenController.tableView setUserInteractionEnabled:YES];
    [self.theaterController.tableView setUserInteractionEnabled:YES];
    [self.wantedController.tableView setUserInteractionEnabled:YES];
    [self.noneController.tableView setUserInteractionEnabled:YES];
    
    return YES;
}

//Updates as user enters text
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
    NSMutableArray *finalResults = [NSMutableArray new];
    
    NSLog(@"%@", searchText);
    
    for (FilmModel *model in [_searchArray copy])
    {
        NSString *string = [model.title uppercaseString];
        if ([string hasPrefix:[searchText uppercaseString]])
        {
            [finalResults addObject:model];
        }
    }
    
    NSLog(@"%d", finalResults.count);
    
    if (searchText.length == 0) {
        return _searchArray;
    } else {
       return finalResults;
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
}


- (void)populateFilmData:(NSString *)zipCode
{
    _downloadQueue = [NSOperationQueue new];
    
    //self.seenItArray = [NSMutableArray new];
    
    if ([self doesArrayExist:kSEEN_IT_FILE]) {
        self.seenController.seenArray = [NSKeyedUnarchiver unarchiveObjectWithFile:self.seenItPath];
       // NSLog(@"Seen it Array: %d", self.seenItArray.count);
        NSLog(@"SEEN IT");
    } else {
        self.seenController.seenArray = [NSMutableArray new];
        NSLog(@"Created Seen");
        
    }
    
    if ([self doesArrayExist:kWANT_TO_FILE]) {
        self.wantedController.wantedArray = [NSKeyedUnarchiver unarchiveObjectWithFile:self.wantToSeeItPath];
        NSLog(@"WANT IT");
    } else {
        self.wantedController.wantedArray = [NSMutableArray new];
        NSLog(@"Created Want");
        
    }
    
    if ([self doesArrayExist:kDONT_WANT_IT_FILE]) {
        self.noneController.noneArray = [NSKeyedUnarchiver unarchiveObjectWithFile:self.dontWantToSeeItPath];
        NSLog(@"NO INTEREST");
    } else {
        self.noneController.noneArray = [NSMutableArray new];
        NSLog(@"Created No Interest");
    }
    
    NSDateFormatter *apiDateFormatter = [NSDateFormatter new];
    [apiDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *apiDateString = [apiDateFormatter stringFromDate:[NSDate date]];
    
    NSString *tmsString = [NSString stringWithFormat:@"http://data.tmsapi.com/v1/movies/showings?startDate=%@&zip=%@&imageSize=Sm&imageText=false&api_key=%@", apiDateString, zipCode, kTMS_API_KEY];
    
    NSURL *tmsURL = [NSURL URLWithString:tmsString];
    
    NSData *tmsData = [NSData dataWithContentsOfURL:tmsURL];
    
    NSError *error;
    
    NSArray *tmsArray = [NSJSONSerialization JSONObjectWithData:tmsData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    
    
    NSMutableArray *tmsInstance = [NSMutableArray new];
    
    for (NSDictionary *dictionary in tmsArray)
    {
        FilmModel *film = [FilmModel new];
        
        film.downloadQueue = self.downloadQueue;
        //film.isDownloading = NO;
        
        film.title = dictionary[@"title"];
        
        BOOL doesExist = [self doesFilmExist:film];
        
        film.synopsis = dictionary[@"shortDescription"];
        
        //Set the film's MPAA rating
        NSArray *ratingArray = [dictionary valueForKeyPath:@"ratings"];
        NSDictionary *ratingDictinary = ratingArray[0];
        NSString *rating = [ratingDictinary objectForKey:@"code"];
        
        if (rating) {
            film.mpaaRating = rating;
            film.ratingValue = [NSNumber numberWithInt:[self setRatingValue:film.mpaaRating]];
        } else {
            film.mpaaRating = @"NR";
            film.ratingValue = [NSNumber numberWithInt:0];
        }
        
        //Grab the URL for the thumbnail of the film's poster
        NSString *poster = [dictionary valueForKeyPath:@"preferredImage.uri"];
        film.thumbnailPoster = [NSString stringWithFormat:@"http://developer.tmsimg.com/%@?api_key=%@", poster, kTMS_API_KEY];
        //NSLog(@"%@", film.thumbnailPoster);
        
        film.genres = [dictionary valueForKey:@"genres"];
        
        film.runtime = [film runTimeConverter:[dictionary valueForKey:@"runTime"]];
        
        film.releaseDate = [film releaseDateConverter:[dictionary valueForKey:@"releaseDate"]];
        
        if (!doesExist) {
            [tmsInstance addObject:film];
        }
        
    }
    
    self.theaterController.theaterArray = tmsInstance;
    
    [self.theaterController.tableView reloadData];
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

#pragma mark - Checking if the film already exists

- (BOOL)doesFilmExist:(FilmModel *)film
{
    if ([self doesArrayExist:kSEEN_IT_FILE]) {
        NSArray *ratingCheck = [NSKeyedUnarchiver unarchiveObjectWithFile:self.seenItPath];
        for (FilmModel *check in ratingCheck) {
            if ([check.title isEqualToString:film.title]) {
                return YES;
            }
        }
    }
    
    if ([self doesArrayExist:kWANT_TO_FILE]) {
        NSArray *ratingCheck = [NSKeyedUnarchiver unarchiveObjectWithFile:self.wantToSeeItPath];
        for (FilmModel *check in ratingCheck) {
            if ([check.title isEqualToString:film.title]) {
                return YES;
            }
        }
    }
    
    if ([self doesArrayExist:kDONT_WANT_IT_FILE]) {
        NSArray *ratingCheck = [NSKeyedUnarchiver unarchiveObjectWithFile:self.dontWantToSeeItPath];
        for (FilmModel *check in ratingCheck) {
            if ([check.title isEqualToString:film.title]) {
                return YES;
            }
        }
    }
    
    return NO;
    
}

-(BOOL)doesArrayExist:(NSString *)arrayNameString
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSString *documentsPath = [documentsURL path];
    documentsPath = [documentsPath stringByAppendingPathComponent:arrayNameString];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        NSLog(@"FALSE");
        return FALSE;
    } else {
        //NSLog(@"TRUE");
        return TRUE;
    }
}

@end
