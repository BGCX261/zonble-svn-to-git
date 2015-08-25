//
//  RootViewController.h
//  TAIEX
//
//  Created by zonble on 2008/12/24.
//  Copyright zonble.twbbs.org 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#define updateTime @"updateTime"

@interface RootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
	UITableView *tableView;
	IBOutlet UIToolbar *_toolbar;
	IBOutlet UIBarButtonItem *_addItem;
	IBOutlet UIBarButtonItem *_editItem;
	IBOutlet UIBarButtonItem *_updateItem;
	IBOutlet UILabel *_updateLabel;
}

//- (void)fetchData;

#pragma mark Interface Builder actions

- (IBAction)fetchDataAction:(id)sender;
- (IBAction)addStockAction:(id)sender;
- (IBAction)editAction:(id)sender;

#pragma mark properties;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
