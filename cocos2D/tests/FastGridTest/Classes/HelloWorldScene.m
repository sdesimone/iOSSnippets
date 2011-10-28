//
//  HelloWorldLayer.m
//  provaCocos
//
//  Created by sergio on 10/18/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// Import the interfaces
#import "HelloWorldScene.h"

#import "SDSFastGrid.h"

/////////////////////////////////////////////////////////////////////////////////////////
@interface ODWaves : CCGrid3DAction
{
	int		waves;
	float	amplitude;
	float	amplitudeRate;
	BOOL	vertical;
	BOOL	horizontal;
}

/** amplitude */
@property (nonatomic,readwrite) float amplitude;
/** amplitude rate */
@property (nonatomic,readwrite) float amplitudeRate;

/** initializes the action with amplitude, horizontal sin, vertical sin, a grid and duration */
+(id)actionWithWaves:(int)wav amplitude:(float)amp horizontal:(BOOL)h vertical:(BOOL)v grid:(ccGridSize)gridSize duration:(ccTime)d;
/** creates the action with amplitude, horizontal sin, vertical sin, a grid and duration */
-(id)initWithWaves:(int)wav amplitude:(float)amp horizontal:(BOOL)h vertical:(BOOL)v grid:(ccGridSize)gridSize duration:(ccTime)d;

@end

/////////////////////////////////////////////////////////////////////////////////////////

#pragma mark Waves

@implementation ODWaves

@synthesize amplitude;
@synthesize amplitudeRate;

/////////////////////////////////////////////////////////////////////////////////////////
+(id)actionWithWaves:(int)wav amplitude:(float)amp horizontal:(BOOL)h vertical:(BOOL)v grid:(ccGridSize)gridSize duration:(ccTime)d
{
	return [[[self alloc] initWithWaves:wav amplitude:amp horizontal:h vertical:v grid:gridSize duration:d] autorelease];
}

/////////////////////////////////////////////////////////////////////////////////////////
-(id)initWithWaves:(int)wav amplitude:(float)amp horizontal:(BOOL)h vertical:(BOOL)v grid:(ccGridSize)gSize duration:(ccTime)d
{
	if ( (self = [super initWithSize:gSize duration:d]) )
	{
		waves = wav;
		amplitude = amp;
		amplitudeRate = 1.0f;
		horizontal = h;
		vertical = v;
	}
	
	return self;
}

/////////////////////////////////////////////////////////////////////////////////////////
-(void)update:(ccTime)time {
	for(int i = 0; i < (gridSize_.x+1); i++ ) {
		for(int j = (gridSize_.y/10*0); j < (gridSize_.y+1); j++ ) {
            //        for(int j = 0; j < (gridSize.y+1); j++ ) {
			ccVertex3F	v = [self originalVertex:ccg(i,j)];
			if ( vertical )
				v.x = (v.x + (sinf(time*(CGFloat)M_PI*waves*2 + v.y * .01f) * amplitude * amplitudeRate * j/gridSize_.y));
			if ( horizontal )
				v.y = (v.y + (sinf(time*(CGFloat)M_PI*waves*2 + v.x * .01f) * amplitude * amplitudeRate * j/gridSize_.y));
			[self setVertex:ccg(i,j) vertex:v];
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////
-(id) copyWithZone: (NSZone*) zone
{
	CCGridAction *copy = [[[self class] allocWithZone:zone] initWithWaves:waves amplitude:amplitude horizontal:horizontal vertical:vertical grid:gridSize_ duration:duration_];
	return copy;
}

@end


/////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
/////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
// HelloWorld implementation
@implementation HelloWorld

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

NSString* frames[] = {
    @"arb245x50.png",
    @"arb265x50.png",
    @"arb285x50.png",
    @"arb310x50.png",
    @"arb50x318.png",
    @"arb318x50.png",
    @"arb73x92.png",
    @"arb92x73.png",
    @"arb63x112.png",
    @"arb50x330.png",
    @"arb100x320.png",
    @"arb390x320.png",
    @"arb128x128.png",
    @"arb512x512.png",
    @"arb50x490.png"
};

NSString* files[] = {
    @"esp1.00073.png",
    @"arb245x50.png",
    @"arb63x112.png"
};

CCLabelTTF *label = nil;

/////////////////////////////////////////////////////////////////////////////////////////
- (CCNode*)nextSpriteFrom:(NSString**)array {
    static short currentIndex = 0;
    if (currentIndex >= sizeof(array)/sizeof(array[0]))
        currentIndex = 0;
    
    CCNode* node = [self getChildByTag:1];
    if (!node) return nil;
    SDSFastGrid* anima = (SDSFastGrid*)[node getChildByTag:1];
    [anima removeFromParentAndCleanup:YES];
    
    [label setString:array[currentIndex++]];
    anima = [SDSFastGrid gridWithFile:label.string];
//    anima = [SDSFastGrid gridWithSpriteFrameName:label.string];
    
    NSLog(@"DRAWING %@", label.string);
    [node addChild:anima z:1 tag:1];

    return anima;
}

/////////////////////////////////////////////////////////////////////////////////////////
- (void)startAnimation {
    
    CCWaves* effect = [CCSequence actions:
                       [ODWaves actionWithWaves:2
                                      amplitude:10
                                     horizontal:YES vertical:YES
                                           grid:ccg(10,8)
                                       duration:1.5],
                       [CCStopGrid action],
                       nil];
    
    [[self nextSpriteFrom:files] runAction:effect];
}


/////////////////////////////////////////////////////////////////////////////////////////
- (void)cacheTexture:(NSString*)texture {
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist", texture]];
    [self addChild:[CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.png", texture]]];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		// create and initialize a Label
		label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
        
        CCNode* node = [CCNode node];
        node.position = ccp(0, 0);
        node.anchorPoint = ccp(0, 0);
        [self addChild:node z:1 tag:1];
        
        [self cacheTexture:@"img.sheet"];
        
        [self schedule:@selector(startAnimation) interval:2.0];
        
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
