//
//  CKImageItem.h
//  Kuler
//
//  Created by zonble on 2007/11/8.
//  Copyright 2007 Lithoglyph. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface CKImageItem : NSObject 
{
	NSImage *_image;
	NSString *_imageID;
	NSString *_imageLink;	
	NSString *_imageTitle;
	NSString *_imageSubTitle;
	NSString *_imagePath;	
}
- (id)initWithImage:(NSImage*)image imageID:(NSString*)imageID imageTitle: (NSString*)imageTitle;
- (void) setImageTitle: (NSString*)imageTitle;
- (void) setImageSubTitle: (NSString*)imageSubTitle;
- (void) setImageLink: (NSString*)imageLink;
- (void) setImagePath: (NSString*)imagePath;
- (NSString *) imageUID;
- (NSString *) imageLink;
- (NSString *) imagePath;
- (NSString *) imageRepresentationType;
- (id) imageRepresentation;
@end
