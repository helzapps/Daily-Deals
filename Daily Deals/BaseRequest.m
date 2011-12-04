//
//  BaseRequest.m
//  Daily Deals
//
//  Created by Jordan Helzer on 11/1/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import "BaseRequest.h"

@implementation BaseRequest
@synthesize receivedData;
@synthesize theNotification;

- (void) initiateRequestWithURL:(NSURL *) url andNotification:(NSString *) notification {
    self.theNotification = notification;
    NSURLRequest *theRequest = [NSURLRequest 
                                requestWithURL:url
                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                timeoutInterval:60.0];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if (theConnection) {
        receivedData = [[NSMutableData data] retain];
    }
    else {
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Not Available" 
													message: @"Please verify that you have a cellular or WiFi connection."
												   delegate:self cancelButtonTitle:nil otherButtonTitles: @"OK", nil];
	[alert show];    
	[alert release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: theNotification object: self userInfo: nil];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [connection release];
    
    NSError *error;
    NSDictionary *theReturnedData = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableContainers error:&error];
    [[NSNotificationCenter defaultCenter] postNotificationName: theNotification object: self userInfo: theReturnedData];
}

- (void) dealloc {
    [super release];
    [receivedData release];
    [theNotification release];
}

@end
