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
@synthesize location;
@synthesize name;

- (void) dealloc 
{
    [super dealloc];
    [uname release];
    [location release];
    [name release];
}

@end
