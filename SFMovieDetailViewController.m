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
    self.moviePoster.image = _film.posterImage;
    self.filmRatingLabel.text = _film.mpaaRating;
    self.filmRuntimeLabel.text = [NSString stringWithFormat:@"%@ min.", [_film.runtime stringValue]];
    
    //Adding critic and audience ratings to detail view controller
    if (self.film.criticsRating) {
        if ([self.film.criticsRating integerValue] < 0) {
            self.criticRatingLabel.text = @"None";
        } else {
            self.criticRatingLabel.text =  [self.film.criticsRating stringValue];
        }
    } else {
        self.criticsLabel.hidden = TRUE;
        self.criticRatingLabel.hidden = TRUE;
    }
    
    if (self.film.audienceRating) {
        if ([self.film.audienceRating integerValue] < 0) {
            self.criticRatingLabel.text = @"None";
        } else {
            self.audienceRatingLabel.text = [self.film.audienceRating stringValue];
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
    
    if (!_film.hasSeen) {
        self.myRatingSliderOutlet.hidden = TRUE;
        self.myRatingLabel.hidden = TRUE;
        self.myRatingTextLabel.hidden = TRUE;
    } else {
        if (_film.myRating) {
            self.myRatingLabel.text = _film.myRating;
            self.myRatingSliderOutlet.value = [_film.myRating intValue]/ 100.f;
        } else {
            self.myRatingLabel.text = @"50";
            self.myRatingSliderOutlet.value = .5;
        }
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:[NSString stringWithFormat:@"Movie Detail View: %@", self.film.title]];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
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

- (IBAction)ratingsSliderInput:(id)sender {
    int rating = [self.myRatingSliderOutlet value] * 100;
    self.myRatingLabel.text = [[NSNumber numberWithInt:rating] stringValue];
    _film.myRating = [[NSNumber numberWithInt:rating] stringValue];
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
@end
