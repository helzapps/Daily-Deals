//
//  LocationViewController.m
//  Daily Deals
//
//  Created by Jordan Helzer on 12/5/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import "SetupViewController.h"
#import "CityListRequest.h"
#import "CouponListRequest.h"
#import "CityInfo.h"
#import "DeviceTypeHelper.h"
#import "CoreLocationController.h"

NSString * const kSetupInfoKeyCityInfo = @"CurrentCityInfo";
NSString * const kSetupInfoKeyListOfCities = @"ListOfCities";
NSString * const kSetupInfoKeyListOfCoupons = @"ListOfCoupons";

@implementation SetupViewController
@synthesize delegate;
@synthesize setupInfo;
@synthesize activityIndicator;
@synthesize tryAgainButton;
@synthesize listOfCities;
@synthesize listOfCoupons;
@synthesize closestCity;
@synthesize selectACityViewController;

- (BOOL)deviceCanSearch
{
	if([DeviceTypeHelper ConnectionToInternetStatus] != NotReachable)
	{
		return YES;
	}
	else
	{
		[DeviceTypeHelper ShowInternetNotAvailableAlert];
		return NO;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) dismissView {
    [self.activityIndicator stopAnimating];
    [self dismissModalViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(setupViewController:didFinishFindingLocationWithInfo:)]) {
        [delegate setupViewController:self didFinishFindingLocationWithInfo:setupInfo];
    }
}

- (void) requestForCouponList {
    NSString *notification = @"requestForCouponListReturned";
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(requestForCouponListReturned:) 
     name:notification
     object:nil];
    
    CouponListRequest *couponListRequest = [[[CouponListRequest alloc] init] autorelease];
    [couponListRequest initiateRequestWithURL:[NSURL URLWithString:
                                               [NSString stringWithFormat:@"http://socialcitydeals.com/api/daily-deals/%@", closestCity.uname]]
                                                   andNotification:notification];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

- (void) requestForCouponListReturned:(NSNotification *) notification {
    [[NSNotificationCenter defaultCenter] removeObserver: self name:@"requestForCouponListReturned" object:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (notification.userInfo == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"I'm Sorry"
                                                        message:@"There seems to be an issue.  Please try again later."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else {
        self.listOfCoupons = [notification.userInfo objectForKey:kServiceResponse];
        [setupInfo setObject:listOfCoupons forKey:kSetupInfoKeyListOfCoupons];
        [self dismissView];
    }
}

- (void) findNearestCity {
    CLLocation *currentLocation = [CoreLocationController sharedInstance].locationManager.location;
    CLLocationDistance meters = MAXFLOAT;
    CLLocationDistance tempMeters = 0.0;
    
    for (CityInfo *cityInfo in listOfCities) {
        CLLocation *cityInfoLocation = [[CLLocation alloc] initWithLatitude:cityInfo.latitude longitude:cityInfo.longitude];
        tempMeters = [currentLocation distanceFromLocation:cityInfoLocation];
        if (tempMeters < meters) {
            meters = tempMeters;
            self.closestCity = cityInfo;
        }
        [cityInfoLocation release];
    }
    
    [setupInfo setObject:closestCity forKey:kSetupInfoKeyCityInfo];
    [self requestForCouponList];
}

- (void) requestForCityList {
    NSString *notification = @"requestForCityListReturned";
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(requestForCityListReturned:) 
     name:notification 
     object:nil];
    
    CityListRequest *cityListRequest = [[[CityListRequest alloc] init] autorelease];
    [cityListRequest initiateRequestWithURL:[NSURL URLWithString: @"http://socialcitydeals.com/api/list_city"] 
                           andNotification:notification];
    
    [self.activityIndicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void) requestForCityListReturned: (NSNotification *) notification {
    [[NSNotificationCenter defaultCenter] removeObserver: self name:@"requestForCityListReturned" object:nil];
    
    if (notification.userInfo == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"I'm Sorry"
                                                        message:@"There seems to be an issue.  Please try again later."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } else {
        
        self.listOfCities = [notification.userInfo objectForKey:kServiceResponse];
        [setupInfo setObject:listOfCities forKey:kSetupInfoKeyListOfCities];
        
        if([self deviceCanSearch])
        {
            [[NSNotificationCenter defaultCenter]  
             addObserver:self  
             selector:@selector(obtainedCurrentLocation:)  
             name:@"AppObtainedCurrentLocation"  
             object:nil];  
            
            [[NSNotificationCenter defaultCenter]  
             addObserver:self  
             selector:@selector(notAllowedToUseCurrentLocation:)  
             name:@"AppNotAllowedToUseCurrentLocation"  
             object:nil];  
            
            [[CoreLocationController sharedInstance] startUpdates];
            
            [self performSelector: @selector(notAllowedToUseCurrentLocation:) withObject: self afterDelay: 30.0f];
        }
    }
    
}

- (void) removeCurrentLocationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:@"AppObtainedCurrentLocation" 
                                                  object:nil]; 
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:@"AppNotAllowedToUseCurrentLocation" 
                                                  object:nil]; 
}

- (void) obtainedCurrentLocation: (id) sender
{
    [self removeCurrentLocationObservers];
    [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(notAllowedToUseCurrentLocation:) object: self];
    [self findNearestCity];
}

- (void) notAllowedToUseCurrentLocation: (id) sender
{
    [self removeCurrentLocationObservers];
    [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(notAllowedToUseCurrentLocation:) object: self];
    NSString *message = @"We were unable to determine your current location.  Please select a city to see its current deals.";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Location Error" 
                                                    message: message
                                                   delegate:self 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    [alert show];    
    [alert release];
    
    // Work in progress: Need to present a UIPicker filled with City Names
    if (selectACityViewController == nil) {
        selectACityViewController = [[SelectACityViewController alloc] init];
        selectACityViewController.delegate = self;
        selectACityViewController.cityList = listOfCities;
        selectACityViewController.appSetup = YES;
    }
    
    [self presentModalViewController:selectACityViewController animated:YES];
    
}

- (void)selectACityViewController:(SelectACityViewController *)controller didFinishFindingLocationWithInfo:(CityInfo *)selectedCity {
    self.closestCity = selectedCity;
    [setupInfo setObject:closestCity forKey:kSetupInfoKeyCityInfo];
    [self requestForCouponList];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.setupInfo = [NSMutableDictionary dictionary];
    
    if ([self deviceCanSearch]) {
        [self requestForCityList];
    } else {
        tryAgainButton.hidden = NO;
    }
}

- (void)viewDidUnload
{
    [self setActivityIndicator:nil];
    [self setTryAgainButton:nil];
    [self setClosestCity:nil];
    [self setListOfCities:nil];
    [self setSetupInfo:nil];
    [self setListOfCoupons:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    } else {
        return NO;
    }
}

- (void)dealloc {
    [activityIndicator release];
    [tryAgainButton release];
    [closestCity release];
    [listOfCities release];
    [setupInfo release];
    [listOfCoupons release];
    [super dealloc];
}
- (IBAction)tryAgainTouched:(id)sender {
    if ([self deviceCanSearch]) {
        [self requestForCityList];
    }
}
@end
