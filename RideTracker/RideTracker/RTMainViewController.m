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
@property (nonatomic) float currentBalance;
@property (nonatomic) float standardFare;

@property (weak, nonatomic) IBOutlet UILabel *ridesTakenLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentBalanceLabel;

@property (nonatomic) NSString *rideCounterString;
@property (nonatomic) NSString *currentBalanceString;

@property (weak, nonatomic) IBOutlet UIButton *swipedCardButton;
@property (weak, nonatomic) IBOutlet UITextField *fareTextField;

@end

@implementation RTMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.standardFare = 2.75;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int rideCounter = [defaults integerForKey:@"rideCounter"];
    self.rideCounterString = [NSString stringWithFormat:@"%i", rideCounter];
    self.ridesTakenLabel.text = self.rideCounterString;
    self.rideCount = rideCounter;
    
    float currentBalance = [defaults floatForKey:@"currentBalance"];
    self.currentBalanceString = [NSString stringWithFormat:@"%.02f", currentBalance];
    //    NSString* formattedNumber = [NSString stringWithFormat:@"%.02f", myFloat];
    
    self.currentBalanceLabel.text = self.currentBalanceString;
    self.currentBalance = currentBalance;
    
    self.fareTextField.delegate = self;
}

- (IBAction)swipedCardButtonTapped:(id)sender
{
    self.rideCount += 1;
    self.ridesTakenLabel.text = [NSString stringWithFormat:@"%ld",self.rideCount];
}

- (IBAction)saveButtonTapped:(id)sender
{
    int rideCounter = [[self.ridesTakenLabel text] integerValue];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:rideCounter forKey:@"rideCounter"];
    [defaults synchronize];
    NSLog(@"saved ride count: %i", rideCounter);
    
    float currentBalance = [[self.currentBalanceLabel text] floatValue];
    [defaults setFloat:currentBalance forKey:@"currentBalance"];
    NSLog(@"saved balance : %.02f", currentBalance);
}

- (IBAction)resetButtonTapped:(id)sender
{
    self.ridesTakenLabel.text = @"0";
    self.rideCount = 0;
    self.currentBalanceLabel.text = @"0.00";
    self.currentBalance = 0;
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
    [self didSetLabel:textField.text];
    
    self.currentBalanceLabel.text = textField.text;
    NSLog(@"%@", self.currentBalanceLabel.text);
    
    [self textFieldDidEndEditing:textField];
    [self.fareTextField resignFirstResponder];
    
    return YES;
}

@end
