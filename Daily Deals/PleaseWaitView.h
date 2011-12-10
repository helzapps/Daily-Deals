//
//  PleaseWaitView.h
//  Daily Deals
//
//  Created by Jordan Helzer on 12/8/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PleaseWaitView;

@protocol PleaseWaitViewDelegate <NSObject>

@optional

- (void) dismissViewPleaseWaitView;

@end

@interface PleaseWaitView : UIViewController

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) id <PleaseWaitViewDelegate> delegate;

@end
