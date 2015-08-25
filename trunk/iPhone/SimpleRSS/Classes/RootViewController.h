//
//  RootViewController.h
//  Unews
//
//  Created by zonble on 2008/6/16.
//  Copyright zonble.twbbs.org 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleRSS.h"

@interface RootViewController : UITableViewController {
	SimpleRSS *_rss;
}
- (void)parseURL:(NSURL *)URL;
- (void)reloadTable;

@end
