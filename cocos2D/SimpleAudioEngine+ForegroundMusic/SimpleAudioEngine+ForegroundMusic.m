//
//  SimpleAudioEngine+ForegroundMusic.m
//  MantraPhoneTest
//
//  Created by sergio on 7/24/12.
//  Copyright 2012 Freescapes Labs. All rights reserved.
//

#import "SimpleAudioEngine+ForegroundMusic.h"

static CDLongAudioSource* foregroundMusic = nil;

@implementation SimpleAudioEngine (ForegroundMusic)

-(void) playForegroundMusic:(NSString*) filePath loop:(BOOL) loop {
    
    CDAudioManager* am = [CDAudioManager sharedManager];
    
    if (!foregroundMusic) {
        foregroundMusic = [am audioSourceForChannel:kASC_Right];
    }
    [foregroundMusic load:filePath];
    
    if (am.mute) {
		CDLOG(@"Denshion::CDAudioManager - play bgm aborted because audio is not exclusive or sound is muted");
		return;
	}
    
	if (loop) {
		[foregroundMusic setNumberOfLoops:-1];
	} else {
		[foregroundMusic setNumberOfLoops:0];
	}	
	[foregroundMusic play];
}

-(void) stopForegroundMusic
{
	[foregroundMusic stop];
}

-(void) pauseForegroundMusic {
	[foregroundMusic pause];
}	

-(void) resumeForegroundMusic {
	[foregroundMusic resume];
}	


@end
