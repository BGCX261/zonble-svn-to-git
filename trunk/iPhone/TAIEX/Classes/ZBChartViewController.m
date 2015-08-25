//
//  ZBChartViewController.m
//  TAIEX
//
//  Created by zonble on 2008/12/24.
//  Copyright 2008 zonble.twbbs.org. All rights reserved.
//

#import "ZBChartViewController.h"

static ZBChartViewController *chartViewController;

@implementation ZBChartViewController

+ (id)sharedController
{
	if (!chartViewController)
		chartViewController = [[ZBChartViewController alloc] initWithNibName:@"ZBChartViewController" bundle:[NSBundle mainBundle]];
	return chartViewController;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];	
	_imageView.contentMode = (UIViewContentModeScaleAspectFit);
	_imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	_imageView.backgroundColor = [UIColor blackColor];
	_scrollView.backgroundColor = [UIColor blackColor];
	_scrollView.canCancelContentTouches = NO;
	_scrollView.clipsToBounds = YES; 
	_scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//
	_scrollView.minimumZoomScale = 1;
	_scrollView.maximumZoomScale = 2.5;
	_scrollView.delegate = self;
	[_scrollView setScrollEnabled:YES];
	self.title = [NSString stringWithUTF8String:"量價走勢圖"];	
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[self navigationController] navigationBar].barStyle = UIBarStyleBlackOpaque;
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	NSLog(@"shouldAutorotateToInterfaceOrientation:%d", interfaceOrientation);
    // Return YES for supported orientations
    // return (interfaceOrientation == UIInterfaceOrientationPortrait);
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];

	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
		CGAffineTransform transform = CGAffineTransformMakeRotation(-90 * 3.14/180);
		_imageView.transform = transform;
		self.navigationController.navigationBarHidden = YES;
		[_imageView setFrame:CGRectMake(0, 0, 320, 460)];		
	}
	else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		CGAffineTransform transform = CGAffineTransformMakeRotation(90 * 3.14/180);	
		_imageView.transform = transform;
		self.navigationController.navigationBarHidden = YES;
		[_imageView setFrame:CGRectMake(0, 0, 320, 460)];
	}	
	else {
		CGAffineTransform transform = CGAffineTransformMakeRotation(0);	
		_imageView.transform = transform;
		self.navigationController.navigationBarHidden = NO;		
		[_imageView setFrame:CGRectMake(0, 0, 320, 400)];		
	}
	[_scrollView setContentSize:CGSizeMake(_imageView.frame.size.width, _imageView.frame.size.height)];	
	[UIView commitAnimations];
	return NO;
}
- (void)dealloc
{
    [super dealloc];
}
- (void)loadImageOfStockID:(NSString *)stockID
{
	NSString *urlString = [NSString stringWithFormat:IMGURL, stockID];
	NSURL *url = [NSURL URLWithString:urlString];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *image = [UIImage imageWithData:data];
	[_imageView setImage:image];
	[_scrollView setContentSize:CGSizeMake(_imageView.frame.size.width, _imageView.frame.size.height)];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView 
{	
	NSLog(@"viewForZoomingInScrollView");
	return _imageView;
}

@end
