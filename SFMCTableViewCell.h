//
//  SFMCTableViewCell.h
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/5/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "MCSwipeTableViewCell.h"
#import "FilmModel.h"

@interface SFMCTableViewCell : MCSwipeTableViewCell

@property (strong, nonatomic) IBOutlet UILabel *filmTitle;
@property (strong, nonatomic) IBOutlet UIImageView *filmThumbnailPoster;
@property (strong, nonatomic) IBOutlet UILabel *filmMPAARating;

- (void)setFilm:(FilmModel *)film;

@end