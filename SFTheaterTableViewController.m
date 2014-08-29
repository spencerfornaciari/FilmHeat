//
//  SFTheaterTableViewController.m
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/6/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFTheaterTableViewController.h"
#import "SFFilmModelDataController.h"
#import "SFMovieDetailViewController.h"
#import "SFMCTableViewCell.h"

@interface SFTheaterTableViewController ()

@property (nonatomic, strong) SFFilmModelDataController *controller;
@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@property (nonatomic) FilmModel *currentFilm;

@end

@implementation SFTheaterTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, -52, 0);
    
    self.downloadQueue = [NSOperationQueue new];
//    
//    self.theaterArray = self.controller.rottenTomatoesArray;
//    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable:)
                                                 name:@"reload"
                                               object:nil];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"Theater View"
                                                      forKey:kGAIScreenName] build]];
    
    NSMutableArray *ratingFilterArray = [NSMutableArray new];
    
    for (FilmModel *film in self.strongArray) {
        if ([film.ratingValue integerValue] >= [[NSUserDefaults standardUserDefaults] integerForKey:@"mpaaRatingThreshold"] && [film.criticsRating integerValue] >= [[NSUserDefaults standardUserDefaults] integerForKey:@"criticThreshold"] && [film.audienceRating integerValue] >= [[NSUserDefaults standardUserDefaults] integerForKey:@"audienceThreshold"] && [film.ratingVariance integerValue] <= [[NSUserDefaults standardUserDefaults] integerForKey:@"varianceThreshold"]) {
            [ratingFilterArray addObject:film];
        }
    }
    self.theaterArray = ratingFilterArray;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.theaterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFMCTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // Configure the cell...
    
    cell.imageView.image = nil;
    
    FilmModel *film = self.theaterArray[indexPath.row];
    
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
    selectedArray = self.theaterArray;

    [cell setFilm:[selectedArray objectAtIndex:indexPath.row]];
    
    [self checkForFilmImage:film];
    
    if (!film.posterImage && !film.isDownloading) {
        film.isDownloading = TRUE;
        [self downloadPosterAtIndex:indexPath.row];
        
        cell.filmThumbnailPoster.image = [UIImage imageNamed:@"Movies"];
        [cell.filmThumbnailPoster setContentMode:UIViewContentModeScaleAspectFit];
        
    } else {
        cell.filmThumbnailPoster.image = film.posterImage;
    
    }
    
    // Configuring the views and colors.
    UIView *checkView = [self viewWithImageName:@"SeenExtraLarge"];
    UIView *crossView = [self viewWithImageName:@"WantExtraLarge"];
    UIView *clockView = [self viewWithImageName:@"DontExtraLarge"];
    UIView *listView = [self viewWithImageName:@"TheaterExtraLarge"];
    
    // Setting the default inactive state color to the tableView background color.
    [cell setDefaultColor:self.tableView.backgroundView.backgroundColor];
    
    // Adding gestures per state basis.
    [cell setSwipeGestureWithView:checkView color:[UIColor navigationBarColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        [self deleteCell:cell forIndex:0];
    }];
    
    [cell setSwipeGestureWithView:crossView color:[UIColor navigationBarColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState2 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"List\" cell");
        [self deleteCell:cell forIndex:2];
    }];
    
    [cell setSwipeGestureWithView:clockView color:[UIColor navigationBarColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Sad_Face\" cell");
        [self deleteCell:cell forIndex:3];
    }];
    
    [cell setSwipeGestureWithView:listView color:[UIColor navigationBarColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState4 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
    }];
    
    return cell;
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

-(void)deleteCell:(UITableViewCell *)cell forIndex:(NSInteger)index
{
   
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.delegate passFilmFromTheater:self.theaterArray[indexPath.row] forIndex:index];
    
    [self.strongArray removeObjectAtIndex:[self.strongArray indexOfObject:self.theaterArray[indexPath.row]]];
    
    [self.theaterArray removeObjectAtIndex:indexPath.row];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - Segue Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [(SFMovieDetailViewController *)segue.destinationViewController setFilm:self.theaterArray[indexPath.row]];
    }
}

- (void)reloadTable:(NSNotification *)note
{
    FilmModel *model = [note.userInfo objectForKey:@"film"];
    NSInteger modelRow = [self.theaterArray indexOfObject:model];
    NSIndexPath *row = [NSIndexPath indexPathForRow:modelRow inSection:0];
    
    [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)downloadPosterAtIndex:(NSInteger)index
{
    FilmModel *film = self.theaterArray[index];
    NSURL *posterURL = [NSURL URLWithString:film.thumbnailPoster];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    [_downloadQueue addOperationWithBlock:^{
        
        NSError *error;
        NSData *posterData = [NSData dataWithContentsOfURL:posterURL options:NSDataReadingMappedIfSafe error:&error];
        
        
        if (error) {
            //film.isDownloading = NO;
        } else {
            
        
            film.posterImage = [UIImage imageWithData:posterData];
            posterData = UIImageJPEGRepresentation(film.posterImage, 0.5);
            
            NSString *posterLocation = [NSString stringWithFormat:@"%@/%@.jpg", [self documentsDirectoryPath], [film.title stringByReplacingOccurrencesOfString:@":" withString:@""]];
            film.posterFilePath = posterLocation;
            //NSLog(@"%@", film.posterFilePath);
            
            [posterData writeToFile:film.posterFilePath atomically:YES];
            
            
            //NSLog(@"%hhd", [self doesFileExist:film.posterFilePath]);
//            if (film.posterFilePath) {
//                NSLog(@"%@", film.posterFilePath);
//            } else {
//                NSLog(@"TRUE");
//            }
            
            
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }];
    

    }];
    
}

- (NSString *)documentsDirectoryPath
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentsURL path];
}

- (void)checkForFilmImage:(FilmModel *)film
{
    //NSLog(@"File: %@", film.posterImagePath);
    NSString *string = [NSString stringWithFormat:@"%@/%@.jpg", [self documentsDirectoryPath], [film.title stringByReplacingOccurrencesOfString:@":" withString:@""]];
   // NSLog(@"String: %@", string);
    
    NSError *error;
    //NSData *data = [NSData dataWithContentsOfFile:string options:NSDataReadingMapped error:&error];
    
    UIImage *image2 = [UIImage imageWithContentsOfFile:string];
    
    if (error) {
        NSLog(@"%@", error);
    } else {
            }
    
    //UIImage *image = [UIImage imageWithContentsOfFile:[NSData dataWithContentsOfFile:film.posterImagePath]];
    //NSLog(@"Does It Exists?: %hhd", [self doesFileExist:image2]);

    
    if (image2) {
        //NSLog(@"%@", image);
        film.posterImage = image2;
    }
}

-(BOOL)doesFileExist:(NSString *)stringName
{
    //NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    //NSString *documentsPath = [documentsURL path];
    //documentsPath = [documentsPath stringByAppendingPathComponent:stringName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:stringName]) {
        //NSLog(@"FALSE");
        return FALSE;
    } else {
        //NSLog(@"TRUE");
        return TRUE;
    }
}

@end
