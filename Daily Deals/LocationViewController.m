//
//  LocationViewController.m
//  Daily Deals
//
//  Created by Jordan Helzer on 12/5/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import "LocationViewController.h"
#import "CityListRequest.h"
#import "DeviceTypeHelper.h"
#import "CoreLocationController.h"

@implementation LocationViewController
@synthesize activityIndicator;
@synthesize tryAgainButton;

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) dismissView {
    [self.activityIndicator stopAnimating];
    [self dismissModalViewControllerAnimated:YES];
}

- (void) requestForCityList {
    NSString *notfication = @"requestForCityListReturned";
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(requestForCityListReturned:) 
     name:notfication 
     object:nil];
    
    CityListRequest *cityListRequest = [[[CityListRequest alloc] init] autorelease];
    [cityListRequest initiateRequestWithURL:[NSURL URLWithString: @"http://socialcitydeals.com/api/list_city"] 
                           andNotification:notfication];
    
    [self.activityIndicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void) requestForCityListReturned: (NSNotification *) notification {
    [[NSNotificationCenter defaultCenter] removeObserver: self name:@"requestForCityListReturned" object:nil];
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
            
            lookingForCurrentLocation = YES;
            [self performSelector: @selector(notAllowedToUseCurrentLocation:) withObject: self afterDelay: 30.0f];
        }
    }
    
}

- (void) removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:@"AppObtainedCurrentLocation" 
                                                  object:nil]; 
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:@"AppNotAllowedToUseCurrentLocation" 
                                                  object:nil]; 
}

- (void) obtainedCurrentLocation: (id) sender
{
    [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(notAllowedToUseCurrentLocation:) object: self];
}

- (void) notAllowedToUseCurrentLocation: (id) sender
{
    NSString *message = @"We were unable to determine your current location.  Please select a city to see its current deals.";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Location Error" 
                                                    message: message
                                                   delegate:self 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    [alert show];    
    [alert release];
}

- (void) seeIfWeGotACurrentLocation: (id) object
{
	if (lookingForCurrentLocation == YES)
	{
		if (finishedLookingForCurrentLocation == NO)
		{
			[self performSelector: @selector(seeIfWeGotACurrentLocation:) withObject: self afterDelay: 0.5f];
		} 
		else
		{
			lookingForCurrentLocation = NO;
			// Have current location

			//TODO Continue on with search...
			if (allowedToUseLocationServices == YES)
			{
				
			} 
			else
			{

			}
		}
	}
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self performSelector:@selector(dismissView) withObject:nil afterDelay:5.0];
    
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
    [super dealloc];
}
- (IBAction)tryAgainTouched:(id)sender {
    if ([self deviceCanSearch]) {
        [self requestForCityList];
    }
}
@end
