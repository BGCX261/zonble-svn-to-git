//
//  CVImageItem.m
//  Kuler
//
//  Created by zonble on 2007/11/8.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "CKImageItem.h"

@implementation CKImageItem
- (id)initWithImage:(NSImage*)image imageID:(NSString*)imageID imageTitle:(NSString*)imageTitle
{
	if (self = [super init]) {
		_image = [image copy];
		_imageID = [imageID copy];
		_imageTitle = [imageTitle copy];
		_imageSubTitle = @"";
		_imageLink = @"";
		_imagePath = @"";		
	}
	return self;
}

- (void) setImageTitle: (NSString*)imageTitle
{
	_imageTitle = imageTitle;
}
- (void) setImageSubTitle: (NSString*)imageSubTitle
{
	_imageSubTitle = imageSubTitle;
}

- (void) setImageLink: (NSString*)imageLink
{
	_imageLink = imageLink;
}

- (void) setImagePath: (NSString*)imagePath
{
	_imagePath = imagePath;
}

- (NSString *) imageUID
{
	return _imageID;
}
- (NSString *) imageRepresentationType
{
	return IKImageBrowserNSImageRepresentationType;
}
- (id) imageRepresentation
{
	return _image;
}
- (NSString*) imageTitle
{
	return _imageTitle;
}
- (NSString*) imageSubtitle
{
	return _imageSubTitle;
}
- (NSString *) imageLink
{
	return _imageLink;
}
- (NSString*) imagePath
{
	return _imagePath;
}

@end
