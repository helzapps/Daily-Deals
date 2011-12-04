//
//  CityListRequest.m
//  Daily Deals
//
//  Created by Jordan Helzer on 12/4/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import "CityListRequest.h"

@implementation CityListRequest


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [connection release];
    
    NSError *error;
    NSDictionary *theReturnedData = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableContainers error:&error];
    
    NSDictionary *returnData = [NSDictionary dictionaryWithObject:theReturnedData forKey:kServiceResponse];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: self.theNotification object: self userInfo: returnData];

}

- (void) dealloc {
    [super dealloc];
}


@end
