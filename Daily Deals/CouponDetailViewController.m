//
//  CouponDetailViewController.m
//  Daily Deals
//
//  Created by Jordan Helzer on 12/8/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import "CouponDetailViewController.h"
#import "GenericWebController.h"

@implementation CouponDetailViewController
@synthesize couponSiteLabel;
@synthesize couponImage;
@synthesize couponSiteView;
@synthesize couponSiteImage;
@synthesize couponTitle;
@synthesize priceLabel;
@synthesize discountPercentageLabel;
@synthesize originalPriceLabel;
@synthesize savingsLabel;
@synthesize numberSoldLabel;
@synthesize companyNameLabel;
@synthesize expirationLabel;
@synthesize couponInfo;
@synthesize siteNames;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSDate *) formatDateFromString:(NSString *) dateString {
    NSDateFormatter *extractor = [[NSDateFormatter alloc] init];
    [extractor setTimeStyle:NSDateFormatterFullStyle];
    [extractor setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [extractor dateFromString:dateString];
    [extractor release];
    return date;
}

- (NSString *) formatExpirationTextUsingTimeInterval:(double) secondsBetweenNowAndCouponExpiration {
    NSString *expirationText;
    
    int weeks = (int)(secondsBetweenNowAndCouponExpiration/60/60/24/7);
    int days = (int)((secondsBetweenNowAndCouponExpiration/60/60/24) - (weeks * 7));
    int hours = (int)((secondsBetweenNowAndCouponExpiration/60/60) - (days * 24));
    int minutes = (int)((secondsBetweenNowAndCouponExpiration/60) - ((days * 24) * 60));
    
    if (weeks >= 2) {
        expirationText = [NSString stringWithFormat:@"Expires in: %i weeks", weeks];
    } else if (weeks == 1) {
        expirationText = [NSString stringWithFormat:@"Expires in: %i week", weeks];
    } else if (days >= 2) {
        if (hours > 1) {
            expirationText = [NSString stringWithFormat:@"Expires in: %i days and %i hours", days, hours];
        } else {
            expirationText = [NSString stringWithFormat:@"Expires in: %i days", days];
        }
    } else if (days == 1) {
        if (hours > 1) {
            expirationText = [NSString stringWithFormat:@"Expires in: %i day and %i hours", days, hours];
        } else {
            expirationText = [NSString stringWithFormat:@"Expires in: %i day", days];
        }
    } else {
        if (hours > 1) {
            expirationText = [NSString stringWithFormat:@"Expires in: %i hours", hours];
        } else {
            expirationText = [NSString stringWithFormat:@"Expires in: %i minutes", minutes];
        }
    }
    
    return expirationText;
}

- (void) initializeMyself {
    NSString *siteImagesPlistBundlePath = [[NSBundle mainBundle] pathForResource:@"siteImages" ofType:@"plist"];
    NSDictionary *siteImages = [NSDictionary dictionaryWithContentsOfFile:siteImagesPlistBundlePath];
    self.siteNames = [siteImages objectForKey:@"siteImages"];
    
    UIImage *image = [UIImage imageWithData:couponInfo.imageData];
    CGSize imageSize = CGSizeMake(132.0, 100.0);
    UIGraphicsBeginImageContext(imageSize);
    CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    [image drawInRect:imageFrame];
    
    self.couponImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    image = [UIImage imageNamed:[siteNames objectForKey:couponInfo.site]];
    if (image != nil) {
        self.couponSiteImage.image = image;
    } else {
        couponSiteView.hidden = YES;
        self.couponSiteLabel.text = couponInfo.site;
    }
    
    self.couponTitle.text = couponInfo.title;
    
    self.couponSiteLabel.text = couponInfo.site;
    
    self.priceLabel.text = [NSString stringWithFormat:@"$%@", couponInfo.price];
    
    if (couponInfo.discountPercentage != nil) {
        self.discountPercentageLabel.text = [NSString stringWithFormat:@"%@%% Off", couponInfo.discountPercentage];
    } else {
        discountPercentageLabel.hidden = YES;
    }

    
    if (couponInfo.saving != nil) {
        self.originalPriceLabel.text = [NSString stringWithFormat:@"$%@", couponInfo.originalPrice];
        self.savingsLabel.text = [NSString stringWithFormat:@"Save $%@", couponInfo.saving];
    } else {
        self.originalPriceLabel.hidden = YES;
        self.savingsLabel.hidden = YES;
    }
    
    self.numberSoldLabel.text = [NSString stringWithFormat:@"%@", couponInfo.totalSold];
    
    self.companyNameLabel.text = couponInfo.merchant;
    
    NSString *dateString = [couponInfo.couponExpiration stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    NSTimeInterval secondsBetweenNowAndCouponExpiration = [[self formatDateFromString:dateString] timeIntervalSinceNow];
    NSString *expirationText = [self formatExpirationTextUsingTimeInterval:secondsBetweenNowAndCouponExpiration];
    
    self.expirationLabel.text = expirationText;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeMyself];
}

// Hides the tabbar when view is displayed
- (BOOL) hidesBottomBarWhenPushed {
    return YES;
}

- (void)viewDidUnload
{
    [self setCouponImage:nil];
    [self setCouponSiteView:nil];
    [self setCouponSiteImage:nil];
    [self setCouponTitle:nil];
    [self setPriceLabel:nil];
    [self setDiscountPercentageLabel:nil];
    [self setOriginalPriceLabel:nil];
    [self setSavingsLabel:nil];
    [self setNumberSoldLabel:nil];
    [self setCompanyNameLabel:nil];
    [self setExpirationLabel:nil];
    [self setCouponSiteLabel:nil];
    [self setSiteNames:nil];
    [self setCouponInfo:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [couponImage release];
    [couponSiteView release];
    [couponSiteImage release];
    [couponTitle release];
    [priceLabel release];
    [discountPercentageLabel release];
    [originalPriceLabel release];
    [savingsLabel release];
    [numberSoldLabel release];
    [companyNameLabel release];
    [expirationLabel release];
    [couponSiteLabel release];
    [siteNames release];
    [couponInfo release];
    [super dealloc];
}

- (IBAction)purchaseButtonTouched:(id)sender {
    GenericWebController *genericWebController = [[GenericWebController alloc] initWithUrl:couponInfo.couponURL];
    genericWebController.title = couponInfo.site;
    [self.navigationController pushViewController:genericWebController animated:YES];
}

@end
