//
//  CCFileUtils+SDSDeviceSuffix.m
//  MantraPhoneTest
//
//  Created by sergio on 3/19/12.
//  Copyright 2012 Freescapes Labs. All rights reserved.
//

#import "cocos2d.h"

#define CC_IPAD_DISPLAY_FILENAME_SUFFIX @"~ipad"
#define CC_RETINA_IPAD_DISPLAY_FILENAME_SUFFIX @"-hd~ipad"

#ifdef CC_RETINA_IPAD_DISPLAY_FILENAME_SUFFIX

//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
@implementation CCFileUtils (SDSDeviceSuffix)

//////////////////////////////////////////////////////////////////////////////////////////////
+ (NSFileManager*)localFileManager {
    static NSFileManager *__localFileManager = nil;
    
    if (!__localFileManager)
        __localFileManager = [[NSFileManager alloc] init];
    return __localFileManager;
}

//////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)getPathForSuffix:(NSString*)path suffix:(NSString*)suffix {
    
    NSString *pathWithoutExtension = [path stringByDeletingPathExtension];
    NSString *name = [pathWithoutExtension lastPathComponent];
    
    //-- check if path already has the suffix.
    if( [name rangeOfString:suffix].location != NSNotFound ) {
        
        CCLOG(@"cocos2d: WARNING Filename(%@) already has the suffix %@. Using it.", name, suffix);			
        return path;
    }
    
    NSString *extension = [path pathExtension];
    
    if( [extension isEqualToString:@"ccz"] || [extension isEqualToString:@"gz"] )
    {
        // All ccz / gz files should be in the format filename.xxx.ccz
        // so we need to pull off the .xxx part of the extension as well
        extension = [NSString stringWithFormat:@"%@.%@", [pathWithoutExtension pathExtension], extension];
        pathWithoutExtension = [pathWithoutExtension stringByDeletingPathExtension];
    }
    
    
    NSString *retinaName = [pathWithoutExtension stringByAppendingString:suffix];
    retinaName = [retinaName stringByAppendingPathExtension:extension];
    
    if( [[self localFileManager] fileExistsAtPath:retinaName] )
        return retinaName;
    
    CCLOG(@"cocos2d: CCFileUtils: Warning HD file not found (%@): %@", suffix, [retinaName lastPathComponent] );
    
    return nil;
}

//////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)getDoubleResolutionImage:(NSString*)path {

#if CC_IS_RETINA_DISPLAY_SUPPORTED
    
    NSString * retinaPath;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

        if (CC_CONTENT_SCALE_FACTOR() == 2) {
            if ((retinaPath = [self getPathForSuffix:path suffix:CC_RETINA_IPAD_DISPLAY_FILENAME_SUFFIX])) {
                return retinaPath;
            } else if ((retinaPath = [self getPathForSuffix:path suffix:CC_IPAD_DISPLAY_FILENAME_SUFFIX])) {
                return retinaPath;
            } else if ((retinaPath = [self getPathForSuffix:path suffix:CC_RETINA_DISPLAY_FILENAME_SUFFIX])) {
                return retinaPath;
            }
        } else {
            if ((retinaPath = [self getPathForSuffix:path suffix:CC_IPAD_DISPLAY_FILENAME_SUFFIX])) {
                return retinaPath;
            } else if ((retinaPath = [self getPathForSuffix:path suffix:CC_RETINA_DISPLAY_FILENAME_SUFFIX])) {
                return retinaPath;
            }
        }

    } else {
        
        if (CC_CONTENT_SCALE_FACTOR() == 2) {
            if ((retinaPath = [self getPathForSuffix:path suffix:CC_RETINA_DISPLAY_FILENAME_SUFFIX])) {
                return retinaPath;
            }
        }
    }
	
#endif // CC_IS_RETINA_DISPLAY_SUPPORTED
    
	return path;
}

@end

#endif

