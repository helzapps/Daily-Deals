//
//  GenericWebController.h
//  Glovebox
//
//  Created by Ryan Mitchell on 5/26/11.
//  Copyright 2011 Tigersoft. All rights reserved.
//  
//  Modified by Jordan Helzer on 12/10/11 for Daily Deals
//  

#import "GenericWebController.h"

@implementation GenericWebController

@synthesize urlToLoad, webView, titleLabel, myTitle;

- (void) alertView: (UIAlertView *) alertView didDismissWithButtonIndex: (NSInteger) buttonIndex {
	if (buttonIndex == 1) {
		NSURL *url = [NSURL URLWithString: urlToLoad];
		[[UIApplication sharedApplication] openURL: url];
	}
}

- (void) openInSafari 
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Safari" message: @"Would you like to close Daily Deals and open Safari?"
												   delegate:self cancelButtonTitle:nil otherButtonTitles: @"No", @"Yes", nil];
	[alert show];    
	[alert release]; 
}

- (id) initWithUrl: (NSString *) urlString
{
    if ((self = [super init])) 
	{
        self.urlToLoad = urlString;
		
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 50)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize: 20.0];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = titleLabel;	
		
		
		hasSafari = YES;
		UIBarButtonItem *buttonSafari = [[UIBarButtonItem alloc] initWithTitle:@"Safari" style:UIBarButtonItemStylePlain target: self action: @selector(openInSafari)];
		self.navigationItem.rightBarButtonItem = buttonSafari;
		[buttonSafari release];
		
		hasNav = YES;
		UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"previousIcon.png"] style: UIBarButtonItemStylePlain target: self action: @selector(navigateBack:)];
		UIBarButtonItem *forwardBtn = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"nextIcon.png"] style: UIBarButtonItemStylePlain target: self action: @selector(navigateForward:)];
		
		UIBarButtonItem *stopBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemStop target: self action: @selector(stopLoading:)];
		UIBarButtonItem *reloadBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemRefresh target: self action: @selector(refresh:)];
		UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
		UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target: nil action: nil];
		[space setWidth:10.0f];
		
		self.toolbarItems = [NSArray arrayWithObjects: space, backBtn,flex, stopBtn, flex, reloadBtn, flex, forwardBtn, space, nil];
		
		[backBtn release];
		[forwardBtn release];
		[stopBtn release];
		[reloadBtn release];
		[flex release];
		[space release];
    }
    return self;
}

- (void) viewDidLoad 
{
    [super viewDidLoad];
	
	NSURL *nsurlToLoad = [[NSURL alloc] initWithString: urlToLoad];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: nsurlToLoad];
	self.webView.delegate = self;
	[self.webView loadRequest:request];
	
	[request release];
	[nsurlToLoad release];
}

-(void) viewWillAppear: (BOOL) animated
{
	[super viewWillAppear: animated];
	titleLabel.text = myTitle;
	[self.navigationController setToolbarHidden: !hasNav animated:YES];
	if (!hasSafari) {
		self.navigationItem.rightBarButtonItem = nil;
	}
}

-(void) viewWillDisappear: (BOOL) animated
{	
	[super viewWillDisappear:animated];
	[webView stopLoading];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self.navigationController setToolbarHidden:YES animated:YES];
}

-(void) setTitle: (NSString *) newTitle
{
	self.myTitle = newTitle;
}

-(void) setHasNav: (BOOL) hasNavigation
{
	hasNav = hasNavigation;
}

-(void) setHasSafari: (BOOL) localHasSafari
{
	hasSafari = localHasSafari;
}

-(void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) viewDidUnload 
{
    [super viewDidUnload];
	[webView stopLoading];
    self.webView.delegate = nil;
	self.webView = nil;
}


- (void) dealloc 
{
	[webView stopLoading];
	self.webView.delegate = nil;
	self.webView = nil;
	[titleLabel release];
	[urlToLoad release];
	[myTitle release];
    [super dealloc];
}

-(void) stopLoading: (UIBarButtonItem *) button
{
	[webView stopLoading];
}

-(void) refresh: (UIBarButtonItem *) button
{
	[webView reload];
}

-(void) navigateBack: (UIBarButtonItem *) button
{
	if([webView canGoBack])
		[webView goBack];
}

-(void) navigateForward: (UIBarButtonItem *) button
{
	if([webView canGoForward])
		[webView goForward];
}

-(void) webViewDidStartLoad: (UIWebView *) webView
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
}

-(void) webViewDidFinishLoad: (UIWebView *) webView
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
}

-(void) webView:(UIWebView *) webView didFailLoadWithError: (NSError *) error
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
}

- (IBAction) cancel: (id) sender {
	[self.navigationController popViewControllerAnimated: YES];
}

@end
