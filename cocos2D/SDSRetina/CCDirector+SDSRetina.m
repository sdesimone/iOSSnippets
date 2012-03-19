//
//  CCDirector+SDSRetina.m
//
//  Created by sergio on 3/19/12.
//  Copyright 2012 Freescapes Labs. All rights reserved.
//

#import "cocos2d.h"


@implementation CCDirectorIOS (SDSRetina)

CGFloat __ccPointScaleFactor = 1;

// new method call after creating the director in your AppDelegate
- (void)makeUniversal
{
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		__ccPointScaleFactor = 2;
	}
}

-(void) setContentScaleFactor:(CGFloat)scaleFactor
{
	if( scaleFactor != __ccContentScaleFactor )
	{
		__ccContentScaleFactor = scaleFactor;
        
		CGSize glSize = [openGLView_ bounds].size;
		winSizeInPoints_ = CGSizeMake( glSize.width / __ccPointScaleFactor, glSize.height / __ccPointScaleFactor );
		winSizeInPixels_ = CGSizeMake( winSizeInPoints_.width * scaleFactor, winSizeInPoints_.height * scaleFactor );
        
		if( openGLView_ )
			[self updateContentScaleFactor];
        
		// update projection
		[self setProjection:projection_];
	}
}


//#ifdef CC_RETINA_IPAD_DISPLAY_FILENAME_SUFFIX

-(void) updateContentScaleFactor
{
	// Based on code snippet from: http://developer.apple.com/iphone/prerelease/library/snippets/sp2010/sp28.html
	if ([openGLView_ respondsToSelector:@selector(setContentScaleFactor:)])
	{
		CGFloat scaleFactor = (__ccPointScaleFactor == 1) ? __ccContentScaleFactor : (__ccContentScaleFactor / __ccPointScaleFactor);
		[openGLView_ setContentScaleFactor: scaleFactor];
        
		isContentScaleSupported_ = YES;
	}
	else
	{
		CCLOG(@"cocos2d: WARNING: calling setContentScaleFactor on iOS < 4. Using fallback mechanism");
		isContentScaleSupported_ = NO;
	}
}

#ifdef CC_RETINA_IPAD_DISPLAY_FILENAME_SUFFIX

-(BOOL) enableRetinaDisplay:(BOOL)enabled
{
	return [self enableRetinaDisplay:enabled onPad:FALSE];
}

-(BOOL) enableRetinaDisplay:(BOOL)enabled onPad:(BOOL)onPad
{
	// Already enabled ?
	if( enabled && __ccContentScaleFactor == 2 )
		return YES;
    
	// Already disabled
	if( ! enabled && __ccContentScaleFactor == 1 )
		return YES;
    
	// setContentScaleFactor is not supported
	if (! [openGLView_ respondsToSelector:@selector(setContentScaleFactor:)])
		return NO;
    
	// SD device
    CGFloat scale = [[UIScreen mainScreen] scale];
	if (scale == 1.0 && __ccPointScaleFactor == 1.0)
		return NO;
    
    float newScale = 1;
    if (onPad) {
        newScale = enabled ? (scale * __ccPointScaleFactor) : 1;
    } else {
        newScale = enabled ? 2 : 1;
    }
	[self setContentScaleFactor:newScale];
    
	// Load Hi-Res FPS label
	//[self createFPSLabel];
    
	return YES;
}

#else

-(BOOL) enableRetinaDisplay:(BOOL)enabled
{
	// Already enabled ?
	if( enabled && __ccContentScaleFactor == 2 )
		return YES;
    
	// Already disabled
	if( ! enabled && __ccContentScaleFactor == 1 )
		return YES;
    
	// setContentScaleFactor is not supported
	if (! [openGLView_ respondsToSelector:@selector(setContentScaleFactor:)])
		return NO;
    
	// SD device
	if ([[UIScreen mainScreen] scale] == 1.0 && __ccPointScaleFactor == 1.0)
		return NO;
    
	float newScale = enabled ? 2 : 1;
	[self setContentScaleFactor:newScale];
    
	// Load Hi-Res FPS label
    //	[self createFPSLabel];
    
	return YES;
}
#endif


-(void) reshapeProjection:(CGSize)size
{
	CGSize glSize = [openGLView_ bounds].size;
	winSizeInPoints_ = CGSizeMake(glSize.width/__ccPointScaleFactor, glSize.height/__ccPointScaleFactor);
	winSizeInPixels_ = CGSizeMake(winSizeInPoints_.width * __ccContentScaleFactor, winSizeInPoints_.height *__ccContentScaleFactor);
    
	[self setProjection:projection_];
}

-(CGPoint)convertToGL:(CGPoint)uiPoint
{
	CGSize s = winSizeInPoints_;
	float newY = s.height - (uiPoint.y / __ccPointScaleFactor);
	float newX = uiPoint.x / __ccPointScaleFactor;
    
	return ccp( newX, newY );
}

-(CGPoint)convertToUI:(CGPoint)glPoint
{
	CGSize winSize = winSizeInPoints_;
	int newX = glPoint.x * __ccPointScaleFactor;
	int newY = (winSize.height - glPoint.y) * __ccPointScaleFactor;
    
	return ccp(newX, newY);
}

@end


