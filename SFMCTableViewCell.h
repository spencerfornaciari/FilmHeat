//
//  SFMCTableViewCell.h
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/5/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFAppDelegate.h"
#import "MCSwipeTableViewCell.h"
#import "CoreDataHelper.h"
#import "Film.h"

@interface SFMCTableViewCell : MCSwipeTableViewCell

@property (weak, nonatomic) Film *film;

@property (strong, nonatomic) UIImage *ratingImage;
@property (strong, nonatomic) IBOutlet UILabel *filmTitle;
@property (strong, nonatomic) IBOutlet UIImageView *filmThumbnailPoster;
@property (strong, nonatomic) IBOutlet UILabel *myRatingLabel;
@property (strong, nonatomic) IBOutlet UILabel *filmCriticsLabel;
@property (strong, nonatomic) IBOutlet UILabel *filmAudiencesLabel;
@property (nonatomic) UIImageView *ratingsImageView;


- (void)setFilm:(Film *)film;
- (UIImage *)ratingImage:(NSString *)mpaaRating;

-(void)downloadPosterFromFilm:(Film *)film andReturn:(void (^)(UIImage *poster))callbackImage;

@end