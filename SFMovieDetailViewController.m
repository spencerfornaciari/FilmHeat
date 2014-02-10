//
//  SFMovieDetailViewController.m
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/3/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFMovieDetailViewController.h"

@interface SFMovieDetailViewController ()

- (IBAction)dismissViewController:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *myRatingTextLabel;



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
    
    //Grabbing and parsing Rotten Tomatoes data for individual films
    NSString *rottenString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=%@&q=%@&page_limit=1", kROTTEN_TOMATOES_API_KEY, self.film.title];
    rottenString = [rottenString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *rottenURL = [NSURL URLWithString:rottenString];
    
    NSData *rottenData = [NSData dataWithContentsOfURL:rottenURL];
    NSLog(@"%@", rottenURL);
    
    NSError *error;
    
    NSDictionary *rottenDictionary = [NSJSONSerialization JSONObjectWithData:rottenData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    
    NSArray *rottenArray = [rottenDictionary objectForKey:@"movies"];
    
    if (rottenArray.count == 0) {
        NSLog(@"DEAD END");

    } else {
        self.film.criticsRating = [rottenArray[0] valueForKeyPath:@"ratings.critics_score"];
        self.film.audienceRating = [rottenArray[0] valueForKeyPath:@"ratings.audience_score"];
    }
    
	// Do any additional setup after loading the view.
    self.detailViewTitle.title = _film.title;
    
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
    
    
    //    if (_film.criticsRating) {// && [_film.criticsRating integerValue] > 0) {
    //       // NSLog(@"%ld", [NSNumber number _film.criticsRating integerValue]);
    //        self.criticRatingLabel.text = _film.criticsRating;
    //    }
    //
    //    if (_film.audienceRating) {// && [_film.audienceRating integerValue] > 0) {
    //        NSLog(@"%@", _film.audienceRating);
    //    }
    
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
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ratingsSliderInput:(id)sender {
    int rating = [self.myRatingSliderOutlet value] * 100;
    self.myRatingLabel.text = [[NSNumber numberWithInt:rating] stringValue];
    _film.myRating = [[NSNumber numberWithInt:rating] stringValue];
}
- (IBAction)dismissViewController:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setFilm:(FilmModel *)film
{
    _film = film;
    
}

@end
