//
//  SFMovieDetailViewController.m
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/3/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFMovieDetailViewController.h"
#import "SynopsisTableViewController.h"

@interface SFMovieDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *myRatingTextLabel;

@property (weak, nonatomic) IBOutlet UITableView *detailSynopsis;
@property (nonatomic) UIView *selectionView;


@end

@implementation SFMovieDetailViewController

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
    
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    if ([self.film.interestStatus isEqualToNumber:@0] || [self.film.interestStatus isEqualToNumber:@5]) {
        [self loadSelectionInterface];
        
    }
    
    
    if (self.film.genres.count == 0) {
        NSString *urlString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies/%@.json?apikey=%@", self.film.rottenTomatoesID, kROTTEN_TOMATOES_API_KEY];
        
        NSURL *movieURL = [NSURL URLWithString:urlString];
        
        NSData *data = [NSData dataWithContentsOfURL:movieURL];
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *genreArray = [dictionary valueForKey:@"genres"];
        
        for (NSString *genreString in genreArray) {
            Genre *genre = [NSEntityDescription insertNewObjectForEntityForName:@"Genre" inManagedObjectContext:[CoreDataHelper managedContext]];
            
            genre.category = genreString;
            
            [self.film addNewGenreObject:genre];
        }
        
        NSArray *directorArray = [dictionary valueForKey:@"abridged_directors"];
        
        for (NSDictionary *directorDictionary in directorArray) {
            
            Director *director = [NSEntityDescription insertNewObjectForEntityForName:@"Director" inManagedObjectContext:[CoreDataHelper managedContext]];
            
            director.name = [directorDictionary valueForKey:@"name"];
            
            [self.film addNewDirectorObject:director];
        }

        self.film.studio = [dictionary valueForKey:@"studio"];
        [CoreDataHelper saveContext];
        
    }
    
//    //get the Image
//    UIImage *img = [UIImage imageNamed:@"PG 13"];
//    //create a UIImageView
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
//    imageView.frame = CGRectMake(50, 200, img.size.width, img.size.height);
//    [self.view addSubview:imageView];
//    
//    UIImage *img2 = [UIImage imageNamed:@"PG"];
//    //create a UIImageView
//    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:img2];
//    imageView2.frame = CGRectMake(250, 200, img2.size.width, img2.size.height);
//    [self.view addSubview:imageView2];
    [self.myRatingSliderOutlet addTarget:self action:@selector(saveSliderValue) forControlEvents:UIControlEventTouchUpInside];
    
    self.detailSynopsis.delegate = self;
    self.detailSynopsis.dataSource = self;
    
    //Set detail page title on Navigation Controller
    self.title = self.film.title;
    
    
    //    http://api.rottentomatoes.com/api/public/v1.0/movies/770672122/similar.json?apikey=[your_api_key]
    
//    NSString *similarMovies = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies/%@/similar.json?apikey=%@", _film.rottenID, kROTTEN_TOMATOES_API_KEY];
//    NSURL *similarURL = [NSURL URLWithString:similarMovies];
//    NSData *similarData = [NSData dataWithContentsOfURL:similarURL];
//    
//    NSLog(@"%@", similarMovies);
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewController:)];
    
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
	// Do any additional setup after loading the view.
    self.detailViewTitle.title = _film.title;
    [self setRatingImage:self.film.mpaaRating];
    
    self.movieSynopsis.text = _film.synopsis;
    self.moviePoster.image = [UIImage imageWithContentsOfFile:_film.thumbnailPosterLocation];
    self.filmRatingLabel.text = _film.mpaaRating;
    self.filmRuntimeLabel.text = [NSString stringWithFormat:@"%@ min.", [_film.runtime stringValue]];
    
    //Adding critic and audience ratings to detail view controller
    if (_film.criticScore) {
        if ([_film.criticScore integerValue] < 0) {
            self.criticRatingLabel.text = @"None";
        } else {
            self.criticRatingLabel.text =  [_film.criticScore stringValue];
        }
    } else {
        self.criticsLabel.hidden = TRUE;
        self.criticRatingLabel.hidden = TRUE;
    }
    
    if (_film.audienceScore) {
        if ([_film.audienceScore integerValue] < 0) {
            self.criticRatingLabel.text = @"None";
        } else {
            self.audienceRatingLabel.text = [_film.audienceScore stringValue];
        }
    } else {
        self.audienceLabel.hidden = TRUE;
        self.audienceRatingLabel.hidden = TRUE;
    }
    
    NSDateFormatter *releaseDateFormatter = [[NSDateFormatter alloc] init];
    [releaseDateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    if (_film.releaseDate) {
        self.releaseDateLabel.text = [NSString stringWithFormat:@"%@", [releaseDateFormatter stringFromDate:_film.releaseDate]];
    } else {
        self.releaseDateLabel.text = @"N/A";
    }
    
    if ([_film.interestStatus isEqual: @1]) {
        if (_film.userRating) {
            self.myRatingLabel.text = [_film.userRating stringValue];
            self.myRatingSliderOutlet.value = [_film.userRating intValue]/ 100.f;
        } else {
            self.myRatingLabel.text = @"50";
            self.myRatingSliderOutlet.value = .5;
        }

    } else {
        self.myRatingSliderOutlet.hidden = TRUE;
        self.myRatingLabel.hidden = TRUE;
        self.myRatingTextLabel.hidden = TRUE;
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:self.film.title
                                                      forKey:kGAIScreenName] build]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.film.synopsis;
    cell.textLabel.numberOfLines = 4;
    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    
    return cell;

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"synopsis"]) {
        [(SynopsisTableViewController *)segue.destinationViewController setSynopsisString:self.film.synopsis];
    }
}

#pragma mark - Button Actions

- (IBAction)shareAction:(id)sender {
}

- (IBAction)ratingsSliderInput:(id)sender {
    int rating = [self.myRatingSliderOutlet value] * 100;
    self.myRatingLabel.text = [[NSNumber numberWithInt:rating] stringValue];
    _film.userRating = [NSNumber numberWithInt:rating];
 
//    [CoreDataHelper saveContext];
}

-(void)saveSliderValue {
    [CoreDataHelper saveContext];
}

- (IBAction)dismissViewController:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setRatingImage:(NSString *)mpaaRating
{
    UIImage *image;
    
    if ([mpaaRating isEqualToString:@"G"]) {
        image = [UIImage imageNamed:@"G"];
    } else if ([mpaaRating isEqualToString:@"PG"]){
        image = [UIImage imageNamed:@"PG"];
    } else if ([mpaaRating isEqualToString:@"PG-13"]) {
        image = [UIImage imageNamed:@"PG 13"];
    } else if ([mpaaRating isEqualToString:@"R"]) {
        image = [UIImage imageNamed:@"R"];;
    } else {
        image = [UIImage imageNamed:@"NC 17"];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(126, 170, image.size.width, image.size.height);
    [self.view addSubview:imageView];
    
}

-(IBAction)twitterShareButton:(id)sender
{
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
//        SLComposeViewController *twitterController = [[SLComposeViewController alloc] init];
//        twitterController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//        
//        [twitterController setInitialText:[NSString stringWithFormat:@"I think we should go see %@", self.film.title]];
//        
//        [self presentViewController:twitterController animated:YES completion:nil];
//    }
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *facebookController = [[SLComposeViewController alloc] init];
        facebookController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [facebookController setInitialText:[NSString stringWithFormat:@"I think we should go see %@", self.film.title]];
        
        [self presentViewController:facebookController animated:YES completion:nil];
    }
}

#pragma mark - Choose Status

-(void)loadSelectionInterface {
    self.selectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, 50)];
    [self.view addSubview:self.selectionView];
    
    UIButton *interestedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    interestedButton.frame = CGRectMake(0, 0, 160, 60);
    [interestedButton addTarget:self action:@selector(interestedAction:) forControlEvents:UIControlEventTouchUpInside];
    [interestedButton setTitle:@"Want to See" forState:UIControlStateNormal];
    interestedButton.backgroundColor = [UIColor goColor];
    interestedButton.tag = 0;
    [self.selectionView addSubview:interestedButton];
    
    UIButton *notInterestedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    notInterestedButton.frame = CGRectMake(160, 0, 160, 60);
    [notInterestedButton addTarget:self action:@selector(interestedAction:) forControlEvents:UIControlEventTouchUpInside];
    [notInterestedButton setTitle:@"No Interest" forState:UIControlStateNormal];
    notInterestedButton.backgroundColor = [UIColor filmHeatPrimaryColor];
    notInterestedButton.tag = 1;
    [self.selectionView addSubview:notInterestedButton];
    
}

-(void)interestedAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 0) {
        self.film.interestStatus = @2;
        [CoreDataHelper saveContext];
        [self.selectionView removeFromSuperview];
    } else {
        self.film.interestStatus = @3;
        [CoreDataHelper saveContext];
        [self.selectionView removeFromSuperview];

    }
}
@end
