//
//  GenericWebController.h
//  Glovebox
//
//  Created by Ryan Mitchell on 5/26/11.
//  Copyright 2011 Tigersoft. All rights reserved.
//  
//  Modified by Jordan Helzer on 12/10/11 Daily Deals
//  

#import <UIKit/UIKit.h>

@interface GenericWebController : UIViewController <UIWebViewDelegate>
{
	NSString *urlToLoad;
	UIWebView *webView;
	NSString *myTitle;
	UILabel *titleLabel;
	BOOL hasNav;
	BOOL hasSafari;
}

@property (nonatomic, retain) NSString *urlToLoad;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *myTitle;

- (id) initWithUrl: (NSString*) urlString;
-(void) setHasNav: (BOOL) hasNavigation;
-(void) setHasSafari: (BOOL) hasSafari;
- (IBAction) cancel: (id) sender;

@end
