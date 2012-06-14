//
//  CALayer+SDSLayerByName.m
//  MantraPhoneTest
//
//  Created by sergio on 5/2/12.
//  Copyright 2012 Sergio De Simone, Freescapes Labs. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
@implementation CALayer (SDSLayerByName)

+ (void)swizzleMethod:(SEL)originalSel andMethod:(SEL)swizzledSel {
    
    Method original = class_getInstanceMethod(self, originalSel);
    Method swizzled = class_getInstanceMethod(self, swizzledSel);
    if (original && swizzled)
        method_exchangeImplementations(original, swizzled);
    else
        NSLog(@"CALayer+SDSLayerByName Swizzling Fault: methods not found.");

}    

//////////////////////////////////////////////////////////////////////////////////////////////
+ (void)load {
    [self swizzleMethod:@selector(addSublayer:) andMethod:@selector(addSublayerSwizzled:)];
    [self swizzleMethod:@selector(setName:) andMethod:@selector(setNameSwizzled:)];
    
}

/////////////////////////////////////////////////////////////////////////////////////////
- (void)addSublayerSwizzled:(CALayer*)layer {
    if (layer.name)
        [self setValue:layer forKey:layer.name];
    return [self addSublayerSwizzled:layer];
}

/////////////////////////////////////////////////////////////////////////////////////////
- (CALayer*)layerByName:(NSString*)name {
    return [self valueForKey:name];
}

/////////////////////////////////////////////////////////////////////////////////////////
- (void)setNameSwizzled:(NSString*)name {
    if (self.superlayer) {
        [self.superlayer setValue:self forKey:name];
    }
    [self setNameSwizzled:name];
}



@end


