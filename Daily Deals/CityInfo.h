//
//  CityInfo.h
//  Daily Deals
//
//  Created by Jordan Helzer on 12/4/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CityInfo : NSObject

@property (nonatomic, retain) NSString *uname;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSString *name;

- (CityInfo *) initWithUname: (NSString *)_uname name: (NSString *)_name longitude: (NSNumber *)_longitude latitude: (NSNumber *)_latitude;

@end
