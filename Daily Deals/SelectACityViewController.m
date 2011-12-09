//
//  SelectACityViewController.m
//  Daily Deals
//
//  Created by Jordan Helzer on 12/8/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import "SelectACityViewController.h"
#import "CityInfo.h"

NSString * const kSelectACityKeyCityInfo = @"SelectedCityInfo";

@implementation SelectACityViewController

@synthesize cityPicker;
@synthesize cityList;
@synthesize sortedListOfCityNames;
@synthesize selectedCity;
@synthesize currentCity;
@synthesize delegate;
@synthesize appSetup;
@synthesize cancelButton;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc 
{
    [super dealloc];
    [cityPicker release];
    [cityList release];
    [sortedListOfCityNames release];
    [selectedCity release];
    [currentCity release];
    [delegate release];
    [cancelButton release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *cityNames = [[NSMutableArray alloc] init];
    for (CityInfo *cityInfo in cityList) {
        [cityNames addObject:cityInfo.name];
    }
    self.sortedListOfCityNames = [cityNames sortedArrayUsingSelector:@selector(compare:)];
    [cityNames release];
    
    if (appSetup) {
        cancelButton.enabled = NO;
    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setCityPicker:nil];
    [self setCityList:nil];
    [self setSelectedCity:nil];
    [self setSortedListOfCityNames:nil];
    [self setCurrentCity:nil];
    [self setDelegate:nil];
    [self setCancelButton:nil];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self pickerView:cityPicker didSelectRow:0 inComponent:0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (CityInfo *)findCityInfowith: (NSString *) cityName {
    CityInfo *cityInfoToReturn;
    for (CityInfo *cityInfoToCheck in cityList) {
        if ([cityName isEqualToString:cityInfoToCheck.name]) {
            cityInfoToReturn = cityInfoToCheck;
        }
    }
    
    return cityInfoToReturn;
}

- (void)setCitySelected:(NSString *) cityName {
    self.selectedCity = [self findCityInfowith:cityName];
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)select:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(selectACityViewController:didFinishFindingLocationWithInfo:)]) {
        [delegate selectACityViewController:self didFinishFindingLocationWithInfo:selectedCity];
    }
}

#pragma mark - Picker Data Source Method

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [sortedListOfCityNames count];
}

#pragma mark - Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [sortedListOfCityNames objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *cityName = [sortedListOfCityNames objectAtIndex:row];
    [self setCitySelected:cityName];
}

@end
