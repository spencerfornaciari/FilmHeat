//
//  SFFilmModelDataController.m
//  FilmHeat
//
//  Created by Spencer Fornaciari on 1/22/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFFilmModelDataController.h"
#import "SFMovieDetailViewController.h"

#define ROTTEN_TOMATOES_API_KEY @"sxqdwkta4vvwcggqmm5ggja7"
#define TMS_API_KEY @"7f4sgppp533ecxvutkaqg243"

@interface SFFilmModelDataController () <UIScrollViewDelegate>


@end

@implementation SFFilmModelDataController

- (void)populateFilmData:(NSString *)zipCode
{
    _downloadQueue = [NSOperationQueue new];
    
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSString *filmHeatPath = [documentsURL path];
    self.seenItPath = [filmHeatPath stringByAppendingPathComponent:SEEN_IT_FILE];
    self.wantedPath = [filmHeatPath stringByAppendingPathComponent:WANT_TO_FILE];
    self.noInterestPath = [filmHeatPath stringByAppendingPathComponent:DONT_WANT_IT_FILE];
    
    if ([self doesArrayExist:SEEN_IT_FILE]) {
        self.seenItArray = [NSKeyedUnarchiver unarchiveObjectWithFile:self.seenItPath];
    } else {
        self.seenItArray = [NSMutableArray new];
        NSLog(@"Created Seen");

    }
    
    if ([self doesArrayExist:WANT_TO_FILE]) {
        self.wantedArray = [NSKeyedUnarchiver unarchiveObjectWithFile:self.wantedPath];
    } else {
        self.wantedArray = [NSMutableArray new];
        NSLog(@"Created Want");

    }

    if ([self doesArrayExist:DONT_WANT_IT_FILE]) {
        self.noInterestArray = [NSKeyedUnarchiver unarchiveObjectWithFile:self.noInterestPath];
    } else {
        self.noInterestArray = [NSMutableArray new];
        NSLog(@"Created No Interest");
    }
    
    NSDateFormatter *apiDateFormatter = [NSDateFormatter new];
    [apiDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *apiDateString = [apiDateFormatter stringFromDate:[NSDate date]];
    
    NSString *tmsString = [NSString stringWithFormat:@"http://data.tmsapi.com/v1/movies/showings?startDate=%@&zip=%@&imageSize=Sm&imageText=false&api_key=%@", apiDateString, zipCode, TMS_API_KEY];
    
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
        
        film.synopsis = dictionary[@"shortDescription"];
        
        //Set the film's MPAA rating
        
        NSArray *ratingArray = [dictionary valueForKeyPath:@"ratings"];
        NSDictionary *ratingDictinary = ratingArray[0];
        //NSLog(@"%@", ratingArray);
      
        NSString *rating = [ratingDictinary objectForKey:@"code"];
        
        //NSLog(@"%@: %@", film.title, rating);
        
      //  NSString *rating = ratingDictionary[@"code"];
       // NSLog(@"Rating: %@", rating);
        
        if (rating) {
            film.mpaaRating = rating;
            //NSLog(@"TRUE");
           NSLog(@"%@: %@", film.title, film.mpaaRating);
        } else {
            //NSLog(@"FALSE");
            film.mpaaRating = @"NR";
            NSLog(@"%@: %@", film.title, film.mpaaRating);

        }
        
        BOOL doesExist = [self doesFilmExist:film];
        
        
        

        
//        film.mpaaRating = [dictionary valueForKeyPath:@"ratings.code"];
//        NSLog(@"%@", film.mpaaRating);
        
        //Grab the URL for the thumbnail of the film's poster
        NSString *poster = [dictionary valueForKeyPath:@"preferredImage.uri"];
        film.thumbnailPoster = [NSString stringWithFormat:@"http://developer.tmsimg.com/%@?api_key=%@", poster, TMS_API_KEY];
        //NSLog(@"%@", film.thumbnailPoster);
        
        //[film.showtimes =
        
        //NSLog(@"%@", [dictionary valueForKeyPath:@"showtimes.theatre.name"]);
//        NSString *thisDate = [dictionary valueForKeyPath:@"showtimes.dateTime"];
        
//        NSDateFormatter *newForm = [NSDateFormatter new];
//        [newForm setDateFormat:@"yyyy-MM-dd"];
//        NSLog(@"%@", thisDate);

        film.genres = [dictionary valueForKey:@"genres"];
        
        film.runtime = [film runTimeConverter:[dictionary valueForKey:@"runTime"]];
//
        film.releaseDate = [film releaseDateConverter:[dictionary valueForKey:@"releaseDate"]];
    
//        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
//        [dateFormatter2 setDateStyle:NSDateFormatterShortStyle];
//        NSLog(@"%@", [dateFormatter2 stringFromDate:film.releaseDate]);

//        if ([self doesSeenItArrayExist])
//        {
//            if ([self.seenItArray containsObject:film.title]) {
//                NSLog(@"Got it!");
//            } else {
//            }
//        }
        
        if (!doesExist) {
            [rottenInstance addObject:film];
        }
       
    }
    

//    


    
   // NSArray *myArray = [[NSArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.seenItPath]];
    
    
//    for (int i=0; i<5; i++) {
//        FilmModel *film = self.seenItArray[i];
//        film.wantsToSee = YES;
//    }

//    if ([self doesSeenItArrayExist]) {
//        
//        
//        self.seenItArray = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.seenItPath]];
//        NSLog(@"%@", self.seenItArray);
//    } else {
//        
//        NSPredicate *wantedPredicate = [NSPredicate predicateWithFormat:@"hasSeen = TRUE"];
//        self.seenItArray = [_rottenTomatoesArray filteredArrayUsingPredicate:wantedPredicate];
//    }

    
    _rottenTomatoesArray = rottenInstance;
    [self.tableView reloadData];
}

#pragma mark - Checking if the film already exists

- (BOOL)doesFilmExist:(FilmModel *)film
{
    if ([self doesArrayExist:SEEN_IT_FILE]) {
        NSArray *ratingCheck = [NSKeyedUnarchiver unarchiveObjectWithFile:self.seenItPath];
        for (FilmModel *check in ratingCheck) {
            if ([check.title isEqualToString:film.title]) {
                return YES;
            }
        }
    }
    
    if ([self doesArrayExist:WANT_TO_FILE]) {
        NSArray *ratingCheck = [NSKeyedUnarchiver unarchiveObjectWithFile:self.wantedPath];
        for (FilmModel *check in ratingCheck) {
            if ([check.title isEqualToString:film.title]) {
                return YES;
            }
        }
    }
    
    if ([self doesArrayExist:DONT_WANT_IT_FILE]) {
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
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        // Setting the background color of the cell.
        //cell.contentView.backgroundColor = [UIColor whiteColor];
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
        
        //[self deleteCell:cell];
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

//- (NSArray *)wantedArray
//{
//    NSPredicate *wantedPredicate = [NSPredicate predicateWithFormat:@"wantsToSee = TRUE"];
//    return [_rottenTomatoesArray filteredArrayUsingPredicate:wantedPredicate];
//}

//- (NSArray *)seenItArray
//{
////    NSMutableArray *seenFilmsArray = [NSMutableArray new];
////    for (FilmModel *film in _rottenTomatoesArray) {
////        if (film.hasSeen) {
////            [seenFilmsArray addObject:film];
////        }
////    }
////    
////    return seenFilmsArray;
//    
//    
//
//    
//    
//}

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
        //NSLog(@"FALSE");
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
    [NSKeyedArchiver archiveRootObject:self.seenItArray toFile:_seenItPath];
    [array removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.delegate enableSegment:0];
    //[self.tableView reloadData];
    

}

-(void)addToWantedList:(MCSwipeTableViewCell *)cell selectedArray:(NSMutableArray *)array
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.wantedArray addObject:array[indexPath.row]];
    [NSKeyedArchiver archiveRootObject:self.wantedArray toFile:_wantedPath];
    [array removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.delegate enableSegment:2];
}

-(void)addToNoInterestList:(MCSwipeTableViewCell *)cell selectedArray:(NSMutableArray *)array
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.noInterestArray addObject:array[indexPath.row]];
    [NSKeyedArchiver archiveRootObject:self.noInterestArray toFile:_noInterestPath];
    [array removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    if (self.noInterestArray.count > 0) {
        [self.delegate enableSegment:3];
    } else {
        [self.delegate disableSegment:3];
    }
    [self.delegate enableSegment:3];
}


@end