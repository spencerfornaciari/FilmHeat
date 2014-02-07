//
//  SFNoneTableViewController.m
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/6/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFNoneTableViewController.h"

@interface SFNoneTableViewController ()

@property (nonatomic) NSString *nonePath;

@end

@implementation SFNoneTableViewController

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
    
    self.view.backgroundColor = [UIColor grayColor];
    
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *filmHeatPath = [documentsURL path];
    _nonePath = [filmHeatPath stringByAppendingPathComponent:DONT_WANT_IT_FILE];
    
    if ([self doesArrayExist:DONT_WANT_IT_FILE]) {
        self.noneArray = [NSKeyedUnarchiver unarchiveObjectWithFile:_nonePath];
    } else {
        self.noneArray = [NSMutableArray new];
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
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
    return self.noneArray.count;
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
    selectedArray = self.noneArray;
    
    [cell setFilm:[selectedArray objectAtIndex:indexPath.row]];
    
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
        NSLog(@"%d", indexPath.row);
        [self deleteCell:cell forIndex:0];
        
        // [self addToSeenItList:cell selectedArray:selectedArray];
    }];
    
    [cell setSwipeGestureWithView:crossView color:[UIColor wantedColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState2 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"List\" cell");
        [self deleteCell:cell forIndex:2];
        //        [self.delegate passFilmFromTheater:self.theaterArray[indexPath.row] forIndex:2];
        //        [self.theaterArray removeObjectAtIndex:indexPath.row];
        //        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        // [self addToWantedList:cell selectedArray:selectedArray];
    }];
    
    [cell setSwipeGestureWithView:clockView color:[UIColor noInterestColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Sad_Face\" cell");
        //[self deleteCell:cell forIndex:3];
        //[self addToNoInterestList:cell selectedArray:selectedArray];
    }];
    
    [cell setSwipeGestureWithView:listView color:[UIColor theaterColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState4 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Movies\" cell");
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
    
    [self.delegate passFilmFromNone:self.noneArray[indexPath.row] forIndex:index];
    [self.noneArray removeObjectAtIndex:indexPath.row];
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

@end