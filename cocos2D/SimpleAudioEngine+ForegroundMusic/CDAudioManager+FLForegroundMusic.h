//
//  CDAudioManager+FLForegroundMusic.h
//
//  Created by sergio on 10/12/12.
//  Copyright 2012 Freescapes Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDAudioManager.h"

@interface CDAudioManager (FLForegroundMusic)

@property (nonatomic, retain) CDLongAudioSource* foregroundMusic;

-(void) playForegroundMusic:(NSString*)filePath
                       loop:(BOOL)loop
                   delegate:(id<CDLongAudioSourceDelegate>)delegate;

-(void) stopForegroundMusic;
-(void) pauseForegroundMusic;
-(void) resumeForegroundMusic;

@end
