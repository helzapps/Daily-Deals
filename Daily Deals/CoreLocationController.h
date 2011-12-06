//
//  CoreLocationController.h
//  Daily Deals
//
//  Created by Jordan Helzer on 12/5/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CoreLocationController : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
    CLLocation *bestEffortAtLocation;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *bestEffortAtLocation;

- (void) startUpdates;

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error;

+ (CoreLocationController *)sharedInstance;

@end
