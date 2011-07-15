//
//  SDSASITTURLRequestModelAdapter.h
//  dixiphone
//
//  Created by sergio on 3/30/11.
//  Copyright 2011 Freescapes Labs - Sergio De Simone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20Network/TTModel.h"
#import "Three20Network/TTURLRequestDelegate.h"
#import "ASI-HTTP/ASIHTTPRequest.h"
#import "ASI-HTTP/ASIHTTPRequestDelegate.h"

@interface SDSASITTURLRequestModelAdapter : TTModel <ASIHTTPRequestDelegate> {

	ASIHTTPRequest* _req;	
	NSDate*       _loadedTime;
	NSString*     _cacheKey;
	
	BOOL          _isLoadingMore;
	BOOL          _hasNoMore;
}

@property(nonatomic,readonly,retain) ASIHTTPRequest* req;

/**
 * Valid upon completion of the URL request. Represents the timestamp of the completed request.
 */
@property (nonatomic, retain) NSDate*   loadedTime;

/**
 * Valid upon completion of the URL request. Represents the request's cache key.
 */
@property (nonatomic, copy)   NSString* cacheKey;

/**
 * Not used internally, but intended for book-keeping purposes when making requests.
 */
@property (nonatomic) BOOL hasNoMore;

/**
 * Resets the model to its original state before any data was loaded.
 */
- (void)reset;

@end
