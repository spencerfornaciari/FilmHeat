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
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.detailViewTitle.title = _film.title;
    
    self.movieSynopsis.text = _film.synopsis;
    self.moviePoster.image = _film.posterImage;
    
    NSDateFormatter *releaseDateFormatter = [[NSDateFormatter alloc] init];
    [releaseDateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    if (_film.releaseDate) {
        self.releaseDateLabel.text = [NSString stringWithFormat:@"%@", [releaseDateFormatter stringFromDate:_film.releaseDate]];
    } else {
        self.releaseDateLabel.text = @"N/A";
    }
    NSLog(@"%d", _film.myRating);

    if (_film.myRating) {
        self.myRatingLabel.text = [[NSNumber numberWithInt:_film.myRating] stringValue];
        self.myRatingSliderOutlet.value = _film.myRating / 100.f;
    } else {
        self.myRatingLabel.text = @"50";
        self.myRatingSliderOutlet.value = .5;
    }
    
    if (!_film.hasSeen) {
        self.myRatingSliderOutlet.hidden = TRUE;
        self.myRatingLabel.hidden = TRUE;
        self.myRatingTextLabel.hidden = TRUE;
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
    NSLog(@"%f", self.myRatingSliderOutlet.value);
    _film.myRating = rating;
    
}
- (IBAction)dismissViewController:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setFilm:(FilmModel *)film
{
    _film = film;
    
}

@end
