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

#import "cocos2d.h"

/** Base class for other
 */
@interface SDSFastGrid : CCNode
{
	CCTexture2D		*texture_;

	CCSprite		*sprite_;
	CCGridBase		*fastGrid_;
    
    float           hscale_, vscale_, postOffset_;
}

/** texture used */
@property (nonatomic, readwrite, retain) CCTexture2D* texture;
@property (nonatomic, readwrite, retain) CCSprite* sprite;

/** creates and initializes a grid with a texture and a grid size */
+(id)gridWithTexture:(CCTexture2D*)texture;

+(id)gridWithFile:(NSString*)fileName;

/** initializes a grid with a texture and a grid size */
-(id)initWithTexture:(CCTexture2D*)texture;

+ (float)maxDimension:(float)x lessThanPOT:(float)max;

@end
