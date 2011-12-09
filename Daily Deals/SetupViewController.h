//
//  LocationViewController.h
//  Daily Deals
//
//  Created by Jordan Helzer on 12/5/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectACityViewController.h"

// Keys for the dictionary provided to the delegate.
extern NSString * const kSetupInfoKeyCityInfo;
extern NSString * const kSetupInfoKeyListOfCities;
extern NSString * const kSetupInfoKeyListOfCoupons;

@class CityInfo;
@class SetupViewController;

@protocol SetupViewControllerDelegate <NSObject>

@optional

- (void) setupViewController:(SetupViewController *)controller didFinishFindingLocationWithInfo:(NSDictionary *)setupInfo;

@end

@interface SetupViewController : UIViewController <SelectACityViewControllerDelegate, UINavigationControllerDelegate>

@property (assign, nonatomic) id <SetupViewControllerDelegate> delegate;
@property (retain, nonatomic) NSArray *listOfCities;
@property (retain, nonatomic) NSArray *listOfCoupons;
@property (retain, nonatomic) CityInfo *closestCity;
@property (retain, nonatomic) NSMutableDictionary *setupInfo;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UIButton *tryAgainButton;
@property (retain, nonatomic) SelectACityViewController *selectACityViewController;

- (IBAction)tryAgainTouched:(id)sender;
- (void)selectACityViewController:(SelectACityViewController *)controller didFinishFindingLocationWithInfo:(CityInfo *)selectedCity;

@end
