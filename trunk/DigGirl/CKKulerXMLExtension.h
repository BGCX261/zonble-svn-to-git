@interface NSXMLNode(CKKulerXMLExtension)
- (NSDictionary*)kulerDictionaryFromNodeWithArrayedNodes:(NSDictionary*)arrayedNodesDictionary;
- (NSDictionary*)kulerDictionaryFromNode;
@end

@interface NSXMLElement(CKKulerXMLExtension)
- (NSDictionary*)kulerDictionaryFromNodeWithArrayedNodes:(NSDictionary*)arrayedNodesDictionary;
- (NSDictionary*)kulerDictionaryFromNode;
@end

@interface NSXMLDocument(OFFlickrXMLExtension)

- (BOOL)hasFlickrError:(int*)errcode message:(NSString**)errorMsg;

- (NSDictionary*)kulerDictionaryFromDocument;
- (NSDictionary*)kulerDictionaryFromDocumentWithArrayedNodes:(NSDictionary*)arrayedNodesDictionary;
+ (NSString*)kulerXMLAttribute:(NSString*)attr;
+ (NSString*)kulerXMLAttributePrefix;
+ (NSString*)kulerXMLTextNodeKey;
@end
