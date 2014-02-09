//
//  SFCustomizeViewController.m
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/3/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFCustomizeViewController.h"

@interface SFCustomizeViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *zipCode;

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
    self.zipCodeTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.zipCodeTextField.delegate = self;
    
    //Declare CLLocation Manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    
    self.location = [[CLLocation alloc] init];
    
    NSLog(@"%d", [[NSUserDefaults standardUserDefaults] integerForKey:@"mpaaRatingThreshold"]);
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"mpaaRatingThreshold"] >= 0) {
        int threshold = [[NSUserDefaults standardUserDefaults] integerForKey:@"mpaaRatingThreshold"];
        self.mpaaRatingThresholdSliderOutlet.value = threshold / 5.f;
        [self setRatingThresholdLabel:threshold];
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

- (IBAction)mpaaRatingThresholdSliderAction:(id)sender {
    int threshold = [self.mpaaRatingThresholdSliderOutlet value] * 5;
    [self setRatingThresholdLabel:threshold];
    
    [[NSUserDefaults standardUserDefaults] setInteger:threshold forKey:@"mpaaRatingThreshold"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setRatingThresholdLabel:(NSInteger)index
{
    if (index == 5) {
        self.mpaaRatingThresholdLabel.text = @"NC-17";
    } else if (index == 4) {
        self.mpaaRatingThresholdLabel.text = @"R";
    }else if (index == 3) {
        self.mpaaRatingThresholdLabel.text = @"PG-13";
    } else if (index == 2) {
        self.mpaaRatingThresholdLabel.text = @"PG";
    } else if (index == 1) {
        self.mpaaRatingThresholdLabel.text = @"G";
    } else {
        self.mpaaRatingThresholdLabel.text = @"NR";
    }
}

- (IBAction)gpsButtonAction:(id)sender {
    [self.locationManager startUpdatingLocation];
    
    
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
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.zipCodeTextField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 5) ? NO : YES;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = locations[0];
    
    CLGeocoder *geocoder = [CLGeocoder new];
    
    [geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray *placemarks, NSError *error) {
        self.zipCode = [placemarks[0] postalCode];
        [[NSUserDefaults standardUserDefaults] setObject:self.zipCode forKey:@"defaultZipCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.locationManager stopUpdatingLocation];
        
        NSLog(@"%@", self.zipCode);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[NSUserDefaults standardUserDefaults] setObject:self.zipCode forKey:@"defaultZipCode"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.locationManager stopUpdatingLocation];
        }];
    }];
}

@end
