//
//  UIImage+SDSCategory.h
//  maniphone
//
//  Created by sergio on 2/3/11.
//  Copyright 2011 freescapes.org. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (SDSCategory)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end
