//
//  SFCustomizeViewController.m
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/3/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFCustomizeViewController.h"

@interface SFCustomizeViewController ()


- (IBAction)dismissViewController:(id)sender;

@end

@implementation SFCustomizeViewController

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
    self.gpsButton.backgroundColor = [UIColor redColor];
    self.gpsButton.tintColor = [UIColor whiteColor];
    self.zipCodeTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultZipCode"];
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"distanceThreshold"]) {
        float flo = [[NSUserDefaults standardUserDefaults] integerForKey:@"distanceThreshold"] / 20.f;
        self.distanceThresholdSliderOutlet.value = flo;
        int threshold = [self.distanceThresholdSliderOutlet value] * 20;
        self.distanceThresholdLabel.text = [[NSNumber numberWithInt:threshold] stringValue];
    }
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"criticThreshold"]) {
        float flo =  [[NSUserDefaults standardUserDefaults] integerForKey:@"criticThreshold"] / 100.f;
        self.criticsThresholdSliderOutlet.value = flo;
        int threshold = [self.criticsThresholdSliderOutlet value] * 100;
        self.criticsRatingThresholdLabel.text = [[NSNumber numberWithInt:threshold] stringValue];
    }
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"audienceThreshold"]) {
        float flo =  [[NSUserDefaults standardUserDefaults] integerForKey:@"audienceThreshold"] / 100.f;
        self.audienceRatingSliderOutlet.value = flo;
        int threshold = [self.audienceRatingSliderOutlet value] * 100;
        self.audienceRatingThresholdLabel.text = [[NSNumber numberWithInt:threshold] stringValue];
    }
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"defaultZipCode"]) {
        int zip =  [[NSUserDefaults standardUserDefaults] integerForKey:@"defaultZipCode"];
        self.zipCodeTextField.text = [[NSNumber numberWithInt:zip] stringValue];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)distanceThresholdSliderAction:(id)sender {
    int threshold = [self.distanceThresholdSliderOutlet value] * 20;
    self.distanceThresholdLabel.text = [[NSNumber numberWithInt:threshold] stringValue];
    [[NSUserDefaults standardUserDefaults] setInteger:threshold forKey:@"distanceThreshold"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)criticsRatingThresholdSliderAction:(id)sender {
    int threshold = [self.criticsThresholdSliderOutlet value] * 100;
    self.criticsRatingThresholdLabel.text = [[NSNumber numberWithInt:threshold] stringValue];
    [[NSUserDefaults standardUserDefaults] setInteger:threshold forKey:@"criticThreshold"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)audienceRatingThresholdSliderAction:(id)sender {
    int threshold = [self.audienceRatingSliderOutlet value] * 100;
    self.audienceRatingThresholdLabel.text = [[NSNumber numberWithInt:threshold] stringValue];
    [[NSUserDefaults standardUserDefaults] setInteger:threshold forKey:@"audienceThreshold"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (IBAction)gpsButtonAction:(id)sender {
}
- (IBAction)dismissViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)submitZipCode:(id)sender
{
    self.zipCodeTextField.text = @"";
    NSString *textfield = self.zipCodeTextField.text;
    int zip = [textfield integerValue];
    [[NSUserDefaults standardUserDefaults] setInteger:zip forKey:@"defaultZipCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.zipCodeTextField resignFirstResponder];
}
@end
