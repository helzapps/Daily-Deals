//
//  BaseRequest.h
//  Daily Deals
//
//  Created by Jordan Helzer on 11/1/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#define kServiceResponse @"webServiceReturn"

@interface BaseRequest : NSObject

@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSString *theNotification;

- (void) initiateRequestWithURL:(NSURL *) url andNotification:(NSString *) notification;

@end
