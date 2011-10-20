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
// A class that transforms a texture into a grid
//

#import "SDSFastGrid.h"

@interface SDSFastGrid(Private)
-(void)calculateVertexPoints;
-(void)updateTextureCoords:(CGRect)rect;
-(void)setTextureRectInPixels:(CGRect)rect rotated:(BOOL)rotated untrimmedSize:(CGSize)untrimmedSize;
-(void)setTextureRect:(CGRect)rect;
@end


@implementation SDSFastGrid

@synthesize sprite = sprite_;

//////////////////////////////////////////////////////////////////////////////////////////////
+ (id)gridWithTexture:(CCTexture2D*)texture {
	return [[[self alloc] initWithTexture:texture] autorelease];
}

//////////////////////////////////////////////////////////////////////////////////////////////
+(id)gridWithFile:(NSString*)fileName {
    CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:fileName];
    if (texture)
        return [SDSFastGrid gridWithTexture:texture];
    return nil;
}

//////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithTexture:(CCTexture2D*)texture {
	if ((self = [super init])) {
		self.texture = texture;
		sprite_ = [[CCSprite alloc] initWithTexture:texture];
        
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
	[sprite_ release];
	[texture_ release];
	[fastGrid_ release];
		
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
	if(fastGrid_ && fastGrid_.active) {
        
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

- (void)setPosition:(CGPoint)newPosition {
    [super setPosition:newPosition];
    sprite_.position = newPosition;
}

-(void) setOpacity:(GLubyte) anOpacity {
    sprite_.opacity = anOpacity;
}

-(GLubyte) opacity
{
	return sprite_.opacity;
}


// override "slow grid"
- (CCGridBase*)grid
{
	return fastGrid_;
}

- (void)setGrid:(CCGridBase*)grid
{
	[grid setIsTextureFlipped:YES];
	[fastGrid_ release];
	fastGrid_ = [grid retain];
	[fastGrid_ setTexture:texture_];
}

// set texture into fastgrid if a new texture is set
- (void)setTexture:(CCTexture2D*) texture
{
	[texture_ release];
	texture_ = [texture retain];
	[fastGrid_ setTexture:texture_];
}

- (CCTexture2D*)texture
{
	return texture_;
}



@end
