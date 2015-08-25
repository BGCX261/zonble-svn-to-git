//
//  ZBStockTableViewCell.h
//  TAIEX
//
//  Created by zonble on 2008/12/24.
//  Copyright 2008 zonble.twbbs.org. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZBStockTableViewCell : UITableViewCell
{
	UILabel *nameLabel;
	UILabel *stockIDLabel;
	UILabel *priceLabel;
	UILabel *updownLobel;	
}

- (void)setUp:(BOOL)flag;

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *stockIDLabel;
@property (nonatomic, retain) UILabel *priceLabel;
@property (nonatomic, retain) UILabel *updownLobel;

@end
