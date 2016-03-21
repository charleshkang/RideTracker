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

@property (nonatomic) NSInteger rideCount;

@property (nonatomic) float standardFare;

@property (weak, nonatomic) IBOutlet UILabel *ridesTakenLabel;

@property (nonatomic) NSString *rideCounterString;

@property (weak, nonatomic) IBOutlet UIButton *swipedCardButton;
@property (weak, nonatomic) IBOutlet UITextField *fareTextField;

@end

// only thing to fix is the counter should get the count from user defaults and start adding up from there instead of starting at 1

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
}

- (IBAction)swipedCardButtonTapped:(id)sender
{
    NSLog(@"look: %lu", (long)_rideCount);
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
}

- (IBAction)resetButtonTapped:(id)sender
{
    self.ridesTakenLabel.text = @"0";
    self.rideCount = 0;
}

@end
