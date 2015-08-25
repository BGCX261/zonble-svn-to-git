//
//  ZBChartViewController.h
//  TAIEX
//
//  Created by zonble on 2008/12/24.
//  Copyright 2008 zonble.twbbs.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IMGURL    @"http://tw.chart.finance.yahoo.com/b?s=%@"

@interface ZBChartViewController : UIViewController <UIScrollViewDelegate>{
	IBOutlet UIScrollView *_scrollView;
	IBOutlet UIImageView *_imageView;
	NSString *_stockID;
}
+ (id)sharedController;
- (void)loadImageOfStockID:(NSString *)stockID;

@end
