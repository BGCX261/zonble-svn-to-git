// CKKulerXMLExtension.m
// 
// Copyright (c) 2004-2006 Lukhnos D. Liu (lukhnos {at} gmail.com)
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
// 3. Neither the name of ObjectiveFlickr nor the names of its contributors
//    may be used to endorse or promote products derived from this software
//    without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "CKKulerXMLExtension.h"

@implementation NSXMLDocument(CKKulerXMLExtension)
+ (NSString*)kulerXMLAttribute:(NSString*)attr
{
	return [NSString stringWithFormat:@"%@%@", [NSXMLDocument kulerXMLAttributePrefix], attr];
}
+ (NSString*)kulerXMLAttributePrefix
{
	return @"_";
}
+ (NSString*)kulerXMLTextNodeKey
{
	return @"$";
}
- (BOOL)hasFlickrError:(int*)errorCode message:(NSString**)errorMsg
{
	if (errorCode) *errorCode = 0;
	if (errorMsg) *errorMsg = @"";
	
	NSXMLNode *stat =[[self rootElement] attributeForName:@"stat"];
	if ([[stat stringValue] isEqualToString:@"ok"]) return NO;
	
	NSXMLNode *e = [[self rootElement] childAtIndex:0];
	NSXMLNode *codestr = [(NSXMLElement*)e attributeForName:@"code"];
	NSXMLNode *msg = [(NSXMLElement*)e attributeForName:@"msg"];
	
	if (errorCode) *errorCode = [[codestr stringValue] intValue];
	if (errorMsg) *errorMsg = [NSString stringWithString:[msg stringValue]];
	return YES;
}
- (NSDictionary*)kulerDictionaryFromDocumentWithArrayedNodes:(NSDictionary*)arrayedNodesDictionary
{
	NSMutableDictionary *d=(NSMutableDictionary*)[[self rootElement] kulerDictionaryFromNodeWithArrayedNodes:arrayedNodesDictionary];
	
	NSXMLNode *stat =[[self rootElement] attributeForName:@"stat"];
	if ([[stat stringValue] isEqualToString:@"ok"])  {
		[d removeObjectForKey:[NSXMLDocument kulerXMLAttribute:@"stat"]];
	}
	return d;
}
- (NSDictionary*)kulerDictionaryFromDocument
{
	return [self kulerDictionaryFromDocumentWithArrayedNodes:nil];
}
@end

@implementation NSXMLNode(CKKulerXMLExtension)
- (NSDictionary*)kulerDictionaryFromNodeWithArrayedNodes:(NSDictionary*)arrayedNodesDictionary
{
	// NSLog(@"node name=%@, value=%@", [self name], [self stringValue]);

	BOOL useArray = NO;
	if ([arrayedNodesDictionary objectForKey:[self name]]) useArray = YES;

	NSMutableDictionary *d = [NSMutableDictionary dictionary];
	
	unsigned i, c = [self childCount];
	for (i = 0; i<c; i++) {
		NSXMLNode *n = [self childAtIndex:i];
		// NSLog(@"child node %@=%@", [n name], [[n kulerDictionaryFromNode] description]);
		
		NSString *name=[n name];
		if (name) {
			id obj = [d objectForKey:name];
			
			if (!obj) {
				if (useArray) {
					NSMutableArray *a = [NSMutableArray array];
					[a addObject:[n kulerDictionaryFromNodeWithArrayedNodes:arrayedNodesDictionary]];
					[d setObject:a forKey:name];
				}					
				else {
					[d setObject:[n kulerDictionaryFromNodeWithArrayedNodes:arrayedNodesDictionary] forKey:name];
				}
			}
			else {
				// it's already an array
				if (![obj isKindOfClass:[NSMutableArray class]]) {
					NSMutableArray *a = [NSMutableArray arrayWithObject:obj];
					[d setObject:a forKey:name];
					obj = a;
				}
				[obj addObject:[n kulerDictionaryFromNodeWithArrayedNodes:arrayedNodesDictionary]];
			}
		}
		else {
			[d setObject:[n stringValue] forKey:[NSXMLDocument kulerXMLTextNodeKey]];	// text node
		}
	}
	return d;
}
- (NSDictionary*)kulerDictionaryFromNode
{
	return [self kulerDictionaryFromNodeWithArrayedNodes:nil];
}	
@end

@implementation NSXMLElement(CKKulerXMLExtension)
- (NSDictionary*)kulerDictionaryFromNodeWithArrayedNodes:(NSDictionary*)arrayedNodesDictionary
{
	// NSLog(@"element name=%@, value=%@", [self name], [self stringValue]);
	NSMutableDictionary *d = (NSMutableDictionary*)[super kulerDictionaryFromNodeWithArrayedNodes:arrayedNodesDictionary];

	NSArray *a = [self attributes];
	unsigned i, c = [a count];

	for (i = 0; i < c; i++) {
		NSXMLNode *n = [a objectAtIndex:i];
		// NSLog(@"element attr @%@=%@", [n name], [n stringValue]);
		[d setObject:[n stringValue] forKey:[NSXMLDocument kulerXMLAttribute:[n name]]];
	}
	return d;
}
- (NSDictionary*)kulerDictionaryFromNode
{
	return [self kulerDictionaryFromNodeWithArrayedNodes:nil];
}	
@end
