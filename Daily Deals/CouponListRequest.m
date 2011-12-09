//
//  CouponListRequest.m
//  Daily Deals
//
//  Created by Jordan Helzer on 12/7/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import "CouponListRequest.h"
#import "CouponInfo.h"

@implementation CouponListRequest

@synthesize couponList;

- (NSArray *) createCouponList:(NSArray *) unprocessedCouponList {
    NSMutableArray *listOfCouponInfoObjects = [[[NSMutableArray alloc] init] autorelease];
    for (NSDictionary *couponInfoDictionary in unprocessedCouponList) {
        CouponInfo *couponInfo = [[CouponInfo alloc] init];
        couponInfo.category = [couponInfoDictionary objectForKey:@"category"];
        couponInfo.city = [couponInfoDictionary objectForKey:@"city"];
        couponInfo.totalSold = [couponInfoDictionary objectForKey:@"total_sold"];
        couponInfo.dealTipped = [[couponInfoDictionary objectForKey:@"deal_tipped"] boolValue];
        couponInfo.dealID = [couponInfoDictionary objectForKey:@"deal_id"];
        couponInfo.tags = [couponInfoDictionary objectForKey:@"tags"];
        couponInfo.merchant = [couponInfoDictionary objectForKey:@"merchant"];
        couponInfo.national = [[couponInfoDictionary objectForKey:@"national"] boolValue];
        couponInfo.title = [couponInfoDictionary objectForKey:@"title"];
        couponInfo.site = [couponInfoDictionary objectForKey:@"site"];
        couponInfo.value = [couponInfoDictionary objectForKey:@"value"];
        couponInfo.couponExpiration = [couponInfoDictionary objectForKey:@"expiry"];
        couponInfo.discountPercentage = [couponInfoDictionary objectForKey:@"discount"];
        couponInfo.soldOut = [[couponInfoDictionary objectForKey:@"sold_out"] boolValue];
        couponInfo.couponURL = [couponInfoDictionary objectForKey:@"url"];
        couponInfo.address = [couponInfoDictionary objectForKey:@"address"];
        couponInfo.purchaseNeeded = [couponInfoDictionary objectForKey:@"purchase_needed"];
        couponInfo.imageURL = [couponInfoDictionary objectForKey:@"img_url"];
        couponInfo.price = [couponInfoDictionary objectForKey:@"price"];
        couponInfo.categories = [couponInfoDictionary objectForKey:@"categories"];
        
        [listOfCouponInfoObjects addObject:couponInfo];
        [couponInfo release];
    }
    
    return listOfCouponInfoObjects;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [connection release];
    
    NSError *error;
    NSDictionary *theReturnedData = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableContainers error:&error];
    
    NSDictionary *returnData = nil;
    NSString *requestStatus = [theReturnedData objectForKey:@"info"];
    if ([requestStatus isEqualToString:@"OK"]) {
        NSArray *unprocessedCouponList = [theReturnedData objectForKey:@"result"];
        returnData = [NSDictionary dictionaryWithObject:[self createCouponList:unprocessedCouponList] forKey:kServiceResponse];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName: self.theNotification object: self userInfo: returnData];

}

- (void) dealloc {
    [super dealloc];
    [couponList release];
}

@end
