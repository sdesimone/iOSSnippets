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

#import "cocos2d.h"

//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
@interface SDSFastGrid : CCNode
{
	CCTexture2D		*texture_;
    CCSpriteFrame   *frame_;

	CCSprite		*sprite_;
	CCGridBase		*fastGrid_;
    bool            shouldRecalcGridVertices;
    
    float           hscale_, vscale_, hOffset_, vOffset_;
}

/** texture used */
@property (nonatomic, readwrite, retain) CCTexture2D* texture;
@property (nonatomic, readwrite, retain) CCSprite* sprite;
@property (nonatomic, readonly) CCGridBase* fastGrid;
@property (nonatomic, readonly) bool isActive;
@property (nonatomic, readwrite) bool flipX;
@property (nonatomic, readwrite) bool flipY;


+ (id)gridWithFile:(NSString*)fileName;
+ (id)gridWithTexture:(CCTexture2D*)texture;
+ (id)gridWithSpriteFrame:(CCSpriteFrame*)frame;
+ (id)gridWithSpriteFrameName:(NSString*)frameName;

- (id)initWithSpriteFrameName:(NSString*)frameName;

+ (float)maxDimension:(float)x lessThanPOT:(float)max;

@end
