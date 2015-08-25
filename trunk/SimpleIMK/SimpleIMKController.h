//
//  SimpleIMKController.h
//  SimpleIMK
//
//  Created by zonble on 2008/3/21.
//  Copyright 2008 Lithoglyph Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <InputMethodKit/InputMethodKit.h>

@protocol SendString
- (oneway void) sendString: (NSString *)string;
@end


@interface SimpleIMKController : IMKInputController <SendString> {
}
+ (void) doSendString: (NSString *)string;
@end
