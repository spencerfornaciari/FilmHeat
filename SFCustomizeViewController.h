//
//  SFCustomizeViewController.h
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/3/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SFCustomizeViewController : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *gpsButton;

- (IBAction)submitZipCode:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *mpaaRatingThresholdLabel;
@property (weak, nonatomic) IBOutlet UISlider *mpaaRatingThresholdSliderOutlet;

- (IBAction)gpsButtonAction:(id)sender;

- (IBAction)mpaaRatingThresholdSliderAction:(id)sender;


@end
