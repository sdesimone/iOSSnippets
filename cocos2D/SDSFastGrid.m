/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2008-2010 Ricardo Quesada
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

//
// This class, based on original work by Ricardo Quesada, gives a node
// that can be initialized with a texture (a sort of light sprite)
// its main aim is making "light grid effects" possible.
// You can use it in place of a CCSprite when you need to apply
// animations effects based on CCGrid3D or CCTiledGrid3D.
//
// Sergio De Simone, freescapes labs, 2011
//

#import "SDSFastGrid.h"


//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
@interface CCGrid3D(SDSCocosExtension)
-(void)calculateTexCoordsForFrame:(CCSpriteFrame*)frame;
@end

//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
@implementation CCGrid3D(SDSCocosExtension)

//////////////////////////////////////////////////////////////////////////////////////////////
-(void)calculateTexCoordsForFrame:(CCSpriteFrame*)frame {
	float width = (float)texture_.pixelsWide;
	float height = (float)texture_.pixelsHigh;
	float imageH = texture_.contentSizeInPixels.height;
    
    CGRect rect = frame.rectInPixels;
	
	int x, y, i;
	
	texCoordinates = malloc((gridSize_.x+1)*(gridSize_.y+1)*sizeof(CGPoint));
	float *texArray = (float*)texCoordinates;
	
    float xoff = rect.origin.x;
    float yoff = imageH - rect.origin.y - rect.size.height;
    float xext = rect.size.width;
    float yext = rect.size.height;

	for (x = 0; x < gridSize_.x; x++) {
		for( y = 0; y < gridSize_.y; y++ ) {
            
			GLushort a = x * (gridSize_.y+1) + y;
			GLushort b = (x+1) * (gridSize_.y+1) + y;
			GLushort c = (x+1) * (gridSize_.y+1) + (y+1);
			GLushort d = x * (gridSize_.y+1) + (y+1);
			
			int tex1[4] = { a*2, b*2, c*2, d*2 };
            
            float xx1 = x*xext/gridSize_.x + xoff;
            float xx2 = xx1 + xext/gridSize_.x;
            float yy1 = y*yext/gridSize_.y + yoff;
            float yy2 = yy1 + yext/gridSize_.y;
            CGPoint tex2[4] = { ccp(xx1, yy1), ccp(xx2, yy1), ccp(xx2, yy2), ccp(xx1, yy2) };
            CGPoint tex2rot[4] = { ccp(xx2, yy1), ccp(xx2, yy2), ccp(xx1, yy2), ccp(xx1, yy1) };
            CGPoint* tt = tex2;
            if (frame.rotated) {
                tt = tex2rot;
                rect.size = CGSizeMake(rect.size.height, rect.size.width);
            }
            
			for(i = 0; i < 4; i++)
			{
				texArray[ tex1[i] ] = tt[i].x / width;
				if( isTextureFlipped_ )
					texArray[ tex1[i] + 1 ] = (imageH - tt[i].y) / height;
				else
					texArray[ tex1[i] + 1 ] = tt[i].y / height;
            }
		}
	}
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
@interface SDSFastGrid(PrivateMethods)
- (id)initWithTexture:(CCTexture2D*)texture;
- (id)initWithSprite:(CCSprite*)sprite;
@end


@implementation SDSFastGrid

@synthesize sprite = sprite_;
@dynamic isActive;

//////////////////////////////////////////////////////////////////////////////////////////////
+(id)gridWithFile:(NSString*)fileName {
    CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:fileName];
    if (texture)
        return [[SDSFastGrid alloc] initWithTexture:texture];
    return nil;
}

//////////////////////////////////////////////////////////////////////////////////////////////
+ (id)gridWithSpriteFrameName:(NSString*)frameName {
	return [[[self alloc] initWithSpriteFrameName:frameName] autorelease];
}

//////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithSprite:(CCSprite*)sprite {
    if ((self = [super init])) {
        sprite_ = [sprite retain];
        NSLog(@"CREATED SPRITE FOR %x", sprite_);
        self.texture = sprite.texture;
        shouldRecalcGridVertices = YES;
        
        CGSize size = [[CCDirector sharedDirector] winSizeInPixels];
        
        hscale_ = sprite_.contentSize.width/size.width;
        vscale_ = sprite_.contentSize.height/size.height;
        postOffset_ = 0.0;
        
        [self setContentSize:sprite.textureRect.size];
    }
    return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithSpriteFrameName:(NSString*)frameName {
    CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
    if ((self = [self initWithSprite:[CCSprite spriteWithSpriteFrame:frame]])) {
        frame_ = frame;
    }
    return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithTexture:(CCTexture2D*)texture {
	if ((self = [super init])) {
		self.texture = texture;
		sprite_ = [[CCSprite alloc] initWithTexture:texture];
        shouldRecalcGridVertices = NO;
        
        CGSize size = [[CCDirector sharedDirector] winSizeInPixels];
        unsigned int POTWide = ccNextPOT(size.width);
        unsigned int POTHigh = ccNextPOT(size.height);

        hscale_ = sprite_.contentSize.width/[SDSFastGrid maxDimension:sprite_.contentSize.width lessThanPOT:POTWide];
        vscale_ = sprite_.contentSize.height/[SDSFastGrid maxDimension:sprite_.contentSize.height lessThanPOT:POTHigh];
        postOffset_ = size.height - [SDSFastGrid maxDimension:sprite_.contentSize.height lessThanPOT:POTHigh];
        
        [self setContentSize:sprite_.textureRect.size];
	}
	
	return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
	[sprite_ release]; sprite_ = nil;
	[texture_ release]; texture_ = nil;
	[fastGrid_ release]; fastGrid_ = nil;
		
	[super dealloc];
}

//////////////////////////////////////////////////////////////////////////////////////////////
+ (float)maxDimension:(float)x lessThanPOT:(float)max {
    if (x > max)
        return x/2;
    short coeff = pow(2, (short)log2(max/x));
    return  coeff * x;
}

//////////////////////////////////////////////////////////////////////////////////////////////
- (void)draw {
	if (fastGrid_ && fastGrid_.active) {
        
        if (frame_ != nil && [fastGrid_ isKindOfClass:[CCGrid3D class]])
            [(CCGrid3D*)fastGrid_ calculateTexCoordsForFrame:frame_];
        
        glMatrixMode(GL_MODELVIEW);
        glPushMatrix();
        
        glBindTexture(GL_TEXTURE_2D, [texture_ name]);
        glScalef(hscale_, vscale_, 1.0);
        ccglTranslate(0, -postOffset_, 0);

		[fastGrid_ blit];
        glPopMatrix();

	} else {
		[sprite_ draw];
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////
- (bool)isActive {
    return (fastGrid_ && fastGrid_.active);
}

//////////////////////////////////////////////////////////////////////////////////////////////
- (void)setPosition:(CGPoint)newPosition {
    [super setPosition:newPosition];
    sprite_.position = newPosition;
}

//////////////////////////////////////////////////////////////////////////////////////////////
-(void) setOpacity:(GLubyte) anOpacity {
    sprite_.opacity = anOpacity;
}

//////////////////////////////////////////////////////////////////////////////////////////////
-(GLubyte) opacity
{
	return sprite_.opacity;
}

//////////////////////////////////////////////////////////////////////////////////////////////
-(void) setScale:(float) s
{
    [super setScale:s];
    sprite_.scale = s;
}

//////////////////////////////////////////////////////////////////////////////////////////////
- (CCGridBase*)grid
{
	return fastGrid_;
}

//////////////////////////////////////////////////////////////////////////////////////////////
- (void)setGrid:(CCGridBase*)grid
{
	[grid setIsTextureFlipped:YES];
	[fastGrid_ release];
	fastGrid_ = [grid retain];
	[fastGrid_ setTexture:texture_];
}

//////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTexture:(CCTexture2D*)texture
{
	[texture_ release];
	texture_ = [texture retain];
	[fastGrid_ setTexture:texture_];
}

//////////////////////////////////////////////////////////////////////////////////////////////
- (CCTexture2D*)texture
{
	return texture_;
}



@end
