//
//  CDAudioManager+FLForegroundMusic.m
//
//  Created by sergio on 10/12/12.
//  Copyright 2012 Freescapes Labs. All rights reserved.
//

#import "CDAudioManager+FLForegroundMusic.h"
#import "FLCategoryProperties.h"

@implementation CDAudioManager (FLForegroundMusic)

PROPERTY_OBJ(foregroundMusic, setForegroundMusic, CDLongAudioSource*)

//////////////////////////////////////////////////////////////////////////////////////////
-(void) playForegroundMusic:(NSString*)filePath
                       loop:(BOOL)loop
                   delegate:(id<CDLongAudioSourceDelegate>)delegate {
    
    CDAudioManager* am = [CDAudioManager sharedManager];
    
    if (!self.foregroundMusic)
        self.foregroundMusic = [am audioSourceForChannel:kASC_Right];
    [self.foregroundMusic load:filePath];
    
    if (delegate)
        self.foregroundMusic.delegate = delegate;
    
    if (am.mute) {
                CDLOG(@"Denshion::CDAudioManager - play bgm aborted because audio is not exclusive or sound is muted");
                return;
        }
    
        if (loop) {
                [self.foregroundMusic setNumberOfLoops:-1];
        } else {
                [self.foregroundMusic setNumberOfLoops:0];
        }       
        [self.foregroundMusic play];
}

//////////////////////////////////////////////////////////////////////////////////////////
-(float) foregroundMusicVolume
{
        return self.foregroundMusic.volume;
}       

//////////////////////////////////////////////////////////////////////////////////////////
-(void) setForegroundMusicVolume:(float) volume
{
        self.foregroundMusic.volume = volume;
}       

//////////////////////////////////////////////////////////////////////////////////////////
-(void) stopForegroundMusic
{
        [self.foregroundMusic stop];
}

//////////////////////////////////////////////////////////////////////////////////////////
-(void) pauseForegroundMusic {
        [self.foregroundMusic pause];
}       

//////////////////////////////////////////////////////////////////////////////////////////
-(void) resumeForegroundMusic {
        [self.foregroundMusic resume];
}       

@end

