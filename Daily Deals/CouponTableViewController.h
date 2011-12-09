//
//  CouponTableViewController.h
//  Daily Deals
//
//  Created by Jordan Helzer on 12/7/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetupViewController.h"
#import "SelectACityViewController.h"
#import "CityInfo.h"

@interface CouponTableViewController : UITableViewController 
    <SetupViewControllerDelegate, 
    SelectACityViewControllerDelegate, 
    UITableViewDelegate, 
    UITableViewDataSource>

@property (retain, nonatomic) CityInfo *currentCityInfo;
@property (retain, nonatomic) NSArray *cityList;
@property (retain, nonatomic) NSArray *couponList;
@property (retain, nonatomic) IBOutlet UITableViewCell *tableViewCell;
@property (retain, nonatomic) SelectACityViewController *selectACityViewController;
@property (retain, nonatomic) SetupViewController *setupViewController;

- (void) setupViewController:(SetupViewController *)controller didFinishFindingLocationWithInfo:(NSDictionary *)setupInfo;
- (void) selectACityViewController:(SelectACityViewController *)controller didFinishFindingLocationWithInfo:(CityInfo *)selectedCity;

@end