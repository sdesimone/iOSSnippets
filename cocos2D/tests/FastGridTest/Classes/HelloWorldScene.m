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


#pragma mark ODLiquid
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
@interface ODLiquid : CCGrid3DAction
{
	int waves;
	float amplitude;
	float amplitudeRate;
	
}

@property (nonatomic,readwrite) float amplitude;
@property (nonatomic,readwrite) float amplitudeRate;

+(id)actionWithWaves:(int)wav amplitude:(float)amp grid:(ccGridSize)gridSize duration:(ccTime)d;
-(id)initWithWaves:(int)wav amplitude:(float)amp grid:(ccGridSize)gridSize duration:(ccTime)d;

@end

#pragma mark -
#pragma mark ODLiquid
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
@implementation ODLiquid

@synthesize amplitude;
@synthesize amplitudeRate;

/////////////////////////////////////////////////////////////////////////////////////////
+(id)actionWithWaves:(int)wav amplitude:(float)amp grid:(ccGridSize)gridSize duration:(ccTime)d {
	return [[[self alloc] initWithWaves:wav amplitude:amp grid:gridSize duration:d] autorelease];
}

/////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithWaves:(int)wav amplitude:(float)amp grid:(ccGridSize)gSize duration:(ccTime)d {
	if ((self = [super initWithSize:gSize duration:d])) {
		waves = wav;
		amplitude = amp;
		amplitudeRate = 1.0f;
	}
	
	return self;
}

/////////////////////////////////////////////////////////////////////////////////////////
- (void)update:(ccTime)time {
	int i, j;
	float c = 4*(1/4.0 - (time-1/2.0) * (time-1/2.0));
	for (i = 1; i < gridSize_.x; i++) {
		for( j = 1; j < gridSize_.y; j++ ) {
			ccVertex3F	v = [self originalVertex:ccg(i,j)];
            float dx = (time-duration_)/duration_*(sinf(time*(CGFloat)M_PI*waves*2 + v.x * .01f * c) * amplitude * amplitudeRate);
            float dy = (time-duration_)/duration_*(sinf(time*(CGFloat)M_PI*waves*2 + v.y * .01f * c) * amplitude * amplitudeRate);
			v.x += dy;
			v.y += dx;
			[self setVertex:ccg(i,j) vertex:v];
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////
- (id)copyWithZone:(NSZone*)zone {
	CCGridAction *copy = [[[self class] allocWithZone:zone] initWithWaves:waves amplitude:amplitude grid:gridSize_ duration:duration_];
	return copy;
}

@end

/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -


/////////////////////////////////////////////////////////////////////////////////////////
@interface ODWaves : CCGrid3DAction {
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
- (id)initWithWaves:(int)wav amplitude:(float)amp horizontal:(BOOL)h vertical:(BOOL)v grid:(ccGridSize)gSize duration:(ccTime)d {
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

- (float)coeffAtTime:(float)t period:(float)p {
    return 1.0;
//    float f = pow(1 - (t-p/2) * (t-p/2), 1/4);
//    NSLog(@"PHASE FACTOR: %f", f);
//    return f;
}

/////////////////////////////////////////////////////////////////////////////////////////
-(void)update:(ccTime)time {
	for(int i = 0; i < (gridSize_.x+1); i++ ) {
		for(int j = (gridSize_.y/10*0); j < (gridSize_.y+1); j++ ) {
//        for(int j = 0; j < (gridSize_.y+1); j++ ) {
			ccVertex3F	v = [self originalVertex:ccg(i,j)];
			if ( vertical )
				v.x = (v.x + (sinf(time*(CGFloat)M_PI*waves*2 + v.y * .01f) * amplitude * amplitudeRate * MIN(1, j/gridSize_.y/2)));
			if ( horizontal )
				v.y = (v.y + (sinf(time*(CGFloat)M_PI*waves*2 + v.x * .01f) * amplitude * amplitudeRate * MIN(1, j/gridSize_.y/2)));
/*            
            float c = [self coeffAtTime:time period:1/waves];
			if ( vertical )
				v.x = (v.x + (sinf(time*(CGFloat)M_PI*waves*2 + v.y * .01f * c) * amplitude * amplitudeRate));
			if ( horizontal )
				v.y = (v.y + (sinf(time*(CGFloat)M_PI*waves*2 + v.x * .01f * c) * amplitude * amplitudeRate));
*/			[self setVertex:ccg(i,j) vertex:v];
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////
- (id)copyWithZone:(NSZone*)zone {
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

+ (id)scene {
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
    @"arb1.png",
    @"arb2.png",
    @"arb3.png",
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

#define numOfElements 1

/////////////////////////////////////////////////////////////////////////////////////////
- (CCNode*)nextSpriteFrom:(NSString**)array {
    static short currentIndex = 0;
    if (currentIndex >= numOfElements)
        currentIndex = 0;
    
    CCNode* node = [self getChildByTag:1];
    if (!node) return nil;
    
    SDSFastGrid* anima = (SDSFastGrid*)[node getChildByTag:1];
    [anima removeFromParentAndCleanup:YES];
    
    [label setString:array[currentIndex++]];
//    anima = [SDSFastGrid gridWithFile:label.string];
//    anima = [SDSFastGrid gridWithSpriteFrameName:label.string];
    anima = [CCSprite spriteWithSpriteFrameName:label.string];
    anima.position = ccp(512, 384);
    anima.anchorPoint = ccp(1.0,1.0);
    
    NSLog(@"DRAWING %@", label.string);
    [node addChild:anima z:1 tag:1];

    return anima;
}

#define kDuration 4.0
/////////////////////////////////////////////////////////////////////////////////////////
- (void)startAnimation {
    
    static bool ciccio = true;
    ciccio = !ciccio;
    
    CCNode* node = [self nextSpriteFrom:frames];
    ccGridSize grid = (ciccio ? ccg(5, 4):ccg(5,4));
    ciccio = 0;
    
    CCWaves* effect = [CCSequence actions:
                       [ODLiquid actionWithWaves:2
                                      amplitude:10
//                                     horizontal:YES vertical:YES
                                            grid:grid
                                       duration:kDuration],
                       [CCStopGrid action],
                       nil];
    
    CCRotateBy* rotate = [CCRotateBy actionWithDuration:1.5 angle:90];
    CCScaleBy* scale = [CCScaleBy actionWithDuration:1.5 scale:0.5];
    
    [node runAction:effect];
//    [node runAction:rotate];
//    [node runAction:scale];
}


/////////////////////////////////////////////////////////////////////////////////////////
- (void)cacheTexture:(NSString*)texture {
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist", texture]];
    [self addChild:[CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.png", texture]]];
}

/////////////////////////////////////////////////////////////////////////////////////////
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
        [self cacheTexture:@"arbres+spirits"];
  
//        [self startAnimation];
        [self schedule:@selector(startAnimation) interval:kDuration+1.0];
        
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
