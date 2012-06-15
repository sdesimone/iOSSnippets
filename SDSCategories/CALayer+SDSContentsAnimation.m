//
//  CALayer+SDSContentsAnimation.m
//  MantraPhoneTest
//
//  Created by sergio on 5/2/12.
//  Copyright 2012 Sergio De Simone, Freescapes Labs. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CALayer+SDSContentsAnimation.h"

//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
static float contentsAnimationDuration = 1.0f;

//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
@implementation CALayer (SDSContentsAnimation)

//////////////////////////////////////////////////////////////////////////////////////////////
+ (void)swizzleMethod:(SEL)originalSel andMethod:(SEL)swizzledSel {
    
    Method original = class_getInstanceMethod(self, originalSel);
    Method swizzled = class_getInstanceMethod(self, swizzledSel);
    if (original && swizzled)
        method_exchangeImplementations(original, swizzled);
    else
        NSLog(@"CALayer+SDSContentsAnimation Swizzling Fault: methods not found.");

}    

//////////////////////////////////////////////////////////////////////////////////////////////
+ (void)load {
    [self swizzleMethod:@selector(setContents:) andMethod:@selector(setContentsSwizzled:)];
    
}

/////////////////////////////////////////////////////////////////////////////////////////
- (void)setContentsSwizzled:(id)contents {
    if ([contents isKindOfClass:[NSArray class]]) {
        
        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        [animation setCalculationMode:kCAAnimationLinear];
        [animation setDuration:contentsAnimationDuration];
        [animation setRepeatCount:HUGE_VALF];
        [animation setValues:contents];        
        [self addAnimation:animation forKey:@"contents"];
        
    } else
        [self setContentsSwizzled:contents];
}

/////////////////////////////////////////////////////////////////////////////////////////
+ (void)setContentsAnimationDuration:(float)d {
    contentsAnimationDuration = d;
}

/////////////////////////////////////////////////////////////////////////////////////////
+ (float)contentsAnimationDuration {
    return contentsAnimationDuration;
}

@end


