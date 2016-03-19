//
//  RTMainViewController.h
//  RideTracker
//
//  Created by Charles Kang on 3/18/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LabelDelegate <NSObject>

- (void) didSetLabel:(NSString *)label;

@end

@interface RTMainViewController : UIViewController

@property (weak, nonatomic) id<LabelDelegate>delegate;

@end
