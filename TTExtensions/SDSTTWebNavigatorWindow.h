#import <UIKit/UIKit.h>
#import <Three20UI/private/TTNavigatorWindow.h>

///////////////////////////////////////////////////////////////////////////////////////////////////
#define NOTIFICATION_SWIPE_LEFT @"SwipeLeft"
#define NOTIFICATION_SWIPE_RIGHT @"SwipeRight"
#define NOTIFICATION_ZOOM_IN @"ZoomIn"
#define NOTIFICATION_ZOOM_OUT @"ZoomOut"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface SDSTTWebNavigatorWindow : TTNavigatorWindow {
	NSTimeInterval startTouchTime;
	CGPoint previousTouchPosition1, previousTouchPosition2;
	CGPoint startTouchPosition1, startTouchPosition2;
	NSMutableArray* _controlledViews;
	UIView* _initialView;
}

@property (nonatomic, retain) NSMutableArray* controlledViews;

- (void)sendEvent:(UIEvent*)event;

@end
