//
//  ZBStockParser.h
//  TAIEX
//
//  Created by zonble on 2008/12/24.
//  Copyright 2008 zonble.twbbs.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#define APIURL    @"http://tw.stock.yahoo.com/w/stock?p=%@"

@interface ZBStockParser : NSObject {
	NSXMLParser *_parser;
	id _delegate;
	NSInteger _index;
}
- (id)initWithStockID:(NSString *)stockID delegate:(id)delegate index:(NSInteger)index;
- (NSInteger)index;
@end

@interface NSObject(ZBStockParser)
- (void)stockParser:(ZBStockParser *)parser didFetchResult:(NSDictionary *)result atIndex:(NSInteger)index;
- (void)stockParserDidEndDocument:(ZBStockParser *)parser;
@end

