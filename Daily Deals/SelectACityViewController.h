//
//  SelectACityViewController.h
//  Daily Deals
//
//  Created by Jordan Helzer on 12/8/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectACityViewController;
@class CityInfo;

extern NSString * const kSelectACityKeyCityInfo;

@protocol SelectACityViewControllerDelegate <NSObject>

@optional

- (void) selectACityViewController:(SelectACityViewController *)controller didFinishFindingLocationWithInfo:(CityInfo *)selectedCity;

@end

@interface SelectACityViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (retain, nonatomic) IBOutlet UIPickerView *cityPicker;
@property (retain, nonatomic) NSArray *cityList;
@property (retain, nonatomic) NSArray *sortedListOfCityNames;
@property (retain, nonatomic) CityInfo *selectedCity;
@property (retain, nonatomic) CityInfo *currentCity;
@property (retain, nonatomic) id <SelectACityViewControllerDelegate> delegate;
@property (assign, nonatomic) BOOL appSetup;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

- (IBAction)cancel:(id)sender;
- (IBAction)select:(id)sender;

@end
