//
//  SDSHTMLTextTableItemCell.m
//  maniphone
//
//  Created by sergio on 12/9/10.
//  Copyright 2011 Sergio De Simone, Freescapes Labs.
//

#import "SDSWebTableItemCell.h"

/*
// UI
#import "Three20UI/TTStyledTextLabel.h"
#import "Three20UI/SDSTableHTMLTextItem.h"
#import "Three20UI/UITableViewAdditions.h"
#import "Three20UI/UIViewAdditions.h"

// Style
#import "Three20Style/TTGlobalStyle.h"
#import "Three20Style/TTDefaultStyleSheet.h"
#import "Three20Style/TTStyledText.h"
*/

#import "Three20UI/TTNavigator.h"

// Core
#import "Three20Core/TTCorePreprocessorMacros.h"


/******************************************************************************************
 **********
 **********
 **********   SDSTableHTMLTextItem
 **********
 ******************************************************************************************/


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SDSTableHTMLTextItem

@synthesize text = _text;
@synthesize cell = _cell;
@synthesize margin = _margin;
@synthesize padding = _padding;
@synthesize height = _height;
@synthesize last = _last;
@synthesize indexPath = _indexPath;
@synthesize tableView = _tableView;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
	if (self = [super init]) {
		_margin = UIEdgeInsetsZero;
		_padding = UIEdgeInsetsMake(6, 6, 6, 6);
		_height = 110;
		_tableView = nil;
		_indexPath = nil;
		_last = NO;
	}
	
	return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
SDSLOG_DEALLOC
//	NSLog(@"TEXTTABLEITEM DEALLOCATED");
	TT_RELEASE_SAFELY(_text);
	TT_RELEASE_SAFELY(_cell);
	TT_RELEASE_SAFELY(_indexPath);
	[super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithText:(NSString*)text {
	SDSTableHTMLTextItem* item = [[[self alloc] init] autorelease];
	item.text = text;
	return item;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithText:(NSString*)text URL:(NSString*)URL {
	SDSTableHTMLTextItem* item = [[[self alloc] init] autorelease];
	item.text = text;
	item.URL = URL;
	return item;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithText:(NSString*)text URL:(NSString*)URL accessoryURL:(NSString*)accessoryURL {
	SDSTableHTMLTextItem* item = [[[self alloc] init] autorelease];
	item.text = text;
	item.URL = URL;
	item.accessoryURL = accessoryURL;
	return item;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSCoding


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder*)decoder {
	if (self = [super initWithCoder:decoder]) {
		self.text = [decoder decodeObjectForKey:@"text"];
	}
	return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder*)encoder {
	[super encodeWithCoder:encoder];
	if (self.text) {
		[encoder encodeObject:self.text forKey:@"text"];
	}
}

#pragma mark -
@end


/******************************************************************************************
 **********
 **********
 **********   SDSHTMLTextTableItemCell
 **********
 ******************************************************************************************/


static const CGFloat kDisclosureIndicatorWidth = 23;

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SDSHTMLTextTableItemCell

@synthesize label = _label;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
		_label = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 280, 100)];
		_label.delegate = self;
		_label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:_label];
	}
	
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
SDSLOG_DEALLOC
	_label.delegate = nil;
	//-- SDS: avoid cyclic release
//	if ([_item isKindOfClass:[SDSTableHTMLTextItem class]])
//		_item = nil;
	[_label removeFromSuperview];
	TT_RELEASE_SAFELY(_label);
	[super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell class public

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
	SDSTableHTMLTextItem* item = object;
//	NSLog(@"CELL HEIGHT (%x): %d", item, item.height);
	return item.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
	[super layoutSubviews];
	
	SDSTableHTMLTextItem* item = self.object;
	_label.frame = UIEdgeInsetsInsetRect(self.contentView.frame, item.margin);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didMoveToSuperview {
	[super didMoveToSuperview];
	if (self.superview) {
		_label.backgroundColor = self.backgroundColor;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
	if (_item != object) {
		[super setObject:object];
		
		SDSTableHTMLTextItem* item = object;
		if (![item URL])
			self.accessoryView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,20,0)] autorelease];
		[_label loadHTMLString:item.text baseURL:[NSURL URLWithString:@""]];	

		[self setNeedsLayout];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView*)webView {
	
//	NSLog(@"TableItemCell: setting bounces to NO (%d)", [_label.subviews count]);
	for (id subview in _label.subviews)
		if ([[subview class] isSubclassOfClass: [UIScrollView class]])
			((UIScrollView *)subview).bounces = NO;

	//--SDS TODO : inject this javascript into the head
//	document.ontouchmove = function(event) {
//        if (document.body.scrollHeight == document.body.clientHeight) event.preventDefault();
//	}
	
	
//	NSLog(@"TableItemCell: setting item height (%x)", _item);
	SDSTableHTMLTextItem* ti = (id)_item;
	NSString* h = [_label stringByEvaluatingJavaScriptFromString:@"document.height"];
	ti.height = [h intValue] + 12;
	
//	NSLog(@"TableItemCell: updating table");
	if (ti.last) {
		[ti.tableView beginUpdates];
		[ti.tableView endUpdates];
	}
//	NSLog(@"TableItemCell: exit");
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	TTOpenURL([[[request URL] absoluteString] stringByReplacingOccurrencesOfString:@"http://" withString:@"tt://"]);
	return NO;
}

#pragma mark -

@end
