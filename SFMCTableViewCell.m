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
    
    if (!self.ratingImage) {
        self.ratingImage = [self ratingImage:film.mpaaRating];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.ratingImage];
        imageView.frame = CGRectMake(84, 34, self.ratingImage.size.width, self.ratingImage.size.height);
        [self addSubview:imageView];
    }
    
    
    
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

-(UIImage *)ratingImage:(NSString *)mpaaRating
{
    
    if ([mpaaRating isEqualToString:@"G"]) {
        UIImage *image = [UIImage imageNamed:@"G"];
        return image;
    } else if ([mpaaRating isEqualToString:@"PG"]){
        UIImage *image = [UIImage imageNamed:@"PG"];
        return image;
    } else if ([mpaaRating isEqualToString:@"PG-13"]) {
        UIImage *image = [UIImage imageNamed:@"PG 13"];
        return image;
    } else if ([mpaaRating isEqualToString:@"R"]) {
        UIImage *image = [UIImage imageNamed:@"R"];
        return image;
    } else {
        UIImage *image = [UIImage imageNamed:@"NC 17"];
        return image;
    }
    
}



@end
