//
//  ZBTableViewCell.m
//  Unews
//
//  Created by zonble on 2008/6/16.
//  Copyright 2008 zonble.twbbs.org. All rights reserved.
//

#import "ZBTableViewCell.h"


@implementation ZBTableViewCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)setTitle: (NSString *)title description:(NSString *)description image:(UIImage *)image
{
	for (id view in [self subviews]) {
		[view removeFromSuperview];
	}
	
	NSArray *parts = [description componentsSeparatedByString:@"\n"];
	NSString *descriptionText = @"";
	int i = 0;
	for (NSString *part in parts) {
		if (i < 3) {
			descriptionText = [descriptionText stringByAppendingString:part];
		}
		i++;
	}
	if ([descriptionText length] > 60) {
		descriptionText = [[description substringToIndex:60] stringByAppendingString:@"..."];
	}
	
	CGSize titleSize =  [title sizeWithFont:[UIFont boldSystemFontOfSize:18.0] constrainedToSize:CGSizeMake(220.0, 500) lineBreakMode:UILineBreakModeCharacterWrap];
	CGSize descriptionSize =  [descriptionText sizeWithFont:[UIFont boldSystemFontOfSize:12.0] constrainedToSize:CGSizeMake(220.0, 500) lineBreakMode:UILineBreakModeCharacterWrap];
	
	UILabel *titleField;
	CGRect titleRect;
	if (image) {
		titleRect = CGRectMake(130, 10, 160, titleSize.height);
	}
	else {
		titleRect = CGRectMake(20, 10, 260, titleSize.height);		
	}
	
	titleField = [[UILabel alloc] initWithFrame:titleRect];
	[titleField setText:title];
	[titleField setBackgroundColor:[UIColor clearColor]];
	[titleField setLineBreakMode:UILineBreakModeWordWrap];
	[titleField setFont:[UIFont boldSystemFontOfSize:18.0]];
	[titleField setHighlightedTextColor:[UIColor whiteColor]];
	[titleField setNumberOfLines:0];
	[self addSubview:titleField];
	[titleField release];
	
	UILabel *descriptionField;
	CGRect descriptionRect;
	if (image) {
		descriptionRect = CGRectMake(130, 16 + titleSize.height, 160, descriptionSize.height);
	}
	else {
		descriptionRect = CGRectMake(20, 16 + titleSize.height, 260, descriptionSize.height);		
	}
	
	descriptionField = [[UILabel alloc] initWithFrame:descriptionRect];

	[descriptionField setText:descriptionText];
	[descriptionField setBackgroundColor:[UIColor clearColor]];	
	[descriptionField setLineBreakMode:UILineBreakModeWordWrap];		
	[descriptionField setFont:[UIFont boldSystemFontOfSize:12.0]];
	[descriptionField setHighlightedTextColor:[UIColor whiteColor]];		
	[descriptionField setNumberOfLines:0];		
	[self addSubview:descriptionField];		
	[descriptionField release];
	
	if (!image)
		return;
	
	CGFloat w = [image size].width;
	CGFloat h = [image size].height;
	CGFloat x = 0, y = 0;
	if (w > h) {
		x = (w - h) / 2;		
		w = h;
	}
	else if (h > w) {
		y = (h - w) /2;
		h = w;
	}
	
	CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(x, y, w, h));
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithCGImage:imageRef]];
	[imageView setFrame:CGRectMake(0, 0, 120, 120)];
	[imageView setUserInteractionEnabled:YES];
	
	[self addSubview:imageView];
	[imageView release];
}

- (void)setDictionary:(NSDictionary *)dictionary
{
	NSString *title = [dictionary valueForKey:@"title"];
	NSString *description = [dictionary valueForKey:@"description"];
	UIImage *image = [dictionary valueForKey:@"image"];
	[self setTitle:title description:description image:image];
}

- (void) dealloc
{
	[super dealloc];
}


@end
 