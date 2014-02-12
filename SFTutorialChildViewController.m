//
//  SFTutorialChildViewController.m
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/11/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFTutorialChildViewController.h"

@interface SFTutorialChildViewController ()

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
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.index == 0) {
        self.view.backgroundColor = [UIColor redColor];
    } else if (self.index == 1) {
        self.view.backgroundColor = [UIColor blueColor];
    } else if (self.index == 2) {
        self.view.backgroundColor = [UIColor greenColor];
    }
    
    self.screenNumber.text = [NSString stringWithFormat:@"Screen #%d", self.index];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
