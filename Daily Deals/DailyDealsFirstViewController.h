//
//  DailyDealsFirstViewController.h
//  Daily Deals
//
//  Created by Jordan Helzer on 12/4/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetupViewController.h"
#import "CityInfo.h"

@interface DailyDealsFirstViewController : UIViewController <SetupViewControllerDelegate, UINavigationControllerDelegate>

@property (retain, nonatomic) CityInfo *currentCityInfo;
@property (retain, nonatomic) NSArray *cityList;

- (void) setupViewController:(SetupViewController *)controller didFinishFindingLocationWithInfo:(NSDictionary *)setupInfo;


@end
