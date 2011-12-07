//
//  CityInfo.m
//  Daily Deals
//
//  Created by Jordan Helzer on 12/4/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import "CityInfo.h"

@implementation CityInfo

@synthesize uname;
@synthesize longitude;
@synthesize latitude;
@synthesize name;

- (CityInfo *) initWithUname: (NSString *)_uname name: (NSString *)_name longitude: (NSNumber *)_longitude latitude: (NSNumber *)_latitude {
    self.uname = _uname;
    self.name = _name;
    self.longitude = _longitude;
    self.latitude = _latitude;
    return self;
}

- (void) dealloc 
{
    [super dealloc];
    [uname release];
    [name release];
    [longitude release];
    [latitude release];
}

@end
