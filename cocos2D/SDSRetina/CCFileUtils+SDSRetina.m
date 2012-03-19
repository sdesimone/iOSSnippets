//
//  CCFileUtils+SDSRetina.m
//  MantraPhoneTest
//
//  Created by sergio on 3/19/12.
//  Copyright 2012 Freescapes Labs. All rights reserved.
//

#import "cocos2d.h"

#ifdef CC_RETINA_IPAD_DISPLAY_FILENAME_SUFFIX

@implementation CCFileUtils (SDSRetina)

NSString *ccRemoveHDSuffixFromFile( NSString *path )
{
#if CC_IS_RETINA_DISPLAY_SUPPORTED
    
	if( CC_CONTENT_SCALE_FACTOR() == 2 ) {
        
		NSString *name = [path lastPathComponent];
        
		// check if path already has the suffix.
		if( [name rangeOfString:CC_RETINA_DISPLAY_FILENAME_SUFFIX].location != NSNotFound ) {
            
			CCLOG(@"cocos2d: Filename(%@) contains %@ suffix. Removing it. See cocos2d issue #1040", path, CC_RETINA_DISPLAY_FILENAME_SUFFIX);
            
			NSString *newLastname = [name stringByReplacingOccurrencesOfString:CC_RETINA_DISPLAY_FILENAME_SUFFIX withString:@""];
            
			NSString *pathWithoutLastname = [path stringByDeletingLastPathComponent];
			return [pathWithoutLastname stringByAppendingPathComponent:newLastname];
		} else if( [name rangeOfString:CC_RETINA_IPAD_DISPLAY_FILENAME_SUFFIX].location != NSNotFound ) {
            
			CCLOG(@"cocos2d: Filename(%@) contains %@ suffix. Removing it. See cocos2d issue #1040", path, CC_RETINA_IPAD_DISPLAY_FILENAME_SUFFIX);
            
			NSString *newLastname = [name stringByReplacingOccurrencesOfString:CC_RETINA_IPAD_DISPLAY_FILENAME_SUFFIX withString:@""];
            
			NSString *pathWithoutLastname = [path stringByDeletingLastPathComponent];
			return [pathWithoutLastname stringByAppendingPathComponent:newLastname];
		}
	}
    
#endif // CC_IS_RETINA_DISPLAY_SUPPORTED
    
	return path;
    
}

+(NSString*) getDoubleResolutionImage:(NSString*)path
{
#if CC_IS_RETINA_DISPLAY_SUPPORTED
    
    NSString * retinaPath;
	if( CC_CONTENT_SCALE_FACTOR() == 4 )
	{
		if ( (retinaPath = [self getPathForSuffix:path suffix:CC_RETINA_IPAD_DISPLAY_FILENAME_SUFFIX]) ) {
            return retinaPath;
        }
	}
    
    if( CC_CONTENT_SCALE_FACTOR() == 2 )
	{
        if ( (retinaPath = [self getPathForSuffix:path suffix:CC_RETINA_DISPLAY_FILENAME_SUFFIX]) ) {
            return retinaPath;
        }
	}
	
#endif // CC_IS_RETINA_DISPLAY_SUPPORTED
    
	return path;
}

+(NSString*) getPathForSuffix:(NSString*)path suffix:(NSString*)suffix {
    NSString *pathWithoutExtension = [path stringByDeletingPathExtension];
    NSString *name = [pathWithoutExtension lastPathComponent];
    
    static NSFileManager *__localFileManager = [[NSFileManager alloc] init];
    
    // check if path already has the suffix.
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
    
    if( [__localFileManager fileExistsAtPath:retinaName] )
        return retinaName;
    
    CCLOG(@"cocos2d: CCFileUtils: Warning HD file not found (%@): %@", suffix, [retinaName lastPathComponent] );
    
    return nil;
}


@end

#endif

