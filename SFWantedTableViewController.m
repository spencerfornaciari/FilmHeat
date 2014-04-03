//
//  SFWantedTableViewController.m
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/6/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFWantedTableViewController.h"
#import "SFMovieDetailViewController.h"

@interface SFWantedTableViewController ()

@property (nonatomic) NSString *wantedPath;
@property (nonatomic) FilmModel *currentFilm;

@end

@implementation SFWantedTableViewController

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
        
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *filmHeatPath = [documentsURL path];
    _wantedPath = [filmHeatPath stringByAppendingPathComponent:kWANT_TO_FILE];
    
//    if ([self doesArrayExist:kWANT_TO_FILE]) {
//        self.wantedArray = [NSKeyedUnarchiver unarchiveObjectWithFile:_wantedPath];
//    } else {
//        self.wantedArray = [NSMutableArray new];
//    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [NSKeyedArchiver archiveRootObject:self.wantedArray toFile:_wantedPath];

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
    return self.wantedArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFMCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // Configure the cell...
    
    cell.imageView.image = nil;
    
    FilmModel *film = self.wantedArray[indexPath.row];
    
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
    selectedArray = self.wantedArray;
    
    [cell setFilm:[selectedArray objectAtIndex:indexPath.row]];
    
    [self checkForFilmImage:film];
    
    if (film.posterImage) {
        cell.filmThumbnailPoster.image = film.posterImage;
    } else {
        cell.filmThumbnailPoster.image = [UIImage imageNamed:@"Movies"];
        [cell.filmThumbnailPoster setContentMode:UIViewContentModeScaleAspectFit];
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
    }];
    
    [cell setSwipeGestureWithView:clockView color:[UIColor navigationBarColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        [self deleteCell:cell forIndex:3];
    }];
    
    [cell setSwipeGestureWithView:listView color:[UIColor navigationBarColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState4 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        [self deleteCell:cell forIndex:1];
        
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
    
    [self.delegate passFilmFromWanted:self.wantedArray[indexPath.row] forIndex:index];
    [self.wantedArray removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - Segue Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [(SFMovieDetailViewController *)segue.destinationViewController setFilm:self.wantedArray[indexPath.row]];
    }
}


- (NSString *)documentsDirectoryPath
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentsURL path];
}

- (void)checkForFilmImage:(FilmModel *)film
{
    if (!film.posterFilePath) {
        NSString *string = [NSString stringWithFormat:@"%@/%@.jpg", [self documentsDirectoryPath], [film.title stringByReplacingOccurrencesOfString:@":" withString:@""]];
        film.posterFilePath = string;
    }
    
    UIImage *image = [UIImage imageWithContentsOfFile:film.posterFilePath];
    
    if (image) {
        film.posterImage = image;
    }
}

@end
