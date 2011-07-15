//
//  TTStyledTextParser (SDSCategory)
//  maniphone
//
//  Created by sergio on 11/25/10.
//  Copyright 2011 Sergio De Simone, Freescapes Labs.
//

#import "TTStyledTextParser+SDSCategory.h"

@implementation TTStyledTextParser (SDSCategory)

#pragma mark -
#pragma mark NSXMLParserDelegate


- (void)privatePushNode:(TTStyledElement*)element {
	[self pushNode:element];
}

- (void)privateFlushCharacters {
	[self flushCharacters];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//-- Overrides base implementation provided in TTStyledTextParser
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
	[self privateFlushCharacters];
	
	NSString* tag = [elementName lowercaseString];
	if ([tag isEqualToString:@"span"]) {
		TTStyledInline* node = [[[TTStyledInline alloc] init] autorelease];
		node.className =  [attributeDict objectForKey:@"class"];
		if (node.className == nil)
			node.className = [attributeDict objectForKey:@"CLASS"];
		[self privatePushNode:node];
		
	} else if ([tag isEqualToString:@"br"]) {
		TTStyledLineBreakNode* node = [[[TTStyledLineBreakNode alloc] init] autorelease];
		node.className =  [attributeDict objectForKey:@"class"];
		[self privatePushNode:node];
		
	} else if ([tag isEqualToString:@"div"] || [tag isEqualToString:@"p"]) {
		TTStyledBlock* node = [[[TTStyledBlock alloc] init] autorelease];
		node.className =  [attributeDict objectForKey:@"class"];
		[self privatePushNode:node];
		
	} else if ([tag isEqualToString:@"b"]) {
		TTStyledBoldNode* node = [[[TTStyledBoldNode alloc] init] autorelease];
		[self privatePushNode:node];
		
	} else if ([tag isEqualToString:@"i"]) {
		TTStyledItalicNode* node = [[[TTStyledItalicNode alloc] init] autorelease];
		[self privatePushNode:node];
		
	} else if ([tag isEqualToString:@"a"]) {
		TTStyledLinkNode* node = [[[TTStyledLinkNode alloc] init] autorelease];
		node.URL =  [attributeDict objectForKey:@"href"];
		[self privatePushNode:node];
		
	} else if ([tag isEqualToString:@"button"]) {
		TTStyledButtonNode* node = [[[TTStyledButtonNode alloc] init] autorelease];
		node.URL =  [attributeDict objectForKey:@"href"];
		[self privatePushNode:node];
		
	} else if ([tag isEqualToString:@"img"]) {
		TTStyledImageNode* node = [[[TTStyledImageNode alloc] init] autorelease];
		node.className =  [attributeDict objectForKey:@"class"];
		node.URL =  [attributeDict objectForKey:@"src"];
		NSString* width = [attributeDict objectForKey:@"width"];
		if (width) {
			node.width = width.floatValue;
		}
		NSString* height = [attributeDict objectForKey:@"height"];
		if (height) {
			node.height = height.floatValue;
		}
		[self privatePushNode:node];
	}
}


@end
