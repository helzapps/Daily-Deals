//
//  DeviceTypeHelper.h
//  Daily Deals
//
//  Created by Jordan Helzer on 12/5/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "DeviceReachabilityHelper.h"

@interface DeviceTypeHelper : NSObject
{
}

+(BOOL)CameraAvailable;
+(BOOL)PhoneAvailable;
+(void)ShowPhoneNotAvailableAlert;
+(void)ShowInternetNotAvailableAlert;
+(BOOL)FlashAvailable;

+(NetworkStatus)ConnectionToInternetStatus;

@end
