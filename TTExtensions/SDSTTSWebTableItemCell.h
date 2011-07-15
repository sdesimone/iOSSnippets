//
//  SDSWebTableItemCell.h
//  maniphone
//
//  Created by sergio on 12/9/10.
//  Copyright 2011 Sergio De Simone, Freescapes Labs.
//

#import <Foundation/Foundation.h>

#import "Three20UI/TTTableLinkedItemCell.h"
#import "Three20UI/TTTableLinkedItem.h"

@class SDSHTMLTextTableItemCell;

@interface SDSTableHTMLTextItem : TTTableLinkedItem {
	SDSHTMLTextTableItemCell* _cell;
	NSString* _text;
	NSUInteger _height;
	UIEdgeInsets  _margin;
	UIEdgeInsets  _padding;
	UITableView* _tableView;
	NSIndexPath* _indexPath;
	BOOL _last;
}

@property (nonatomic) BOOL last;
@property (nonatomic) NSUInteger height;
@property (nonatomic) UIEdgeInsets margin;
@property (nonatomic) UIEdgeInsets padding;
@property (nonatomic, retain) NSString* text;
@property (nonatomic, assign) UITableView* tableView;
@property (nonatomic, retain) NSIndexPath* indexPath;
@property (nonatomic, retain) SDSHTMLTextTableItemCell* cell;

+ (id)itemWithText:(NSString*)text;
+ (id)itemWithText:(NSString*)text URL:(NSString*)URL;
+ (id)itemWithText:(NSString*)text URL:(NSString*)URL accessoryURL:(NSString*)accessoryURL;

@end

@class TTTableHTMLTextItem;

@interface SDSHTMLTextTableItemCell : TTTableLinkedItemCell <UIWebViewDelegate> {
	UIWebView* _label;
}

@property (nonatomic, readonly) UIWebView* label;

@end
