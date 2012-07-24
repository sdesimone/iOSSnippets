//
//  SimpleAudioEngine+ForegroundMusic.h
//  MantraPhoneTest
//
//  Created by sergio on 7/24/12.
//  Copyright 2012 Freescapes Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"

@interface SimpleAudioEngine (ForegroundMusic)

-(void) playForegroundMusic:(NSString*)filePath loop:(BOOL)loop;
-(void) stopForegroundMusic;
-(void) pauseForegroundMusic;
-(void) resumeForegroundMusic;

@end
