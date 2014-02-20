//
//  SFTutorialChildViewController.m
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/11/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFTutorialChildViewController.h"
#import "SFBaseViewController.h"

@interface SFTutorialChildViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *tutorialImageView;
@property (strong, nonatomic) UITabBarController *tabBarController;

@end

@implementation SFTutorialChildViewController

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

    self.tabBarController = [UITabBarController new];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.index == 0) {
       self.tutorialImageView.image = [UIImage imageNamed:@"0"];
    } else if (self.index == 1) {
        self.tutorialImageView.image = [UIImage imageNamed:@"1"];
    } else if (self.index == 2) {
        self.tutorialImageView.image = [UIImage imageNamed:@"2"];
    } else if (self.index == 3) {
        self.tutorialImageView.image = [UIImage imageNamed:@"3"];
    } else if (self.index == 4) {
        self.tutorialImageView.image = [UIImage imageNamed:@"4"];
    } else if (self.index == 5) {
        self.tutorialImageView.image = [UIImage imageNamed:@"5"];
    } else if (self.index == 6) {
        self.tutorialImageView.image = [UIImage imageNamed:@"6"];
    } else if (self.index == 7) {
        self.tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"movieTab"];
        [self presentViewController:self.tabBarController animated:YES completion:^{
            
        }];
    }


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Status Bar Style

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
