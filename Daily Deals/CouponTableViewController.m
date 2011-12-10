//
//  CouponTableViewController.m
//  Daily Deals
//
//  Created by Jordan Helzer on 12/7/11.
//  Copyright (c) 2011 HelzApps. All rights reserved.
//

#import "CouponTableViewController.h"
#import "CouponInfo.h"
#import "CouponListRequest.h"
#import "PleaseWaitView.h"


@implementation CouponTableViewController

@synthesize couponList;
@synthesize cityList;
@synthesize currentCityInfo;
@synthesize tableViewCell;
@synthesize selectACityViewController;
@synthesize setupViewController;
@synthesize newCitySelected;
@synthesize couponDetailViewController;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) dealloc {
    [super dealloc];
    [cityList release];
    [currentCityInfo release];
    [tableViewCell release];
    [couponList release];
    [selectACityViewController release];
    [setupViewController release];
}

- (void) citiesButtonTouched {
    if (self.selectACityViewController == nil) {
        self.selectACityViewController = [[SelectACityViewController alloc] init];
        self.selectACityViewController.delegate = self;
        self.selectACityViewController.currentCity = currentCityInfo;
        self.selectACityViewController.cityList = cityList;
        self.selectACityViewController.appSetup = NO;
    }
    
    [self.navigationController presentModalViewController:selectACityViewController animated:YES];
}

#pragma mark - View lifecycle

- (void) setupViewController:(SetupViewController *)controller didFinishFindingLocationWithInfo:(NSDictionary *)setupInfo {
    self.currentCityInfo = [setupInfo objectForKey:kSetupInfoKeyCityInfo];
    self.cityList = [setupInfo objectForKey:kSetupInfoKeyListOfCities];
    self.couponList = [setupInfo objectForKey:kSetupInfoKeyListOfCoupons];
    
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0,0,180,50)] autorelease];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.text = [NSString stringWithFormat:@"%@ Deals", currentCityInfo.name];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    self.title = titleLabel.text;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    [self.tableView reloadData];
}

- (void) displayPleaseWaitView {
    PleaseWaitView *pleaseWaitView = [[[PleaseWaitView alloc] init] autorelease];
    [self presentModalViewController:pleaseWaitView animated:NO];
}

- (void) dismissViewPleaseWaitView {
    [self dismissModalViewControllerAnimated:NO];
    self.newCitySelected = NO;
}

- (void) requestForCouponList {
    NSString *notification = @"requestForCouponListReturned";
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(requestForCouponListReturned:) 
     name:notification
     object:nil];
    
    CouponListRequest *couponListRequest = [[[CouponListRequest alloc] init] autorelease];
    [couponListRequest initiateRequestWithURL:[NSURL URLWithString:
                                               [NSString stringWithFormat:@"http://socialcitydeals.com/api/daily-deals/%@", currentCityInfo.uname]]
                              andNotification:notification];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

- (void) requestForCouponListReturned:(NSNotification *) notification {
    [[NSNotificationCenter defaultCenter] removeObserver: self name:@"requestForCouponListReturned" object:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (notification.userInfo == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"I'm Sorry"
                                                        message:@"There seems to be an issue.  Please try again later."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else {
        [couponList retain];
        self.couponList = [notification.userInfo objectForKey:kServiceResponse];
        [self.tableView reloadData];
        
        UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0,0,180,50)] autorelease];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = [NSString stringWithFormat:@"%@ Deals", currentCityInfo.name];
        [titleLabel sizeToFit];
        self.navigationItem.titleView = titleLabel;
        self.title = titleLabel.text;
        
        [self performSelectorInBackground:@selector(fillInCouponImages) withObject:nil];
        [self dismissViewPleaseWaitView];
    }
}

- (void) selectACityViewController:(SelectACityViewController *)controller didFinishFindingLocationWithInfo:(CityInfo *)selectedCity {
    if (![currentCityInfo isEqual:selectedCity]) {
        self.newCitySelected = YES;
        [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(fillInCouponImages) object: self];
        self.currentCityInfo = selectedCity;
        
        [self requestForCouponList];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.setupViewController == nil) {
        self.setupViewController = [[SetupViewController alloc] init];
        self.setupViewController.delegate = self;
    }
    
    self.couponList = [[NSArray alloc] init];

    [self.navigationController presentModalViewController:setupViewController animated:NO];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    UIBarButtonItem *cities = [[UIBarButtonItem alloc] initWithTitle:@"Cities" 
                                                               style:UIBarButtonItemStyleBordered 
                                                              target:self
                                                              action:@selector(citiesButtonTouched)];
    self.navigationItem.rightBarButtonItem = cities;
    [cities release];
    
    self.clearsSelectionOnViewWillAppear = YES;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setCurrentCityInfo:nil];
    [self setCouponList:nil];
    [self setCityList:nil];
    [self setTableViewCell:nil];
    [self setSelectACityViewController:nil];
    [self setSetupViewController:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelectorInBackground:@selector(fillInCouponImages) withObject:nil];
    if (newCitySelected) {
        [self displayPleaseWaitView];
        newCitySelected = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSData *) getRemoteImage: (NSString *) imageFileName {	
	NSURL *url = [NSURL URLWithString: imageFileName];
	NSError *errorPtr = nil;
	NSData *data = [NSData 	
					dataWithContentsOfURL: url options: NSUncachedRead error: &errorPtr];
	if (errorPtr != nil) {
		NSLog(@"Unresolved error %@, %@", [errorPtr localizedDescription], [errorPtr userInfo]);
		return nil;
	}
	
	return data;
}

- (void) fillInCouponImages {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    for (CouponInfo *couponInfo in couponList) {
        if (couponInfo.imageData == nil) {
            couponInfo.imageData = [self getRemoteImage:couponInfo.imageURL];
        }
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [couponList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CouponCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"CouponCell" owner:self options:nil];
        cell = tableViewCell;
        self.tableViewCell = nil;
    }
    
    // Configure the cell...
    NSInteger row = indexPath.row;
    CouponInfo *couponInfo = [couponList objectAtIndex:row];
    
    if (couponInfo.imageData == nil) {
        couponInfo.imageData = [self getRemoteImage:couponInfo.imageURL];
    }
    
    UIImage *image = [UIImage imageWithData:couponInfo.imageData];
    CGSize imageSize = CGSizeMake(105.0, 79.0);
    UIGraphicsBeginImageContext(imageSize);
    CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    [image drawInRect:imageFrame];
    
    UIImageView *imageView;
    imageView = (UIImageView *)[cell viewWithTag:6];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:1];
    label.text = couponInfo.title;
    
    label = (UILabel *)[cell viewWithTag:2];
    label.text = [NSString stringWithFormat:@"$%@", couponInfo.price];
    
    label = (UILabel *)[cell viewWithTag:3];
    if (couponInfo.discountPercentage != nil) {
        label.text = [NSString stringWithFormat:@"%@%% Off", couponInfo.discountPercentage];
        label.hidden = NO;
    } else {
        label.hidden = YES;
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    CouponInfo *couponInfo = [couponList objectAtIndex:row];
    
    couponDetailViewController = [[CouponDetailViewController alloc] init];
    couponDetailViewController.couponInfo = couponInfo;
    
    [self.navigationController pushViewController:couponDetailViewController animated:YES];
    [couponDetailViewController release];
}

@end
