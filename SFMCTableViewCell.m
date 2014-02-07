//
//  SFMCTableViewCell.m
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/5/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFMCTableViewCell.h"

@implementation SFMCTableViewCell

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
    
    self.filmMPAARating.text = film.mpaaRating;
    
    UIImage *image = [UIImage imageWithContentsOfFile:[NSData dataWithContentsOfFile:film.posterImagePath]];
    
    if (!image) {
        self.filmThumbnailPoster.image = [UIImage imageNamed:@"Movies.png"];
        //[film downloadPoster];
       // NSLog(@"%@", film.thumbnailPoster);
    } else {
        self.filmThumbnailPoster.image = image;
    }
}





@end
