//
//  CouponInfo.h
//  Daily Deals
//
//  Created by Jordan Helzer on 12/7/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponInfo : NSObject

@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *totalSold;
@property (nonatomic, assign) BOOL dealTipped;
@property (nonatomic, retain) NSString *dealID;
@property (nonatomic, retain) NSArray *tags;
@property (nonatomic, retain) NSString *merchant;
@property (nonatomic, assign) BOOL national;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *site;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSString *couponExpiration;
@property (nonatomic, retain) NSString *discountPercentage;
@property (nonatomic, assign) BOOL soldOut;
@property (nonatomic, retain) NSString *couponURL;
@property (nonatomic, retain) NSArray *address;
@property (nonatomic, retain) NSString *purchaseNeeded;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) NSData *imageData;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *originalPrice;
@property (nonatomic, retain) NSArray *categories;
@property (nonatomic, retain) NSString *saving;

@end
