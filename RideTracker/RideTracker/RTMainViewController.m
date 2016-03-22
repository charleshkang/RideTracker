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

/* as of right now, user has to save each time they make a change since data is retrieved from nsuserdefaults in viewDidLoad. not sure if they need to close the app or just close it and reopen, but definitely have to save after each change */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.standardFare = 2.75;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSUInteger rideCounter = [defaults integerForKey:@"rideCounter"];
    self.rideCounterString = [NSString stringWithFormat:@"%lu", (unsigned long)rideCounter];
    self.ridesTakenLabel.text = self.rideCounterString;
    self.rideCount = rideCounter;
    [defaults synchronize];
    
    float currentBalanceFloat = [defaults floatForKey:@"currentBalanceFloat"];
    self.currentBalanceString = [NSString stringWithFormat:@"%.02f", currentBalanceFloat];
    [defaults synchronize];
    
    self.currentBalanceLabel.text = self.currentBalanceString;
    self.currentBalance = currentBalanceFloat;
    [defaults synchronize];
    NSLog(@"current float balance on card: %.02f", currentBalanceFloat);
    
    //    NSUInteger currentBalanceInt = [defaults integerForKey:@"currentBalanceInt"];
    //    self.currentBalanceString = [NSString stringWithFormat:@"%lu", (unsigned long)currentBalanceInt];
    //
    //    self.currentBalanceLabel.text = self.currentBalanceString;
    //    self.currentBalance = currentBalanceInt;
    //    NSLog(@"current int balance on card: %lu", (unsigned long)currentBalanceInt);
    
    self.fareTextField.delegate = self;
}

- (IBAction)swipedCardButtonTapped:(id)sender
{
    self.rideCount += 1;
    self.ridesTakenLabel.text = [NSString stringWithFormat:@"%ld", self.rideCount];
    
    self.currentBalance -= 2.75;
    self.currentBalanceLabel.text = [NSString stringWithFormat:@"%.02f", self.currentBalance];
    NSLog(@"current balance: %.02f", self.currentBalance);
    
    if (self.currentBalance <= 0) {
        self.currentBalanceLabel.text = @"💸";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oh No!"
                                                                                 message:@"Put more money on your card"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (self.currentBalance < 2.75) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Almost out"
                                                                                 message:@"Put more money on your card before you run out! Regular fare is 2.75!"
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
    NSUInteger rideCounter = [[self.ridesTakenLabel text] integerValue];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:rideCounter forKey:@"rideCounter"];
    [defaults synchronize];
    NSLog(@"saved ride count: %lu", (unsigned long)rideCounter);
    
    NSUInteger currentBalanceInt = [[self.currentBalanceLabel text] integerValue];
    [defaults setInteger:currentBalanceInt forKey:@"currentBalanceInt"];
    NSLog(@"saved balance int: %lu", (unsigned long)currentBalanceInt);
    
    float currentBalanceFloat = [[self.currentBalanceLabel text] floatValue];
    [defaults setFloat:currentBalanceFloat forKey:@"currentBalanceFloat"];
    NSLog(@"saved balance float : %.02f", currentBalanceFloat);
    [defaults synchronize];
}

- (IBAction)resetButtonTapped:(id)sender
{
    self.ridesTakenLabel.text = @"0";
    self.rideCount = 0;
    self.currentBalanceLabel.text = @"0.00";
    self.currentBalance = 0.00;
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

// feature i want to add, include the current balance and the added balance, then sum those up and update the label for sum
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self didSetLabel:textField.text];
    
    NSInteger stringToInt = [self.currentBalanceString intValue];
    
    float leftoverBalanceNewBalance = self.currentBalance + stringToInt;
    
    self.currentBalanceLabel.text = [NSString stringWithFormat:@"%.02f", leftoverBalanceNewBalance];
    
    self.currentBalanceLabel.text = textField.text;
    NSLog(@"%@", self.currentBalanceLabel.text);
    
    [self textFieldDidEndEditing:textField];
    [self.fareTextField resignFirstResponder];
    
    return YES;
}

@end
