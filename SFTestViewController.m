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
    
    _strongArray = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable:)
                                                 name:@"reload"
                                               object:nil];
    
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
}

- (void)viewDidAppear:(BOOL)animated
{
    
    if (self.theaterController.seenItArray.count == 0) {
        [self.segmentOutlet setEnabled:NO forSegmentAtIndex:0];
    } else if (self.theaterController.seenItArray.count > 0) {
        [self.segmentOutlet setEnabled:YES forSegmentAtIndex:0];
    }

    if (self.theaterController.wantedArray.count == 0) {
        [self.segmentOutlet setEnabled:NO forSegmentAtIndex:2];
    } else {
        [self.segmentOutlet setEnabled:YES forSegmentAtIndex:2];
    }
    
    if (self.theaterController.noInterestArray.count == 0) {
        [self.segmentOutlet setEnabled:NO forSegmentAtIndex:3];
    } else {
        [self.segmentOutlet setEnabled:YES forSegmentAtIndex:3];
    }
    
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
        self.segmentOutlet.tintColor = [UIColor seenItColor];
    } else if (self.segmentOutlet.selectedSegmentIndex == 1) {
        [self.view endEditing:YES];
        self.segmentOutlet.tintColor = [UIColor theaterColor];
        
    } else if(self.segmentOutlet.selectedSegmentIndex == 2) {
        [self.view endEditing:YES];
        self.segmentOutlet.tintColor = [UIColor wantedColor];
        
    } else if (self.segmentOutlet.selectedSegmentIndex == 3){
        [self.view endEditing:YES];
        self.segmentOutlet.tintColor = [UIColor noInterestColor];
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
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Test Sheet" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"A-Z", @"Z-A", @"Date (Newest)", @"Date (Oldest)", nil];
    [action showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (self.segmentOutlet.selectedSegmentIndex == 0) {
        self.theaterController.seenItArray = [self sortSelection:buttonIndex withArray:self.theaterController.seenItArray];
        [self.theaterTableView reloadData];
    } else if (self.segmentOutlet.selectedSegmentIndex == 1){
        self.theaterController.rottenTomatoesArray = [self sortSelection:buttonIndex withArray:self.theaterController.rottenTomatoesArray];
        [self.theaterTableView reloadData];
    } else if (self.segmentOutlet.selectedSegmentIndex == 2){
        self.theaterController.wantedArray = [self sortSelection:buttonIndex withArray:self.theaterController.wantedArray];
        [self.theaterTableView reloadData];
    } else if (self.segmentOutlet.selectedSegmentIndex == 3){
        self.theaterController.noInterestArray = [self sortSelection:buttonIndex withArray:self.theaterController.noInterestArray];
        [self.theaterTableView reloadData];
    }
}

-(NSMutableArray *)sortSelection:(NSInteger)buttonIndex withArray:(NSMutableArray *)arrayToSort
{
    switch (buttonIndex)
    {
        case 0:
        {
            NSLog(@"A-Z");
            NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
            arrayToSort = [NSMutableArray arrayWithArray:[arrayToSort sortedArrayUsingDescriptors:@[nameSorter]]];
        }
            break;
            
        case 1:
        {
            NSLog(@"Z-A");
            NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO];
            arrayToSort = [NSMutableArray arrayWithArray:[arrayToSort sortedArrayUsingDescriptors:@[nameSorter]]];
        }
            break;
            
        case 2:
        {
            NSLog(@"Date");
            NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"releaseDate" ascending:NO];
            arrayToSort = [NSMutableArray arrayWithArray:[arrayToSort sortedArrayUsingDescriptors:@[nameSorter]]];
        }
            break;
            
        case 3:
        {
            NSLog(@"Date");
            NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"releaseDate" ascending:YES];
            arrayToSort = [NSMutableArray arrayWithArray:[arrayToSort sortedArrayUsingDescriptors:@[nameSorter]]];
        }
            break;
    }
    
    return arrayToSort;
}

#pragma mark - Dynamically search text as user enters it

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"Search Bar Should Begin Editing");
    if (self.segmentOutlet.selectedSegmentIndex == 0) {
        _strongArray = [self.theaterController.seenItArray copy];
    } else if (self.segmentOutlet.selectedSegmentIndex == 1){
        _strongArray = [self.theaterController.rottenTomatoesArray copy];
    } else if (self.segmentOutlet.selectedSegmentIndex == 2){
        _strongArray = [self.theaterController.wantedArray copy];
    } else if (self.segmentOutlet.selectedSegmentIndex == 3){
        _strongArray = [self.theaterController.noInterestArray copy];
    }
    
    [self.theaterTableView setUserInteractionEnabled:NO];
    
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
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
        self.theaterController.seenItArray = [self searchWithArray:self.theaterController.seenItArray textToSearch:searchText];
        [self.theaterTableView reloadData];
    } else if (self.segmentOutlet.selectedSegmentIndex == 1){
        self.theaterController.rottenTomatoesArray = [self searchWithArray:self.theaterController.rottenTomatoesArray textToSearch:searchText];
        [self.theaterTableView reloadData];
    } else if (self.segmentOutlet.selectedSegmentIndex == 2){
        self.theaterController.wantedArray = [self searchWithArray:self.theaterController.wantedArray textToSearch:searchText];
        [self.theaterTableView reloadData];
    } else if (self.segmentOutlet.selectedSegmentIndex == 3){
        self.theaterController.noInterestArray = [self searchWithArray:self.theaterController.noInterestArray textToSearch:searchText];
        [self.theaterTableView reloadData];
    }
    
}

-(NSMutableArray *)searchWithArray:(NSMutableArray *)arrayToSearch textToSearch:(NSString *)searchText
{
//    NSMutableArray *strongArray
    NSMutableArray *finalResults = [NSMutableArray new];
    //_strongArray = [arrayToSearch copy];
    
    NSLog(@"%@", searchText);
    
    for (FilmModel *model in arrayToSearch)
    {
        NSString *string = [model.title uppercaseString];
        if ([string hasPrefix:[searchText uppercaseString]])
        {
            [finalResults addObject:model];
        }
    }
    
    NSLog(@"%d", finalResults.count);
    
    if (searchText.length == 0) {
        arrayToSearch = _strongArray;
    } else {
        arrayToSearch = finalResults;
    }
    
    return arrayToSearch;

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

-(void)enableSegment:(NSInteger)segment
{
    [self.segmentOutlet setEnabled:YES forSegmentAtIndex:segment];
}

-(void)disableSegment:(NSInteger)segment
{
    [self.segmentOutlet setEnabled:NO forSegmentAtIndex:segment];
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
    //self.segmentOutlet.selectedSegmentIndex = 1;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"Did End");
    [_segmentOutlet setUserInteractionEnabled:YES];
}

@end