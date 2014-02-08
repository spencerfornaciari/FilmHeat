//
//  SFCustomizeViewController.h
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/3/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFCustomizeViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *gpsButton;

- (IBAction)submitZipCode:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *distanceThresholdLabel;
@property (weak, nonatomic) IBOutlet UISlider *distanceThresholdSliderOutlet;

@property (weak, nonatomic) IBOutlet UILabel *criticsRatingThresholdLabel;
@property (weak, nonatomic) IBOutlet UISlider *criticsThresholdSliderOutlet;

@property (weak, nonatomic) IBOutlet UILabel *audienceRatingThresholdLabel;
@property (weak, nonatomic) IBOutlet UISlider *audienceRatingSliderOutlet;

- (IBAction)gpsButtonAction:(id)sender;

- (IBAction)mpaaRatingThresholdSliderAction:(id)sender;
- (IBAction)criticsRatingThresholdSliderAction:(id)sender;
- (IBAction)audienceRatingThresholdSliderAction:(id)sender;


@end
