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
    
    NSString *rottenString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=%@&q=%@&page_limit=1", kROTTEN_TOMATOES_API_KEY, self.film.title];
    rottenString = [rottenString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    NSURL *rottenURL = [NSURL URLWithString:rottenString];
    
    NSData *rottenData = [NSData dataWithContentsOfURL:rottenURL];
    
    NSError *error;
    
    NSDictionary *rottenDictionary = [NSJSONSerialization JSONObjectWithData:rottenData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];

    NSString *criticsRating = [rottenDictionary valueForKeyPath:@"movies.ratings.critics_score"];
    self.film.criticsRating = criticsRating;
    NSString *audienceRating = [rottenDictionary valueForKeyPath:@"movies.ratings.audience_score"];
    self.film.audienceRating = audienceRating;
    
    NSLog(@"Critics: %@, Audience: %@", criticsRating, audienceRating);
    
    
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.detailViewTitle.title = _film.title;
    
    self.movieSynopsis.text = _film.synopsis;
    self.moviePoster.image = _film.posterImage;
    self.filmRatingLabel.text = _film.mpaaRating;
    
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
