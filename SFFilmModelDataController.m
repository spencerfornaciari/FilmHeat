//
//  SFFilmModelDataController.m
//  FilmHeat
//
//  Created by Spencer Fornaciari on 1/22/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFFilmModelDataController.h"
#import "SFMovieDetailViewController.h"

@interface SFFilmModelDataController () <UIScrollViewDelegate>

@end

@implementation SFFilmModelDataController

- (void)populateFilmData:(NSString *)zipCode
{
    _downloadQueue = [NSOperationQueue new];
    
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSString *filmHeatPath = [documentsURL path];
    self.seenItPath = [filmHeatPath stringByAppendingPathComponent:kSEEN_IT_FILE];
    self.wantedPath = [filmHeatPath stringByAppendingPathComponent:kWANT_TO_FILE];
    self.noInterestPath = [filmHeatPath stringByAppendingPathComponent:kDONT_WANT_IT_FILE];
    
    //self.seenItArray = [NSMutableArray new];
    
    if ([self doesArrayExist:kSEEN_IT_FILE]) {
        self.seenItArray = [NSKeyedUnarchiver unarchiveObjectWithFile:self.seenItPath];
        NSLog(@"Seen it Array: %d", self.seenItArray.count);
        NSLog(@"SEEN IT");
    } else {
        self.seenItArray = [NSMutableArray new];
        NSLog(@"Created Seen");

    }
    
    if ([self doesArrayExist:kWANT_TO_FILE]) {
        self.wantedArray = [NSKeyedUnarchiver unarchiveObjectWithFile:self.wantedPath];
        NSLog(@"WANT IT");
    } else {
        self.wantedArray = [NSMutableArray new];
        NSLog(@"Created Want");

    }

    if ([self doesArrayExist:kDONT_WANT_IT_FILE]) {
        self.noInterestArray = [NSKeyedUnarchiver unarchiveObjectWithFile:self.noInterestPath];
        NSLog(@"NO INTEREST");
    } else {
        self.noInterestArray = [NSMutableArray new];
        NSLog(@"Created No Interest");
    }
    
    NSDateFormatter *apiDateFormatter = [NSDateFormatter new];
    [apiDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *apiDateString = [apiDateFormatter stringFromDate:[NSDate date]];
    
    NSString *tmsString = [NSString stringWithFormat:@"http://data.tmsapi.com/v1/movies/showings?startDate=%@&zip=%@&imageSize=Sm&imageText=false&api_key=%@", apiDateString, zipCode, kTMS_API_KEY];
    
    NSURL *tmsURL = [NSURL URLWithString:tmsString];
    
    NSData *tmsData = [NSData dataWithContentsOfURL:tmsURL];
    
    NSError *error;
    
    NSArray *tmsArray = [NSJSONSerialization JSONObjectWithData:tmsData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    
    
    NSMutableArray *rottenInstance = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in tmsArray)
    {
        FilmModel *film = [FilmModel new];
        
        film.downloadQueue = self.downloadQueue;
        //film.isDownloading = NO;
        
        film.title = dictionary[@"title"];
        
        BOOL doesExist = [self doesFilmExist:film];
        
        film.synopsis = dictionary[@"shortDescription"];
        
        //Set the film's MPAA rating
        NSArray *ratingArray = [dictionary valueForKeyPath:@"ratings"];
        NSDictionary *ratingDictinary = ratingArray[0];
        NSString *rating = [ratingDictinary objectForKey:@"code"];

        if (rating) {
            film.mpaaRating = rating;
            film.ratingValue = [NSNumber numberWithInt:[self setRatingValue:film.mpaaRating]];
        } else {
            film.mpaaRating = @"NR";
            film.ratingValue = [NSNumber numberWithInt:0];
        }
        
        //Grab the URL for the thumbnail of the film's poster
        NSString *poster = [dictionary valueForKeyPath:@"preferredImage.uri"];
        film.thumbnailPoster = [NSString stringWithFormat:@"http://developer.tmsimg.com/%@?api_key=%@", poster, kTMS_API_KEY];
        //NSLog(@"%@", film.thumbnailPoster);

        film.genres = [dictionary valueForKey:@"genres"];
        
        film.runtime = [film runTimeConverter:[dictionary valueForKey:@"runTime"]];

        film.releaseDate = [film releaseDateConverter:[dictionary valueForKey:@"releaseDate"]];
        
        if (!doesExist) {
            [rottenInstance addObject:film];
        }
       
    }
    
    _rottenTomatoesArray = rottenInstance;
    [self.tableView reloadData];
}

-(NSInteger)setRatingValue:(NSString *)mpaaRating
{
    if ([mpaaRating isEqualToString:@"G"]) {
        return 1;
    } else if ([mpaaRating isEqualToString:@"PG"]){
        return 2;
    } else if ([mpaaRating isEqualToString:@"PG-13"]) {
        return 3;
    } else if ([mpaaRating isEqualToString:@"R"]) {
        return 4;
    } else {
        return 5;
    }
}

#pragma mark - Checking if the film already exists

- (BOOL)doesFilmExist:(FilmModel *)film
{
    if ([self doesArrayExist:kSEEN_IT_FILE]) {
        NSArray *ratingCheck = [NSKeyedUnarchiver unarchiveObjectWithFile:self.seenItPath];
        for (FilmModel *check in ratingCheck) {
            if ([check.title isEqualToString:film.title]) {
                return YES;
            }
        }
    }
    
    if ([self doesArrayExist:kWANT_TO_FILE]) {
        NSArray *ratingCheck = [NSKeyedUnarchiver unarchiveObjectWithFile:self.wantedPath];
        for (FilmModel *check in ratingCheck) {
            if ([check.title isEqualToString:film.title]) {
                return YES;
            }
        }
    }
    
    if ([self doesArrayExist:kDONT_WANT_IT_FILE]) {
        NSArray *ratingCheck = [NSKeyedUnarchiver unarchiveObjectWithFile:self.noInterestPath];
        for (FilmModel *check in ratingCheck) {
            if ([check.title isEqualToString:film.title]) {
                return YES;
            }
        }
    }
    
    return NO;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (_selectedSegment) {
        case 0: // Seen It
            return self.seenItArray.count;
        case 1: // All Movies
            return self.rottenTomatoesArray.count;
        case 2: // Want To See It
            return self.wantedArray.count;
        case 3:
            return self.noInterestArray.count;
    }

    return 0;
    //NSLog(@"%lu", (unsigned long)_rottenTomatoesArray.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFMCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (!cell) {
        cell = [[SFMCTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        
        // Remove inset of iOS 7 separators.
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        
        // Setting the background color of the cell.
        cell.contentView.backgroundColor = [UIColor redColor];
    }
    
    NSMutableArray *selectedArray = [NSMutableArray new];
    
    switch (_selectedSegment) {
        case 0: // Seen It
            [cell setFilm:[self.seenItArray objectAtIndex:indexPath.row]];
            selectedArray = self.seenItArray;
            break;
        case 1: // All Movies
            [cell setFilm:[self.rottenTomatoesArray objectAtIndex:indexPath.row]];
            selectedArray = self.rottenTomatoesArray;
            break;
        case 2: // Want To See It
            [cell setFilm:[self.wantedArray objectAtIndex:indexPath.row]];
            selectedArray = self.wantedArray;
            break;
        case 3:
            [cell setFilm:[self.noInterestArray objectAtIndex:indexPath.row]];
            selectedArray = self.noInterestArray;
            break;
    }
    
    // Configuring the views and colors.
    UIView *checkView = [self viewWithImageName:@"Checkbox"];
    UIView *crossView = [self viewWithImageName:@"List"];
    UIView *clockView = [self viewWithImageName:@"Sad_Face"];
    UIView *listView = [self viewWithImageName:@"Movies"];
    
    // Setting the default inactive state color to the tableView background color.
    [cell setDefaultColor:self.tableView.backgroundView.backgroundColor];
    
    // Adding gestures per state basis.
    [cell setSwipeGestureWithView:checkView color:[UIColor seenItColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Checkbox\" cell");
        [self addToSeenItList:cell selectedArray:selectedArray];
    }];
    
    [cell setSwipeGestureWithView:crossView color:[UIColor wantedColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState2 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"List\" cell");
        [self addToWantedList:cell selectedArray:selectedArray];
    }];
    
    [cell setSwipeGestureWithView:clockView color:[UIColor noInterestColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Sad_Face\" cell");
        [self addToNoInterestList:cell selectedArray:selectedArray];
    }];
    
    [cell setSwipeGestureWithView:listView color:[UIColor theaterColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState4 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Movies\" cell");
        
    }];
    
    return cell;
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

- (void)setSelectedSegment:(NSInteger)selectedSegment
{    
    _selectedSegment = selectedSegment;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedSegment == 0) {
        [self.delegate selectedFilm:self.seenItArray[indexPath.row]];
    } else if (_selectedSegment == 1)
    {
        [self.delegate selectedFilm:self.rottenTomatoesArray[indexPath.row]];
    } else if (_selectedSegment == 2)
    {
        [self.delegate selectedFilm:self.wantedArray[indexPath.row]];
    } else if (_selectedSegment == 3)
    {
        [self.delegate selectedFilm:self.noInterestArray[indexPath.row]];
    }
    
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   // NSLog(@"Did Scroll");
    [self.delegate scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"Did End");
    [self.delegate scrollViewDidEndDecelerating:scrollView];
}


-(BOOL)doesArrayExist:(NSString *)arrayNameString
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSString *documentsPath = [documentsURL path];
    documentsPath = [documentsPath stringByAppendingPathComponent:arrayNameString];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        NSLog(@"FALSE");
        return FALSE;
    } else {
        //NSLog(@"TRUE");
        return TRUE;
    }
}

-(void)addToSeenItList:(MCSwipeTableViewCell *)cell selectedArray:(NSMutableArray *)array
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.seenItArray addObject:array[indexPath.row]];
    NSLog(@"Seen it count: %d", self.seenItArray.count);
    
    [NSKeyedArchiver archiveRootObject:self.seenItArray toFile:_seenItPath];
    [array removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    if (self.seenItArray.count > 0) {
        [self.delegate enableSegment:0];
    } else {
        [self.delegate disableSegment:0];
    }
}

-(void)addToWantedList:(MCSwipeTableViewCell *)cell selectedArray:(NSMutableArray *)array
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.wantedArray addObject:array[indexPath.row]];
    NSLog(@"Wanted count: %d", self.wantedArray.count);
    
    [NSKeyedArchiver archiveRootObject:self.wantedArray toFile:_wantedPath];
    [array removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    if (self.wantedArray.count > 0) {
        [self.delegate enableSegment:2];
    } else {
        [self.delegate disableSegment:2];
    }
}

-(void)addToNoInterestList:(MCSwipeTableViewCell *)cell selectedArray:(NSMutableArray *)array
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.noInterestArray addObject:array[indexPath.row]];
    NSLog(@"No interest count: %d", self.noInterestArray.count);
    
    [NSKeyedArchiver archiveRootObject:self.noInterestArray toFile:_noInterestPath];
    [array removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    if (self.noInterestArray.count > 0) {
        [self.delegate enableSegment:3];
    } else {
        [self.delegate disableSegment:3];
    }
}


@end