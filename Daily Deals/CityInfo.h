//
//  CityInfo.h
//  Daily Deals
//
//  Created by Jordan Helzer on 12/4/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface CityInfo : NSObject

@property (nonatomic, retain) NSString *uname;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double latitude;
@property (nonatomic, retain) NSString *name;

- (CityInfo *) initWithUname: (NSString *)_uname name: (NSString *)_name longitude: (double)_longitude latitude: (double)_latitude;

@end
