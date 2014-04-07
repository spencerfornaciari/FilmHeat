//
//  SFMovieDetailViewController.h
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/3/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilmModel.h"
#import "Constants.h"

@interface SFMovieDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *moviePoster;
@property (weak, nonatomic) IBOutlet UITextView *movieSynopsis;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *filmRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *filmRuntimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *criticRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *criticsLabel;

@property (weak, nonatomic) IBOutlet UILabel *audienceRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *audienceLabel;


@property (weak, nonatomic) IBOutlet UINavigationItem *detailViewTitle;


@property (weak, nonatomic) IBOutlet UILabel *myRatingLabel;
@property (weak, nonatomic) IBOutlet UISlider *myRatingSliderOutlet;

@property (weak, nonatomic) FilmModel *film;

- (IBAction)ratingsSliderInput:(id)sender;

@end