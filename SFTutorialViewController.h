//
//  SFTutorialViewController.h
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/11/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFTutorialChildViewController.h"

@interface SFTutorialViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;

@end
