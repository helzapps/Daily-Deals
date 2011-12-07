//
//  LocationViewController.h
//  Daily Deals
//
//  Created by Jordan Helzer on 12/5/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationViewController : UIViewController {
    BOOL finishedLookingForCurrentLocation;
	BOOL lookingForCurrentLocation;
	BOOL allowedToUseLocationServices;
}

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UIButton *tryAgainButton;
- (IBAction)tryAgainTouched:(id)sender;

@end
