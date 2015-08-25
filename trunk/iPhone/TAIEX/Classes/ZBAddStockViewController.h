//
//  ZBAddStockViewController.h
//  TAIEX
//
//  Created by zonble on 2008/12/24.
//  Copyright 2008 zonble.twbbs.org. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZBAddStockViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
	IBOutlet UISearchBar *searchBar;
	IBOutlet UITableView *tableView;
	NSMutableArray *_stockArray;
	NSMutableArray *_listedArray;
}

+ (id)sharedController;

- (IBAction)closeAction:(id)sender;

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
