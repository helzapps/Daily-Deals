//
//  CouponDetailViewController.h
//  Daily Deals
//
//  Created by Jordan Helzer on 12/8/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponInfo.h"

@interface CouponDetailViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIImageView *couponImage;
@property (retain, nonatomic) IBOutlet UILabel *couponSiteLabel;
@property (retain, nonatomic) IBOutlet UIView *couponSiteView;
@property (retain, nonatomic) IBOutlet UIImageView *couponSiteImage;
@property (retain, nonatomic) IBOutlet UILabel *couponTitle;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UILabel *discountPercentageLabel;
@property (retain, nonatomic) IBOutlet UILabel *originalPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *savingsLabel;
@property (retain, nonatomic) IBOutlet UILabel *numberSoldLabel;
@property (retain, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *expirationLabel;
@property (retain, nonatomic) CouponInfo *couponInfo;
@property (retain, nonatomic) NSDictionary *siteNames;

- (IBAction)purchaseButtonTouched:(id)sender;

@end
