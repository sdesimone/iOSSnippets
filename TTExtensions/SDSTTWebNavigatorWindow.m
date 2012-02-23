#import "SDSTTWebNavigatorWindow.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#define SWIPE_DRAG_HORIZ_MIN 30
#define SWIPE_DRAG_VERT_MAX 40
#define ZOOM_DRAG_MIN 20


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SDSTTWebNavigatorWindow

@synthesize controlledViews = _controlledViews;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.controlledViews = [NSMutableArray arrayWithCapacity:3];
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
	[_controlledViews release];
	[super dealloc];
}

#pragma mark -
#pragma mark Helper functions for generic math operations on CGPoints

///////////////////////////////////////////////////////////////////////////////////////////////////
CGFloat CGPointDot(CGPoint a,CGPoint b) {
	return a.x*b.x+a.y*b.y;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
CGFloat CGPointLen(CGPoint a) {
	return sqrtf(a.x*a.x+a.y*a.y);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
CGPoint CGPointSub(CGPoint a,CGPoint b) {
	CGPoint c = {a.x-b.x,a.y-b.y};
	return c;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
CGFloat CGPointDist(CGPoint a,CGPoint b) {
	CGPoint c = CGPointSub(a,b);
	return CGPointLen(c);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
CGPoint CGPointNorm(CGPoint a) {
	CGFloat m = sqrtf(a.x*a.x+a.y*a.y);
	CGPoint c;
	c.x = a.x/m;
	c.y = a.y/m;
	return c;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)sendEvent:(UIEvent*)event {
	NSSet* allTouches = [event allTouches];
	UITouch* touch = [allTouches anyObject];
	UIView* touchView = [touch view];
	
	//-- UIScrollViews will make touchView be nil after a few UITouchPhaseMoved events;
	//-- by storing the initialView getting the touch, we can overcome this problem
	if (!touchView && _initialView && touch.phase != UITouchPhaseBegan)
		touchView = _initialView;
	
//	NSLog(@"TOUCH (%x): view %@, %@", touch, [touchView class], [_controlledView class]);
	for (UIView* view in self.controlledViews) {
		if ([touchView isDescendantOfView:view]) {

			if (touch.phase == UITouchPhaseBegan) {
	//			NSLog(@"TOUCH BEGAN");
				_initialView = touchView;
				startTouchPosition1 = [touch locationInView:self];
				startTouchTime = touch.timestamp;
				
				if ([allTouches count] > 1) {
					startTouchPosition2 = [[[allTouches allObjects] objectAtIndex:1] locationInView:self];
					previousTouchPosition1 = startTouchPosition1;
					previousTouchPosition2 = startTouchPosition2;
				}
			}
			
			if (touch.phase == UITouchPhaseMoved) {
	//			NSLog(@"TOUCH MOVED");
				if ([allTouches count] > 1) {
					CGPoint currentTouchPosition1 = [[[allTouches allObjects] objectAtIndex:0] locationInView:self];
					CGPoint currentTouchPosition2 = [[[allTouches allObjects] objectAtIndex:1] locationInView:self];

					CGFloat currentFingerDistance = CGPointDist(currentTouchPosition1, currentTouchPosition2);
					CGFloat previousFingerDistance = CGPointDist(previousTouchPosition1, previousTouchPosition2);
					if (fabs(currentFingerDistance - previousFingerDistance) > ZOOM_DRAG_MIN) {
						NSNumber* movedDistance = [NSNumber numberWithFloat:currentFingerDistance - previousFingerDistance];
						if (currentFingerDistance > previousFingerDistance) {
							NSLog(@"zoom in");
							[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ZOOM_IN object:movedDistance];
						} else {
							NSLog(@"zoom out");
							[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ZOOM_OUT object:movedDistance];
						}
					}
				}
			}

			if (touch.phase == UITouchPhaseEnded) {
				CGPoint currentTouchPosition = [touch locationInView:self];
				
				// Check if it's a swipe
				if (fabsf(startTouchPosition1.x - currentTouchPosition.x) >= SWIPE_DRAG_HORIZ_MIN &&
	//				fabsf(startTouchPosition1.y - currentTouchPosition.y) <= SWIPE_DRAG_VERT_MAX &&
					fabsf(startTouchPosition1.x - currentTouchPosition.x) > fabsf(startTouchPosition1.y - currentTouchPosition.y) &&
					touch.timestamp - startTouchTime < 0.7
					) {
					// It appears to be a swipe.
					if (startTouchPosition1.x < currentTouchPosition.x) {
						NSLog(@"swipe right");
						[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SWIPE_RIGHT object:touch];
					} else {
						NSLog(@"swipe left");
						[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SWIPE_LEFT object:touch];
					}
				}
				startTouchPosition1 = CGPointMake(-1, -1);
				_initialView = nil;
			}
			
			if (touch.phase == UITouchPhaseCancelled) {
				_initialView = nil;
	//			NSLog(@"TOUCH CANCEL");
			}
			break;
		}
	}

	[super sendEvent:event];
}

@end
