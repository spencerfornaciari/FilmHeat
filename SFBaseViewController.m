//
//  SFBaseViewController.m
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/6/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFBaseViewController.h"


@interface SFBaseViewController ()

@property (nonatomic, strong) SFSeenTableViewController *seenController;
@property (nonatomic, strong) SFTheaterTableViewController *theaterController;
@property (nonatomic, strong) SFWantedTableViewController *wantedController;
@property (nonatomic, strong) SFNoneTableViewController *noneController;

@property (nonatomic, strong) NSArray *childVCArray;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentOutlet;

@property (weak, nonatomic) IBOutlet UIView *movieContainer;
- (IBAction)segmentPicker:(UISegmentedControl *)sender;

@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic) NSString *seenItPath, *wantToSeeItPath, *dontWantToSeeItPath;


@end

@implementation SFBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.segmentOutlet.selectedSegmentIndex = 1;
    
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSString *filmHeatPath = [documentsURL path];
    _seenItPath = [filmHeatPath stringByAppendingPathComponent:SEEN_IT_FILE];
    _wantToSeeItPath = [filmHeatPath stringByAppendingPathComponent:WANT_TO_FILE];
    _dontWantToSeeItPath = [filmHeatPath stringByAppendingPathComponent:DONT_WANT_IT_FILE];
    
    
    self.seenController = [self.storyboard instantiateViewControllerWithIdentifier:@"SeenView"];
    self.theaterController = [self.storyboard instantiateViewControllerWithIdentifier:@"TheaterView"];
    self.wantedController = [self.storyboard instantiateViewControllerWithIdentifier:@"WantedView"];
    self.noneController = [self.storyboard instantiateViewControllerWithIdentifier:@"NoneView"];

    
    self.theaterController.delegate = self;
    self.seenController.delegate = self;
    self.wantedController.delegate = self;
    self.noneController.delegate = self;
    
    self.currentViewController = self.theaterController;

    
    self.childVCArray = @[self.seenController, self.theaterController, self.wantedController, self.noneController];
    
    [self setupFirstView];
	// Do any additional setup after loading the view.
}

-(void)setupFirstView
{
    [self addChildViewController:self.currentViewController];
    self.currentViewController.view.frame = self.movieContainer.frame;
    [self.movieContainer addSubview:self.currentViewController.view];
    [self.currentViewController didMoveToParentViewController:self];
    
}
- (void)clearContainerView
{
    
    if (self.movieContainer.subviews.count > 0) {
        UIView *view = self.movieContainer.subviews[0];
        [view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentPicker:(UISegmentedControl *)sender {
    
//    [self clearContainerView];
    
    NSLog(@"%ld",(long)self.segmentOutlet.selectedSegmentIndex);
    
    [self cycleFromViewController:self.currentViewController toViewController:self.childVCArray[sender.selectedSegmentIndex]];

//    [self addChildViewController:[self.childVCArray objectAtIndex:sender.selectedSegmentIndex]];
//    
//    UIViewController *viewController = self.childVCArray[self.segmentOutlet.selectedSegmentIndex];
//    viewController.view.frame = self.movieContainer.frame;
//    [self.movieContainer addSubview:viewController.view];
//    [viewController didMoveToParentViewController:self];
}

- (void) cycleFromViewController: (UIViewController*) oldC
                toViewController: (UIViewController*) newC
{
    
    
    [oldC willMoveToParentViewController:nil];                        // 1
    [self addChildViewController:newC];
    
    newC.view.frame = oldC.view.frame;
    newC.view.alpha = 0;
    
    [self transitionFromViewController: oldC toViewController: newC   // 3
                              duration: 0.25 options:0
                            animations:^{
                                newC.view.alpha = 1;
                                oldC.view.alpha = 0;
                            }
                            completion:^(BOOL finished) {
                                [oldC removeFromParentViewController];                   // 5
                                [newC didMoveToParentViewController:self];
                                self.currentViewController = newC;
                            }];
    
}

-(void)passFilmFromTheater:(FilmModel *)film forIndex:(NSInteger)index
{
    
    if (index == 0) {
        if (!self.seenController.seenArray)
        {
            self.seenController.seenArray = [NSMutableArray new];
        }
        
        [self.seenController.seenArray addObject:film];
        [NSKeyedArchiver archiveRootObject:self.seenController.seenArray toFile:_seenItPath];

        
    } else if (index == 2) {
        if (!self.wantedController.wantedArray)
        {
            self.wantedController.wantedArray = [NSMutableArray new];
        }
    
        [self.wantedController.wantedArray addObject:film];
        
        [NSKeyedArchiver archiveRootObject:self.wantedController.wantedArray toFile:_wantToSeeItPath];

    } else if (index == 3) {
        if (!self.noneController.noneArray)
        {
            self.noneController.noneArray = [NSMutableArray new];
        }
        
        [self.noneController.noneArray addObject:film];
        
        [NSKeyedArchiver archiveRootObject:self.noneController.noneArray toFile:_dontWantToSeeItPath];

    }
}

-(void)passFilmFromSeen:(FilmModel *)film forIndex:(NSInteger)index
{
    if (index == 1) {
        if (!self.theaterController.theaterArray)
        {
            self.theaterController.theaterArray = [NSMutableArray new];
        }
        
        [self.theaterController.theaterArray addObject:film];
    } else if (index == 2) {
        if (!self.wantedController.wantedArray)
        {
            self.wantedController.wantedArray = [NSMutableArray new];
        }
        
        [self.wantedController.wantedArray addObject:film];
        [NSKeyedArchiver archiveRootObject:self.wantedController.wantedArray toFile:_wantToSeeItPath];

    } else if (index == 3) {
        if (!self.noneController.noneArray)
        {
            self.noneController.noneArray = [NSMutableArray new];
        }
        
        [self.noneController.noneArray addObject:film];
        [NSKeyedArchiver archiveRootObject:self.noneController.noneArray toFile:_dontWantToSeeItPath];

    }
}

-(void)passFilmFromWanted:(FilmModel *)film forIndex:(NSInteger)index
{
    if (index == 0) {
        if (!self.seenController.seenArray)
        {
            self.seenController.seenArray = [NSMutableArray new];
        }
        
        [self.seenController.seenArray addObject:film];
        [NSKeyedArchiver archiveRootObject:self.seenController.seenArray toFile:_seenItPath];

    } else if (index == 1) {
        if (!self.theaterController.theaterArray)
        {
            self.theaterController.theaterArray = [NSMutableArray new];
        }
        
        [self.theaterController.theaterArray addObject:film];
    } else if (index == 3) {
        if (!self.noneController.noneArray)
        {
            self.noneController.noneArray = [NSMutableArray new];
        }
        
        [self.noneController.noneArray addObject:film];
        [NSKeyedArchiver archiveRootObject:self.noneController.noneArray toFile:_dontWantToSeeItPath];

    }
}

-(void)passFilmFromNone:(FilmModel *)film forIndex:(NSInteger)index
{
    if (index == 0) {
        if (!self.seenController.seenArray)
        {
            self.seenController.seenArray = [NSMutableArray new];
        }
        
        [self.seenController.seenArray addObject:film];
        [NSKeyedArchiver archiveRootObject:self.seenController.seenArray toFile:_seenItPath];
        
    } else if (index == 1) {
        if (!self.theaterController.theaterArray)
        {
            self.theaterController.theaterArray = [NSMutableArray new];
        }
        
        [self.theaterController.theaterArray addObject:film];
    } else if (index == 2) {
        if (!self.wantedController.wantedArray)
        {
            self.wantedController.wantedArray = [NSMutableArray new];
        }
        
        [self.wantedController.wantedArray addObject:film];
        [NSKeyedArchiver archiveRootObject:self.wantedController.wantedArray toFile:_wantToSeeItPath];
    }
}

#pragma mark - Sort

- (IBAction)buttonAction:(id)sender {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Test Sheet" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"A-Z", @"Z-A", @"Date (Newest)", @"Date (Oldest)", nil];
    [action showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (self.segmentOutlet.selectedSegmentIndex == 0) {
        self.seenController.seenArray = [self sortSelection:buttonIndex withArray:self.seenController.seenArray];
        [self.seenController.tableView reloadData];
    } else if (self.segmentOutlet.selectedSegmentIndex == 1){
        self.theaterController.theaterArray = [self sortSelection:buttonIndex withArray:self.theaterController.theaterArray];
        [self.theaterController.tableView reloadData];
    } else if (self.segmentOutlet.selectedSegmentIndex == 2){
        self.wantedController.wantedArray = [self sortSelection:buttonIndex withArray:self.wantedController.wantedArray];
        [self.wantedController.tableView reloadData];
    } else if (self.segmentOutlet.selectedSegmentIndex == 3){
        self.noneController.noneArray = [self sortSelection:buttonIndex withArray:self.noneController.noneArray];
        [self.noneController.tableView reloadData];
    }
}

-(NSMutableArray *)sortSelection:(NSInteger)buttonIndex withArray:(NSMutableArray *)arrayToSort
{
    switch (buttonIndex)
    {
        case 0:
        {
            NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
            arrayToSort = [NSMutableArray arrayWithArray:[arrayToSort sortedArrayUsingDescriptors:@[nameSorter]]];
        }
            break;
            
        case 1:
        {
            NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO];
            arrayToSort = [NSMutableArray arrayWithArray:[arrayToSort sortedArrayUsingDescriptors:@[nameSorter]]];
        }
            break;
            
        case 2:
        {
            NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"releaseDate" ascending:NO];
            arrayToSort = [NSMutableArray arrayWithArray:[arrayToSort sortedArrayUsingDescriptors:@[nameSorter]]];
        }
            break;
            
        case 3:
        {
            NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"releaseDate" ascending:YES];
            arrayToSort = [NSMutableArray arrayWithArray:[arrayToSort sortedArrayUsingDescriptors:@[nameSorter]]];
        }
            break;
    }
    
    return arrayToSort;
}


@end
