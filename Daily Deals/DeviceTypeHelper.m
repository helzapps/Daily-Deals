//
//  DeviceTypeHelper.m
//  Daily Deals
//
//  Created by Jordan Helzer on 12/5/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import "DeviceTypeHelper.h"

@implementation DeviceTypeHelper

+(BOOL)CameraAvailable
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
		return YES;
	else
		return NO;
}

+(BOOL)PhoneAvailable
{
	NSString *deviceType = [UIDevice currentDevice].model;
	
	if([deviceType isEqualToString:@"iPhone"])
		return YES;
	else
		return NO;
}

+(void)ShowPhoneNotAvailableAlert
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Phone Not Available" message: @"This device does not have a phone function."
												   delegate:self cancelButtonTitle:nil otherButtonTitles: @"OK", nil];
	[alert show];    
	[alert release];
}

+(void)ShowInternetNotAvailableAlert
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Not Available" 
													message: @"Please verify that you have a cellular or WiFi connection."
												   delegate:self cancelButtonTitle:nil otherButtonTitles: @"OK", nil];
	[alert show];    
	[alert release];
}

+(BOOL)FlashAvailable 
{
    return  ([UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear]) ? YES : NO;
}

+(NetworkStatus)ConnectionToInternetStatus
{
	[[DeviceReachabilityHelper sharedReachability] setHostName:@"www.google.com"];
	
	return [[DeviceReachabilityHelper sharedReachability] internetConnectionStatus];
}

@end
