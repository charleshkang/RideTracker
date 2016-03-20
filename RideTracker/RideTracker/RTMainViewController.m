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
@property (nonatomic) NSInteger currentBalance;
@property (nonatomic) float standardFare;

@property (weak, nonatomic) IBOutlet UILabel *currentBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ridesTakenLabel;

@property (nonatomic) NSString *currentBalanceString;
@property (nonatomic) NSString *rideCounterString;

@property (weak, nonatomic) IBOutlet UIButton *swipedCardButton;
@property (weak, nonatomic) IBOutlet UITextField *fareTextField;

@end

@implementation RTMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // well the currentBalance value will always be 27.75 since we straight up declare it in viewDidLoad, need to find a way to update the value whenever a user enters in the textfield
//    self.currentBalance = 27.75;
    self.standardFare = 2.75;
    
    self.currentBalanceLabel.text = [NSString stringWithFormat:@"%.2f", self.currentBalance];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int rideCounter = [defaults integerForKey:@"rideCounter"];
    self.rideCounterString = [NSString stringWithFormat:@"%i", rideCounter];
    self.ridesTakenLabel.text = self.rideCounterString;
    
    
    // these 3 lines are making the app even buggier
    float currentBalance = [defaults integerForKey:@"currentBalance"];
    self.currentBalanceString = [NSString stringWithFormat:@"%.2f", currentBalance];
    self.currentBalanceLabel.text = self.currentBalanceString;
    
    self.fareTextField.delegate = self;
}

- (IBAction)swipedCardButtonTapped:(id)sender

// current bugs: rides taken label should not update after balance hits 0 or below...
// number doesn't count down properly after textfield dismiss

{
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    int rideCount = [[self.ridesTakenLabel text] integerValue];
    self.rideCount += 1;
    [self updateRideLabel];
    
    float currentBalance = self.currentBalance - self.standardFare;
    self.currentBalanceString = [NSString stringWithFormat:@"%.02f", currentBalance];
    self.currentBalance -= 2.75;
    self.currentBalanceLabel.text = self.currentBalanceString;
    
    NSLog(@"current balance: %@", self.currentBalanceString);
    
    if (self.currentBalance <= 0) {
        self.rideCount = self.rideCount;
        self.currentBalanceLabel.text = @"💸";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oh No!"
                                                                                 message:@"Put more money on your card"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)saveButtonTapped:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:self.rideCount forKey:@"rideCounter"];
    [[NSUserDefaults standardUserDefaults] setInteger:self.currentBalance forKey:@"currentBalance"];

//    [[NSUserDefaults standardUserDefaults] setFloat:self.currentBalance forKey:@"currentBalance"];
    
    int rideCounter = [[self.ridesTakenLabel text] integerValue];
    float currentBalance = [[self.currentBalanceLabel text] integerValue];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:rideCounter forKey:@"rideCounter"];
    [defaults setInteger:currentBalance forKey:@"currentBalance"];
    
    [defaults synchronize];
}

- (IBAction)resetButtonTapped:(id)sender
{
    self.ridesTakenLabel.text = @"0";
    self.rideCount = 0;
    self.currentBalanceLabel.text = @"00.00";
    self.currentBalance = 0;
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
    self.currentBalanceLabel.text = textField.text;
    
    
    //    NSString *userEnteredBalance = [NSString stringWithFormat:@"%.2f", self.currentBalance];
    //    self.currentBalanceLabel.text = userEnteredBalance;
    self.currentBalance = self.currentBalanceLabel.text;
    
    
    //    NSString *str = [NSString stringWithFormat:@"%f", myFloat];
    
    //    NSString *intToString = [[NSNumber numberWithInteger:self.timerCount] stringValue];
    //    self.timerLabel.text = intToString;
    
    [self textFieldDidEndEditing:textField];
    [self.fareTextField resignFirstResponder];
    
    return YES;
}

@end
