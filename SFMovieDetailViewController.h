//
//  SFMovieDetailViewController.h
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/3/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "CoreDataHelper.h"
#import "Film.h"
#import "Actor.h"
#import "Character.h"
#import "Director.h"
#import "Genre.h"
#import "Constants.h"
#import "UIColor+SFFilmHeatColors.h"

@interface SFMovieDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *moviePoster;
@property (weak, nonatomic) IBOutlet UITextView *movieSynopsis;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *filmRatingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *filmRatingImageView;


@property (weak, nonatomic) IBOutlet UILabel *filmRuntimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *criticRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *criticsLabel;

@property (weak, nonatomic) IBOutlet UILabel *audienceRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *audienceLabel;


@property (weak, nonatomic) IBOutlet UINavigationItem *detailViewTitle;


@property (weak, nonatomic) IBOutlet UILabel *myRatingLabel;
@property (weak, nonatomic) IBOutlet UISlider *myRatingSliderOutlet;

@property (weak, nonatomic) Film *film;
- (IBAction)shareAction:(id)sender;

- (IBAction)ratingsSliderInput:(id)sender;

@end