//
//  SFTestViewController.m
//  FilmHeat
//
//  Created by Spencer Fornaciari on 1/30/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFTestViewController.h"

@interface SFTestViewController ()
{
    FilmModel *currentFilm;
}

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentOutlet;
@property (weak, nonatomic) IBOutlet UITableView *theaterTableView;
@property (strong, nonatomic) SFFilmModelDataController *theaterController;
@property (weak, nonatomic) IBOutlet UISearchBar *theaterSearchBar;

@property (nonatomic) NSMutableArray *testArray;

@property (nonatomic) NSString *seenItPath, *wantToSeeItPath, *dontWantToSeeItPath;

@property (strong, nonatomic) NSMutableArray *strongArray;

- (IBAction)buttonAction:(id)sender;

@end

@implementation SFTestViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.theaterController = [SFFilmModelDataController new];
    
    self.theaterSearchBar.delegate = self;
    self.segmentOutlet.selectedSegmentIndex = 1;
    
    self.theaterTableView.delegate = self.theaterController;
    self.theaterTableView.dataSource = self.theaterController;
    
    self.theaterController.delegate = self;
    self.theaterController.tableView = self.theaterTableView;
    self.theaterController.selectedSegment = 1;
    
    [self.theaterController populateFilmData:@"98121"];
    
    
    _strongArray = [NSMutableArray arrayWithArray: self.theaterController.rottenTomatoesArray];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable:)
                                                 name:@"reload"
                                               object:nil];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [swipeLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [swipeRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:swipeRight];
    
    
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSString *filmHeatPath = [documentsURL path];
    _seenItPath = [filmHeatPath stringByAppendingPathComponent:SEEN_IT_FILE];
    NSLog(@"%@", _seenItPath);
    _wantToSeeItPath = [filmHeatPath stringByAppendingPathComponent:WANT_TO_FILE];
    _dontWantToSeeItPath = [filmHeatPath stringByAppendingPathComponent:DONT_WANT_IT_FILE];

    //Add items to other arrays for testing
//    for (int i=0; i<5; i++) {
//        [self.theaterController.wantedArray addObject:self.theaterController.rottenTomatoesArray[i]];
//        [self.theaterController.seenItArray addObject:self.theaterController.rottenTomatoesArray[i]];
//        [self.theaterController.noInterestArray addObject:self.theaterController.rottenTomatoesArray[i]];
//    }
    
    NSLog(@"Wanted: %d", self.theaterController.wantedArray.count);
    NSLog(@"Seen It: %d", self.theaterController.seenItArray.count);
    NSLog(@"Seen It: %d", self.theaterController.noInterestArray.count);
}

- (void)viewDidAppear:(BOOL)animated
{
    
    if (self.theaterController.seenItArray.count == 0) {
        //self.segmentOutlet.enabled = FALSE;
        [self.segmentOutlet setEnabled:NO forSegmentAtIndex:0];
    }

    
    if (self.theaterController.wantedArray.count == 0) {
        //self.segmentOutlet.enabled = FALSE;
        [self.segmentOutlet setEnabled:NO forSegmentAtIndex:2];
    }
    
    if (self.theaterController.noInterestArray.count == 0) {
        [self.segmentOutlet setEnabled:NO forSegmentAtIndex:3];
    }

    
//    if (self.segmentOutlet.selectedSegmentIndex == 0) {
//        if (self.theaterController.seenItArray.count == 0) {
//            self.segmentOutlet.enabled = FALSE;
//        }
//    } else if (self.segmentOutlet.selectedSegmentIndex == 1) {
//        self.segmentOutlet.tintColor = [UIColor blueColor];
//        
//    } else if(self.segmentOutlet.selectedSegmentIndex == 2)
//    {
//            }
    
    [NSKeyedArchiver archiveRootObject:self.theaterController.seenItArray toFile:_seenItPath];
    [NSKeyedArchiver archiveRootObject:self.theaterController.wantedArray toFile:_wantToSeeItPath];
    [NSKeyedArchiver archiveRootObject:self.theaterController.noInterestArray toFile:_dontWantToSeeItPath];

}

#pragma mark - UISegmented Controller Methods

- (IBAction)selectedIndex:(id)sender
{
    
    [self.theaterTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];

    if (self.segmentOutlet.selectedSegmentIndex == 0) {
        [self.view endEditing:YES];
        self.segmentOutlet.tintColor = [UIColor redColor];

        
    } else if (self.segmentOutlet.selectedSegmentIndex == 1) {
        [self.view endEditing:YES];
        self.segmentOutlet.tintColor = [UIColor blueColor];

        
    } else if(self.segmentOutlet.selectedSegmentIndex == 2)
    {
        [self.view endEditing:YES];
        self.segmentOutlet.tintColor = [UIColor orangeColor];
//        self.theaterController.rottenTomatoesArray = _strongArray;
//
//        NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"ratingVariance" ascending:YES];
//        self.theaterController.rottenTomatoesArray = [NSMutableArray arrayWithArray:[self.theaterController.rottenTomatoesArray sortedArrayUsingDescriptors:@[nameSorter]]];
        
       // [self.theaterTableView reloadData];
        
    } else if (self.segmentOutlet.selectedSegmentIndex == 3){
        self.segmentOutlet.tintColor = [UIColor grayColor];
    }
    
    
    [self.theaterController setSelectedSegment:_segmentOutlet.selectedSegmentIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIActionSheet Methods

- (IBAction)buttonAction:(id)sender {
    NSLog(@"Bar button");
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Test Sheet" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Test 1", @"Test 2", nil];
    [action showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            self.theaterController.rottenTomatoesArray = _strongArray;
            NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
            self.theaterController.rottenTomatoesArray = [NSMutableArray arrayWithArray:[self.theaterController.rottenTomatoesArray sortedArrayUsingDescriptors:@[nameSorter]]];
            
            [self.theaterTableView reloadData];
        }
            break;
            
        case 1:
        {
            self.theaterController.rottenTomatoesArray = _strongArray;
            
            NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO];
            self.theaterController.rottenTomatoesArray = [NSMutableArray arrayWithArray:[self.theaterController.rottenTomatoesArray sortedArrayUsingDescriptors:@[nameSorter]]];
            
            [self.theaterTableView reloadData];
        }
            break;

    }
}

#pragma mark - Dynamically search text as user enters it

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"Search Bar Should Begin Editing");
    [self.theaterTableView setUserInteractionEnabled:NO];
    
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"Search Bar Should End Editing");
    [self.theaterTableView setUserInteractionEnabled:YES];
    
    return YES;
}


//Updates as user enters text
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.segmentOutlet.selectedSegmentIndex == 0) {
    //    <#statements#>
    }
    
    NSMutableArray *searchArray = [NSMutableArray new];
    self.theaterController.rottenTomatoesArray = _strongArray;
    
    NSLog(@"%@", searchText);
    
    for (FilmModel *model in self.theaterController.rottenTomatoesArray)
    {
        NSString *string = [model.title uppercaseString];
        if ([string hasPrefix:[searchText uppercaseString]])
        {
            [searchArray addObject:model];
        }
    }
    
    if (searchText.length == 0) {
        self.theaterController.rottenTomatoesArray = _strongArray;
    } else {
        self.theaterController.rottenTomatoesArray = searchArray;
    }
    
    [self.theaterTableView reloadData];
}

- (void)searchArray:(NSMutableArray *)searchedArray
{
    //NSMutableArray *tempArray = [NSMutableArray new];
    
    for (FilmModel *model in self.theaterController.rottenTomatoesArray)
    {
//        NSString *string = [model.title uppercaseString];
//        if ([string hasPrefix:[searchText uppercaseString]])
//        {
//            [tempArray addObject:model];
//        }
    }
    
//    if (searchText.length == 0) {
//        searchedArray = _strongArray;
//    } else {
//        searchedArray = tempArray;
//    }
    
    [self.theaterTableView reloadData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches Began");
    [self.theaterSearchBar resignFirstResponder];
}

-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

- (void)reloadTable:(NSNotification *)note
{
    FilmModel *model = [note.userInfo objectForKey:@"film"];
    NSInteger modelRow = [self.theaterController.rottenTomatoesArray indexOfObject:model];
    NSIndexPath *row = [NSIndexPath indexPathForRow:modelRow inSection:0];
    
    [self.theaterTableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Swipe Gesture handlers

- (void)handleGesture:(UISwipeGestureRecognizer *)recognizer
{

    if (recognizer.direction == 1) {
        //[self.testArray addObject:]
        NSLog(@"RIGHT");
        if (self.segmentOutlet.selectedSegmentIndex < 2) {
            self.segmentOutlet.selectedSegmentIndex = self.segmentOutlet.selectedSegmentIndex + 1;
        } else {
            self.segmentOutlet.selectedSegmentIndex = 2;
        }
    } else {//if (recognizer.direction == 2) {
        NSLog(@"LEFT");
        //NSLog(@"%@", [self.theaterTableView indexPathForRowAtPoint:CGPoint point = [sender locationInView:self.tableView];);
        [UIView animateWithDuration:.4 animations:^{
            // = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
            
            //self.table.view.frame = CGRectMake(self.view.frame.size.width * .5, self.topViewController.view.frame.origin.y, self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];

        if (self.segmentOutlet.selectedSegmentIndex > 0) {
            self.segmentOutlet.selectedSegmentIndex = self.segmentOutlet.selectedSegmentIndex - 1;
        } else {
            self.segmentOutlet.selectedSegmentIndex = 0;
        }
    }
}

#pragma mark - seguing to Movie Detail View Controller

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[SFMovieDetailViewController class]]) {
        [(SFMovieDetailViewController *)segue.destinationViewController setFilm:currentFilm];
    }
}

-(void)selectedFilm:(FilmModel *)film
{
    if (self.segmentOutlet.selectedSegmentIndex == 0) {
        film.hasSeen = TRUE;
    }
    
    currentFilm = film;
    [self performSegueWithIdentifier:@"detailModal" sender:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"Did Scroll");
    [_segmentOutlet setUserInteractionEnabled:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"Did End");
    [_segmentOutlet setUserInteractionEnabled:YES];
}

@end