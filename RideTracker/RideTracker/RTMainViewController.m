//
//  RTMainViewController.m
//  RideTracker
//
//  Created by Charles Kang on 3/18/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import "RTMainViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RTMainViewController ()
<
UITextFieldDelegate,
LabelDelegate
>

@property (nonatomic) NSInteger rideCount;

@property (nonatomic) float standardFare;

@property (weak, nonatomic) IBOutlet UILabel *ridesTakenLabel;

@property (nonatomic) NSString *rideCounterString;

@property (weak, nonatomic) IBOutlet UIButton *swipedCardButton;
@property (weak, nonatomic) IBOutlet UITextField *fareTextField;

@end

@implementation RTMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // well the currentBalance value will always be 27.75 since we straight up declare it in viewDidLoad, need to find a way to update the value whenever a user enters in the textfield
    self.standardFare = 2.75;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int rideCounter = [defaults integerForKey:@"rideCounter"];
    self.rideCounterString = [NSString stringWithFormat:@"%i", rideCounter];
    self.ridesTakenLabel.text = self.rideCounterString;
    
    self.fareTextField.delegate = self;
}

- (IBAction)swipedCardButtonTapped:(id)sender
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int rideCounter = [defaults integerForKey:@"rideCounter"];
    self.rideCounterString = [NSString stringWithFormat:@"%i", rideCounter];
    self.ridesTakenLabel.text = self.rideCounterString;
    
    int rideCount = [[self.ridesTakenLabel text] integerValue];
    self.rideCount += 1;
//    self.rideCount = rideCounter + 1;
    [self updateRideLabel];
}

- (IBAction)saveButtonTapped:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:self.rideCount forKey:@"rideCounter"];
    
    int rideCounter = [[self.ridesTakenLabel text] integerValue];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:rideCounter forKey:@"rideCounter"];
    
    [defaults synchronize];
}

- (IBAction)resetButtonTapped:(id)sender
{
    self.ridesTakenLabel.text = @"0";
    self.rideCount = 0;
}

- (void)updateRideLabel
{
    self.ridesTakenLabel.text = [NSString stringWithFormat:@"%ld",self.rideCount];
}

#pragma mark - Text field delegate

- (void)didSetLabel:(NSString *)label
{
    [self.delegate didSetLabel:label];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // need to set the currentBalance to whatever the user submits
    // i know i have to set the float count to the submitted value, but not sure how to do that
    
    [self didSetLabel:textField.text];
    
    [self textFieldDidEndEditing:textField];
    [self.fareTextField resignFirstResponder];
    
    return YES;
}

@end
