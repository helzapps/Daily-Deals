//
//  DailyDealsAppDelegate.h
//  Daily Deals
//
//  Created by Jordan Helzer on 12/4/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyDealsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UITabBarController *tabBarController;

@end
