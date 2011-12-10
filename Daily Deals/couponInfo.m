//
//  CouponInfo.m
//  Daily Deals
//
//  Created by Jordan Helzer on 12/7/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import "CouponInfo.h"

@implementation CouponInfo

@synthesize category;
@synthesize city;
@synthesize totalSold;
@synthesize dealTipped;
@synthesize dealID;
@synthesize tags;
@synthesize merchant;
@synthesize national;
@synthesize title;
@synthesize site;
@synthesize value;
@synthesize couponExpiration;
@synthesize discountPercentage;
@synthesize soldOut;
@synthesize couponURL;
@synthesize address;
@synthesize purchaseNeeded;
@synthesize imageURL;
@synthesize imageData;
@synthesize price;
@synthesize categories;
@synthesize saving;
@synthesize originalPrice;

- (void) dealloc {
    [super dealloc];
    [category release];
    [city release];
    [totalSold release];
    [dealID release];
    [tags release];
    [merchant release];
    [title release];
    [site release];
    [value release];
    [couponExpiration release];
    [discountPercentage release];
    [address release];
    [purchaseNeeded release];
    [imageData release];
    [price release];
    [categories release];
    [saving release];
    [originalPrice release];
}

@end
