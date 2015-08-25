//
//  ZBStockParser.m
//  TAIEX
//
//  Created by zonble on 2008/12/24.
//  Copyright 2008 zonble.twbbs.org. All rights reserved.
//

#import "ZBStockParser.h"


@implementation ZBStockParser

- (id)initWithStockID:(NSString *)stockID delegate:(id)delegate index:(NSInteger)index
{
	self = [super init];
	if (self != nil) {
		_delegate = delegate;
		_index = index;
		NSString *urlString = [NSString stringWithFormat:APIURL, stockID];
		NSURL *url = [NSURL URLWithString:urlString];
		NSData *data = [NSData dataWithContentsOfURL:url];
		if (data)  {
			_parser = [[NSXMLParser alloc] initWithData:data];
			[_parser setDelegate:self];
			[_parser parse];			
		}
		else {	
			[self release];
			return nil;
		}
//		_parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	}
	return self;
}
- (void)dealloc
{
	[_parser release];
	[super dealloc];
}
- (NSInteger)index
{
	return _index;
}

- (void)parser:(NSXMLParser*)parser
didStartElement:(NSString*)elementName
  namespaceURI:(NSString*)namespaceURI
 qualifiedName:(NSString*)qualifiedName
    attributes:(NSDictionary*)attributeDict
{
	if ([elementName isEqualToString:@"item"]) {
		if (_delegate && [_delegate respondsToSelector:@selector(stockParser:didFetchResult:atIndex:)])
			[_delegate stockParser:self didFetchResult:attributeDict atIndex:_index];
	}
}
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	if (_delegate && [_delegate respondsToSelector:@selector(stockParserDidEndDocument:)])
		[_delegate stockParserDidEndDocument:self];	
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	if (_delegate && [_delegate respondsToSelector:@selector(stockParserDidEndDocument:)])
		[_delegate stockParserDidEndDocument:self];		
}


@end
