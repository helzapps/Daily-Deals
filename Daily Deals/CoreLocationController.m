//
//  CoreLocationController.m
//  Daily Deals
//
//  Created by Jordan Helzer on 12/5/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import "CoreLocationController.h"

// This is a singleton class, see below
static CoreLocationController *sharedCoreLocationDelegate = nil;

@implementation CoreLocationController

@synthesize locationManager, bestEffortAtLocation;

- (id) init {
	self = [super init];
	if (self != nil) {
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
		locationManager.delegate = self; // Tells the location manager to send updates to this object
		locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
		// Set a movement threshold for new events
		locationManager.distanceFilter = kCLDistanceFilterNone;
		self.bestEffortAtLocation = nil;
	}
	return self;
}

- (void) startUpdates
{
    [locationManager startUpdatingLocation];
}

// Called when the location is updated
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    // If it's a relatively recent event, turn off updates to save power
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 5.0)
    {
		// test that the horizontal accuracy does not indicate an invalid measurement
		if (newLocation.horizontalAccuracy < 0) return;
		// test the measurement to see if it is more accurate than the previous measurement
		if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
			// store the location as the "best effort"
			self.bestEffortAtLocation = newLocation;
        }
		// test the measurement to see if it meets the desired accuracy
		//
		// IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue 
		// accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of 
		// acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
		//
		if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
			// we have a measurement that meets our requirements, so we can stop updating the location
			// 
			// IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
			//
			[manager stopUpdatingLocation];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"AppObtainedCurrentLocation" object:self];  
		}
    }
    // else skip the event and process the next one.
}

// Called when there is an error getting the location
- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	if ([error domain] == kCLErrorDomain) {
		// Handle CoreLocation-related errors here
		switch ([error code]) {
                // This error code is usually returned whenever user taps "Don't Allow" in response to
                // being told your app wants to access the current location. Once this happens, you cannot
                // attempt to get the location again until the app has quit and relaunched.
                //
                // "Don't Allow" on two successive app launches is the same as saying "never allow". The user
                // can reset this for all apps by going to Settings > General > Reset > Reset Location Warnings.
                //
			case kCLErrorDenied:
				[manager stopUpdatingLocation];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"AppNotAllowedToUseCurrentLocation" object:self];  
				break;
                
                // This error code is usually returned whenever the device has no data or WiFi connectivity,
                // or when the location cannot be determined for some other reason.
                //
                // CoreLocation will keep trying, so you can keep waiting, or prompt the user.
                //
			case kCLErrorLocationUnknown:
				break;
                
                // We shouldn't ever get an unknown error code, but just in case...
                //
			default:
				break;
		}
	} else {
		// All non-CoreLocation errors 
	}
}

#pragma mark ---- singleton object methods ----

// See "Creating a Singleton Instance" in the Cocoa Fundamentals Guide for more info

+ (CoreLocationController *)sharedInstance {
    @synchronized(self) {
        if (sharedCoreLocationDelegate == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedCoreLocationDelegate;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedCoreLocationDelegate == nil) {
            sharedCoreLocationDelegate = [super allocWithZone:zone];
            return sharedCoreLocationDelegate;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (oneway void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end
