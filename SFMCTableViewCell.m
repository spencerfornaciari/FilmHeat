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

- (void)setFilm:(Film *)film
{
    _film = film;
    
    self.filmTitle.text = film.title;
    
    if (film.ratingValue) {
        self.filmCriticsLabel.hidden = TRUE;
        self.myRatingLabel.text = [NSString stringWithFormat:@"My Rating: %@", film.ratingValue];
    }
    
    if (film.criticRating) {
        self.filmCriticsLabel.hidden = FALSE;
        self.filmCriticsLabel.text = [NSString stringWithFormat:@"Critics: %@", [film.criticScore stringValue]];
    }
    
    if (film.audienceRating) {
        self.filmAudiencesLabel.hidden = FALSE;
        self.filmAudiencesLabel.text = [NSString stringWithFormat:@"Audiences: %@", [film.audienceScore stringValue]];
    }
    
    if (!self.ratingImage) {
//        self.ratingImage = [self getRatingImage:film.ratingValue];
        self.ratingImage = [self ratingImage:film.mpaaRating];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.ratingImage];
        imageView.frame = CGRectMake(84, 34, self.ratingImage.size.width, self.ratingImage.size.height);
        [self addSubview:imageView];
    }
    
    if (!film.thumbnailPosterLocation) {
        UIImage *image = [UIImage imageWithContentsOfFile:[NSData dataWithContentsOfFile:film.thumbnailPosterURL]];
        NSData *posterData = UIImageJPEGRepresentation(image, 1);
        
        NSString *posterLocation = [NSString stringWithFormat:@"%@/%@.jpg", [self documentsDirectoryPath], [film.title stringByReplacingOccurrencesOfString:@":" withString:@""]];
        film.thumbnailPosterLocation = posterLocation;
        
        [posterData writeToFile:film.thumbnailPosterLocation atomically:YES];

    } else {
        self.filmThumbnailPoster.image = [UIImage imageWithContentsOfFile:film.thumbnailPosterLocation];
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

-(UIImage *)getRatingImage:(NSNumber *)rating
{
    
    if ([rating integerValue] == 1) {
        UIImage *image = [UIImage imageNamed:@"G"];
        return image;
    } else if ([rating integerValue] == 2){
        UIImage *image = [UIImage imageNamed:@"PG"];
        return image;
    } else if ([rating integerValue] == 3) {
        UIImage *image = [UIImage imageNamed:@"PG 13"];
        return image;
    } else if ([rating integerValue] == 4) {
        UIImage *image = [UIImage imageNamed:@"R"];
        return image;
    } else {
        UIImage *image = [UIImage imageNamed:@"NC 17"];
        return image;
    }
    
}

- (NSString *)documentsDirectoryPath
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentsURL path];
}

@end
