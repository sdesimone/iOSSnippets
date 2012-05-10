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

#import "Support/TransformUtils.h"

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
//    rect.size = frame.originalSizeInPixels;
//    rect.origin = 
	
	int gx, gy, i;
	
    if (texCoordinates)
        free(texCoordinates);
    
	texCoordinates = malloc((gridSize_.x+1)*(gridSize_.y+1)*sizeof(CGPoint));
	float *texArray = (float*)texCoordinates;
	
    if (frame.rotated) {
        rect.size = CGSizeMake(rect.size.height, rect.size.width);
    }
    float xoff = rect.origin.x;
    float yoff = imageH - rect.origin.y - rect.size.height;
    float xext = rect.size.width;
    float yext = rect.size.height;

	for (gx = 0; gx < gridSize_.x; gx++) {
		for(gy = 0; gy < gridSize_.y; gy++) {
            
            int x = gx;
            int y = gy;
            float xx1, xx2, yy1, yy2;
            
			GLushort a = x * (gridSize_.y+1) + y;
			GLushort b = (x+1) * (gridSize_.y+1) + y;
			GLushort c = (x+1) * (gridSize_.y+1) + (y+1);
			GLushort d = x * (gridSize_.y+1) + (y+1);
			
			int tex1[4] = { a*2, b*2, c*2, d*2 };
            
            //-- if frame is rotated, each grid element must be mapped on to the corresponding texture area
            if (frame.rotated) {
                x = gy;
                y = gridSize_.x - gx - 1;
                
                xx1 = x * xext/gridSize_.y + xoff;
                xx2 = xx1 + xext/gridSize_.y;
                yy1 = y * yext/gridSize_.x + yoff;
                yy2 = yy1 + yext/gridSize_.x;
                
            } else {
                
                xx1 = x * xext/gridSize_.x + xoff;
                xx2 = xx1 + xext/gridSize_.x;
                yy1 = y * yext/gridSize_.y + yoff;
                yy2 = yy1 + yext/gridSize_.y;
                
            }
            
            CGPoint tex2[4] = { ccp(xx1, yy1), ccp(xx2, yy1), ccp(xx2, yy2), ccp(xx1, yy2) };

            //-- if frame is rotated, coords order is: 3, 0, 1, 2 instead of 0, 1, 2, 3
			for (i = 0; i < 4; i++) {
                short k = (i + (frame.rotated?3:0))%4;
				texArray[ tex1[i] ] = tex2[k].x / width;
				if(isTextureFlipped_)
					texArray[ tex1[i] + 1 ] = (imageH - tex2[k].y) / height;
				else
					texArray[ tex1[i] + 1 ] = tex2[k].y / height;
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


//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
@implementation SDSFastGrid

@synthesize sprite = sprite_;
@synthesize fastGrid = fastGrid_;
@dynamic isActive;
@dynamic flipX;
@dynamic flipY;

//////////////////////////////////////////////////////////////////////////////////////////////
+(id)gridWithFile:(NSString*)fileName {
    CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:fileName];
    if (texture)
        return [[[SDSFastGrid alloc] initWithTexture:texture] autorelease];
    return nil;
}

//////////////////////////////////////////////////////////////////////////////////////////////
+ (id)gridWithTexture:(CCTexture2D*)texture {
	return [[[self alloc] initWithTexture:texture] autorelease];
}

//////////////////////////////////////////////////////////////////////////////////////////////
+ (id)gridWithSpriteFrameName:(NSString*)frameName {
	return [[[self alloc] initWithSpriteFrameName:frameName] autorelease];
}

//////////////////////////////////////////////////////////////////////////////////////////////
+ (id)gridWithSpriteFrame:(CCSpriteFrame*)frame {
	return [[[self alloc] initWithSpriteFrame:frame] autorelease];
}

/*
//////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithSprite:(CCSprite*)sprite {
    if ((self = [super init])) {
        sprite_ = [sprite retain];

        self.texture = sprite.texture;
        shouldRecalcGridVertices = NO;
        
        CGSize size = [[CCDirector sharedDirector] winSizeInPixels];
        unsigned int POTWide = ccNextPOT(size.width);
        unsigned int POTHigh = ccNextPOT(size.height);
        
        hscale_ = sprite_.contentSize.width/[SDSFastGrid maxDimension:sprite_.contentSize.width lessThanPOT:POTWide];
        vscale_ = sprite_.contentSize.height/[SDSFastGrid maxDimension:sprite_.contentSize.height lessThanPOT:POTHigh];
        postOffset_ = size.height - [SDSFastGrid maxDimension:sprite_.contentSize.height lessThanPOT:POTHigh];
        
        [self setContentSize:sprite.textureRect.size];
    }
    return self;
}
*/

//////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithSpriteFrame:(CCSpriteFrame*)frame {
    if ((self = [super init])) {
        frame_ = [frame retain];
        self.sprite = [CCSprite spriteWithSpriteFrame:frame_];
        self.texture = sprite_.texture;
        shouldRecalcGridVertices = YES;
        
        CGSize size = [[CCDirector sharedDirector] winSizeInPixels];
        hscale_ = frame.rectInPixels.size.width/size.width;
        vscale_ = frame.rectInPixels.size.height/size.height;
        hOffset_ = (frame.rectInPixels.size.width - frame.originalSizeInPixels.width)/2 / hscale_;
        vOffset_ =  (frame.rectInPixels.size.height - frame.originalSizeInPixels.height)/2 / vscale_;
        
//        [self setContentSize:CGSizeMake(0,0)];
//        [self setContentSize:sprite_.textureRect.size];
        [self setContentSizeInPixels:frame.originalSizeInPixels];
    }
    return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithSpriteFrameName:(NSString*)frameName {
    return [self initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                       spriteFrameByName:frameName]];
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
        
        hscale_ = sprite_.contentSizeInPixels.width/[SDSFastGrid maxDimension:sprite_.contentSizeInPixels.width lessThanPOT:POTWide];
        vscale_ = sprite_.contentSizeInPixels.height/[SDSFastGrid maxDimension:sprite_.contentSizeInPixels.height lessThanPOT:POTHigh];
        vOffset_ = size.height - [SDSFastGrid maxDimension:sprite_.contentSizeInPixels.height lessThanPOT:POTHigh];

        [self setContentSize:sprite_.textureRect.size];
        NSLog(@"CREATING FAST SPRITE SIZED: %f, %f", sprite_.textureRect.size.width, sprite_.textureRect.size.height);

	}
	
	return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    [frame_ release]; frame_ = nil;
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
    
    float radians = -CC_DEGREES_TO_RADIANS(rotation_);
/*    float c = cosf(radians);
    float s = sinf(radians);
    
    CGAffineTransform matrix = CGAffineTransformMake(c * scaleX_,  s * scaleX_,
                                                     -s * scaleY_, c * scaleY_,
                                                     0, 0);
    matrix = CGAffineTransformTranslate(matrix, -sprite_.anchorPointInPixels.x, -sprite_.anchorPointInPixels.y);	
    
*/    CGAffineTransform matrix = CGAffineTransformMakeTranslation(-sprite_.anchorPointInPixels.x, -sprite_.anchorPointInPixels.y);
    GLfloat	glt[16];
    CGAffineToGL(&matrix, glt);

    glMatrixMode(GL_MODELVIEW);
    glPushMatrix();
    glMultMatrixf(glt);
    
	if (fastGrid_ && fastGrid_.active) {
        
        if (sprite_.blendFunc.src != CC_BLEND_SRC || sprite_.blendFunc.dst != CC_BLEND_DST)
            glBlendFunc( sprite_.blendFunc.src, sprite_.blendFunc.dst );        
        
        if (frame_ != nil && [fastGrid_ isKindOfClass:[CCGrid3D class]]) {
            [(CCGrid3D*)fastGrid_ calculateTexCoordsForFrame:frame_];
        }
        
        glBindTexture(GL_TEXTURE_2D, [texture_ name]);
        if (sprite_.flipX) {
            ccglTranslate(sprite_.textureRect.size.width, 0, 0);
            glScalef(-1.0, 1.0, 1.0);
        }
        if (sprite_.flipY) {
            ccglTranslate(0, sprite_.textureRect.size.height, 0);
            glScalef(1.0, -1.0, 1.0);
        }
        
        glScalef(hscale_, vscale_, 1.0);
        ccglTranslate(-hOffset_, -vOffset_, 0);
		[fastGrid_ blit];

	} else {
		[sprite_ draw];
	}

    glPopMatrix();
    
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
- (bool)flipX {
    return sprite_.flipX;
}

//////////////////////////////////////////////////////////////////////////////////////////////
- (void)setFlipX:(bool)flip {
    sprite_.flipX = flip;
}

//////////////////////////////////////////////////////////////////////////////////////////////
- (bool)flipY {
    return sprite_.flipY;
}

//////////////////////////////////////////////////////////////////////////////////////////////
- (void)setFlipY:(bool)flip {
    sprite_.flipY = flip;
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
    //-- SDS: call to isTextureFlipped is a hack to force calling the grid's calculateVertexPoints method
	[grid setIsTextureFlipped:![grid isTextureFlipped]];
    
    //-- SDS: this block from initWithTexture
    //-- it seems to be necessary when the grid is autorotated to readjust the offset
    //-- should be checked if this whole voffset_/scale_ matter could be refactored
    CGSize size = [[CCDirector sharedDirector] winSizeInPixels];
    unsigned int POTHigh = ccNextPOT(size.height);
    vOffset_ = size.height - [SDSFastGrid maxDimension:sprite_.contentSizeInPixels.height lessThanPOT:POTHigh];

	[fastGrid_ release];
	fastGrid_ = [grid retain];
	[fastGrid_ setTexture:texture_];
}


//////////////////////////////////////////////////////////////////////////////////////////////
-(BOOL) isFrameDisplayed:(CCSpriteFrame*)frame {
    return [sprite_ isFrameDisplayed:frame];
}

//////////////////////////////////////////////////////////////////////////////////////////////
-(void) setDisplayFrame:(CCSpriteFrame*)newFrame {
    [sprite_ setDisplayFrame:newFrame];
}

//////////////////////////////////////////////////////////////////////////////////////////////
-(CCSpriteFrame*) displayedFrame {
    return [sprite_ displayedFrame];
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

//////////////////////////////////////////////////////////////////////////////////////////////
- (void)setAnchorPoint:(CGPoint)anchorPoint {
//    [super setAnchorPoint:anchorPoint];
    sprite_.anchorPoint = anchorPoint;
}


@end
