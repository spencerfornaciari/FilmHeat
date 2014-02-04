//
//  SFFilmTableViewCell.m
//  FilmHeat
//
//  Created by Spencer Fornaciari on 1/22/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFFilmTableViewCell.h"

@implementation SFFilmTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFilm:(FilmModel *)film
{
    _film = film;
    
    self.filmTitle.text = film.title;    
    
//    if ([film.runtime isEqualToNumber:@0]) {
//        self.filmMPAARating.text = @"NL";
//    } else {
//        self.filmMPAARating.text = [film.runtime stringValue];
//    }
    
    
    
//    if (![film.mpaaRating isEqualToString:@"NR"]) {
//        self.filmMPAARating.text = @"NR";
//    } else {
//        //self.filmMPAARating.text = film.mpaaRating;
//        NSLog(@"%@", film.mpaaRating);
//    }
//    //self.ratingVariance.textColor = [UIColor whiteColor];
    
    if (!film.posterImage) {
        self.filmThumbnailPoster.image = [UIImage imageNamed:@"Movies.png"];
        [film downloadPoster];
    } else {
        self.filmThumbnailPoster.image = film.posterImage;
    }
}

@end