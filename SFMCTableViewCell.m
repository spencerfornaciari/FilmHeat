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
    
    
    if (film.myRating) {
        self.filmCriticsLabel.hidden = TRUE;
        self.myRatingLabel.text = [NSString stringWithFormat:@"My Rating: %@", film.myRating];
    }
    
    if (film.criticsRating) {
        self.filmCriticsLabel.hidden = FALSE;
        self.filmCriticsLabel.text = [NSString stringWithFormat:@"Critics: %@", [film.criticsRating stringValue]];
    }
    
    if (film.audienceRating) {
        self.filmAudiencesLabel.hidden = FALSE;
        self.filmAudiencesLabel.text = [NSString stringWithFormat:@"Audiences: %@", [film.audienceRating stringValue]];
    }
    
    UIImage *image = [self setRatingImage:film.mpaaRating];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(84, 34, image.size.width, image.size.height);
    [self addSubview:imageView];
    
    //UIImage *image = [UIImage imageWithContentsOfFile:[NSData dataWithContentsOfFile:film.posterImagePath]];
//
//    if (image) {
////        self.filmThumbnailPoster.image = image;
//        NSLog(@"%@: TRUE", film.title);
//    }
    
//    else {
//        if (!film.isDownloading) {
//            [film downloadPoster];
//        }
//    }
    
//    if (!image) {
//        self.filmThumbnailPoster.image = [UIImage imageNamed:@"Movies.png"];
//        //[film downloadPoster];
//       // NSLog(@"%@", film.thumbnailPoster);
//    } else {
//        self.filmThumbnailPoster.image = image;
//    }
}

-(UIImage *)setRatingImage:(NSString *)mpaaRating
{
    
    if ([mpaaRating isEqualToString:@"G"]) {
        return [UIImage imageNamed:@"G"];
    } else if ([mpaaRating isEqualToString:@"PG"]){
        return [UIImage imageNamed:@"PG"];
    } else if ([mpaaRating isEqualToString:@"PG-13"]) {
        return [UIImage imageNamed:@"PG 13"];
    } else if ([mpaaRating isEqualToString:@"R"]) {
        return [UIImage imageNamed:@"R"];;
    } else {
        return [UIImage imageNamed:@"NC 17"];
    }
    
}



@end
