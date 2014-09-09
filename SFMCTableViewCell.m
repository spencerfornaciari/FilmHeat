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
//        self.ratingView = [[UIImageView alloc] initWithFrame:CGRectMake(84, 34, self.ratingImage.size.width, self.ratingImage.size.height)];
//        imageView.frame = CGRectMake(84, 34, self.ratingImage.size.width, self.ratingImage.size.height);
//        [self addSubview:imageView];
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
    if (self.ratingsImageView) {
        
    } else {
        self.ratingsImageView = [[UIImageView alloc] init];
        [self addSubview:self.ratingsImageView];
    }
    
    self.filmTitle.text = film.title;
    
    if ([film.interestStatus isEqual:@1]) {
        self.filmCriticsLabel.hidden = TRUE;
        self.filmAudiencesLabel.hidden = TRUE;
        
        self.myRatingLabel.hidden = FALSE;
        self.myRatingLabel.text = [NSString stringWithFormat:@"My Rating: %@", film.userRating];
    } else {
        self.myRatingLabel.hidden = TRUE;
        
        self.filmCriticsLabel.hidden = FALSE;
        self.filmCriticsLabel.text = [NSString stringWithFormat:@"Critics: %@", [film.criticScore stringValue]];
        
        self.filmAudiencesLabel.hidden = FALSE;
        self.filmAudiencesLabel.text = [NSString stringWithFormat:@"Audiences: %@", [film.audienceScore stringValue]];
    }
    
//    if (film.criticRating) {
//        self.filmCriticsLabel.hidden = FALSE;
//        self.filmCriticsLabel.text = [NSString stringWithFormat:@"Critics: %@", [film.criticScore stringValue]];
//    }
//    
//    if (film.audienceRating) {
//        self.filmAudiencesLabel.hidden = FALSE;
//        self.filmAudiencesLabel.text = [NSString stringWithFormat:@"Audiences: %@", [film.audienceScore stringValue]];
//    }
    
    if (film.mpaaRating) {
        self.ratingImage = [self ratingImage:film.mpaaRating];
        self.ratingsImageView.frame = CGRectMake(84, 34, self.ratingImage.size.width, self.ratingImage.size.height);
        self.ratingsImageView.image = self.ratingImage;
    }
    
    if ([film.thumbnailAvailable isEqualToNumber:@1]) {
        self.filmThumbnailPoster.image = [UIImage imageWithContentsOfFile:film.thumbnailPosterLocation];
    } else {
        NSOperationQueue *queue = [(SFAppDelegate *)[[UIApplication sharedApplication] delegate] queue];
        
        [queue addOperationWithBlock:^{
            NSURL *url = [NSURL URLWithString:film.thumbnailPosterURL];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            NSString *posterLocation = [NSString stringWithFormat:@"%@/%@.jpg", [self documentsDirectoryPath], film.rottenTomatoesID];
            film.thumbnailPosterLocation = posterLocation;
            
            [data writeToFile:film.thumbnailPosterLocation atomically:YES];
            film.thumbnailAvailable = @1;
            
            [CoreDataHelper saveContext];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.filmThumbnailPoster.image = image;
            }];
        }];
    }
    
}

-(void)downloadPosterFromFilm:(Film *)film andReturn:(void (^)(UIImage *poster))callbackImage {
  
    NSOperationQueue *queue = [NSOperationQueue new];
    
    [queue addOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:film.thumbnailPosterURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *posterLocation = [NSString stringWithFormat:@"%@/%@.jpg", [self documentsDirectoryPath], film.rottenTomatoesID];
        film.thumbnailPosterLocation = posterLocation;
        
        [data writeToFile:film.thumbnailPosterLocation atomically:YES];
        film.thumbnailAvailable = @1;
        [CoreDataHelper saveContext];
        
        callbackImage(image);
    }];
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

- (NSString *)documentsDirectoryPath
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentsURL path];
}

@end
