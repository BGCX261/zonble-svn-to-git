//
//  ZBStockTableViewCell.m
//  TAIEX
//
//  Created by zonble on 2008/12/24.
//  Copyright 2008  zonble.twbbs.org. All rights reserved.
//

#import "ZBStockTableViewCell.h"


@implementation ZBStockTableViewCell

@synthesize nameLabel;
@synthesize stockIDLabel;
@synthesize priceLabel;
@synthesize updownLobel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 8, 80, 30)];
		nameLabel.font = [UIFont boldSystemFontOfSize:18.0];
		nameLabel.backgroundColor = [UIColor clearColor];
		stockIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 8, 50, 30)];
		stockIDLabel.font = [UIFont systemFontOfSize:14.0];
		stockIDLabel.backgroundColor = [UIColor clearColor];
		priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 8, 50, 30)];
		priceLabel.font = [UIFont boldSystemFontOfSize:18.0];
		priceLabel.backgroundColor = [UIColor clearColor];
		updownLobel = [[UILabel alloc] initWithFrame:CGRectMake(250, 8, 50, 30)];
		updownLobel.font = [UIFont boldSystemFontOfSize:18.0];
		updownLobel.backgroundColor = [UIColor clearColor];
		[self addSubview:nameLabel];
		[self addSubview:stockIDLabel];
		[self addSubview:priceLabel];
		[self addSubview:updownLobel];
//		self.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}
- (void)setUp:(BOOL)flag
{
	if (flag)
		updownLobel.textColor = [UIColor redColor];
	else
		updownLobel.textColor = [UIColor greenColor];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	if (selected) {
		nameLabel.textColor = [UIColor whiteColor];
		stockIDLabel.textColor = [UIColor whiteColor];
		priceLabel.textColor = [UIColor whiteColor];
	}
	else {
		nameLabel.textColor = [UIColor blackColor];
		stockIDLabel.textColor = [UIColor blackColor];
		priceLabel.textColor = [UIColor blackColor];		
	}
    [super setSelected:selected animated:animated];
}

- (void)dealloc
{
	[nameLabel release];
	[stockIDLabel release];
	[priceLabel release];
	[updownLobel release];
    [super dealloc];
}


@end
