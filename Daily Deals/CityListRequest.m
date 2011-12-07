//
//  CityListRequest.m
//  Daily Deals
//
//  Created by Jordan Helzer on 12/4/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import "CityListRequest.h"
#import "CityInfo.h"
#import <CoreLocation/CoreLocation.h>

@implementation CityListRequest
@synthesize cityList;

- (NSArray *) createCityList: (NSArray *)unprocessedCityList {

    NSMutableArray *listOfCityInfoObjects = [[[NSMutableArray alloc] init] autorelease];
    for (NSDictionary *cityInformation in unprocessedCityList) {
        NSDictionary *cordinate = [cityInformation objectForKey:@"location"];
        CityInfo *cityInfo = [[CityInfo alloc] initWithUname:[cityInformation objectForKey:@"uname"] 
                                              name:[cityInformation objectForKey:@"name"] 
                                         longitude:[cordinate objectForKey:@"lng"] 
                                          latitude:[cordinate objectForKey:@"lat"]];
        [listOfCityInfoObjects addObject:cityInfo];
        [cityInfo release];
    }
    
    return listOfCityInfoObjects;
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [connection release];
    
    NSError *error;
    NSDictionary *theReturnedData = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *unprocessedCityList = [theReturnedData objectForKey:@"result"];
    
    NSDictionary *returnData = [NSDictionary dictionaryWithObject:[self createCityList:unprocessedCityList] forKey:kServiceResponse];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: self.theNotification object: self userInfo: returnData];

}

- (void) dealloc {
    [super dealloc];
    [cityList release];
}


@end
