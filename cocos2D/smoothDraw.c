/////////////////////////////////////////
// Antialiased OpenGL line drawing with Cocos2D
// based on http://www.cocos2d-iphone.org/forum/topic/21734
/////////////////////////////////////////

#import "cocos2d.h"

/////////////////////////////////////////
void ccDrawSmoothLine(CGPoint pos1, CGPoint pos2, float width)
{
    GLfloat lineVertices[12], curc[4];
    GLint   ir, ig, ib, ia;
    CGPoint dir, tan;

	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states: GL_VERTEX_ARRAY,
	// Unneeded states: GL_TEXTURE_2D, GL_TEXTURE_COORD_ARRAY, GL_COLOR_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);

	//glEnable(GL_LINE_SMOOTH);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	pos1.x *= CC_CONTENT_SCALE_FACTOR();
	pos1.y *= CC_CONTENT_SCALE_FACTOR();
	pos2.x *= CC_CONTENT_SCALE_FACTOR();
	pos2.y *= CC_CONTENT_SCALE_FACTOR();
	width *= CC_CONTENT_SCALE_FACTOR();

    width = width*8;
    dir.x = pos2.x - pos1.x;
    dir.y = pos2.y - pos1.y;
    float len = sqrtf(dir.x*dir.x+dir.y*dir.y);
    if(len<0.00001)
        return;
    dir.x = dir.x/len;
    dir.y = dir.y/len;
    tan.x = -width*dir.y;
    tan.y = width*dir.x;

    lineVertices[0] = pos1.x + tan.x;
    lineVertices[1] = pos1.y + tan.y;
    lineVertices[2] = pos2.x + tan.x;
    lineVertices[3] = pos2.y + tan.y;
    lineVertices[4] = pos1.x;
    lineVertices[5] = pos1.y;
    lineVertices[6] = pos2.x;
    lineVertices[7] = pos2.y;
    lineVertices[8] = pos1.x - tan.x;
    lineVertices[9] = pos1.y - tan.y;
    lineVertices[10] = pos2.x - tan.x;
    lineVertices[11] = pos2.y - tan.y;

    glGetFloatv(GL_CURRENT_COLOR,curc);
    ir = 255.0*curc[0];
    ig = 255.0*curc[1];
    ib = 255.0*curc[2];
    ia = 255.0*curc[3];

    const GLubyte lineColors[] = {
        ir, ig, ib, 0,
        ir, ig, ib, 0,
        ir, ig, ib, ia,
        ir, ig, ib, ia,
        ir, ig, ib, 0,
        ir, ig, ib, 0,
    };

    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, lineVertices);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, lineColors);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 6);
    glDisableClientState(GL_COLOR_ARRAY);

	// restore default state
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
}

/////////////////////////////////////////
void ccDrawSmoothPoint(CGPoint pos, float width)
{
    GLfloat pntVertices[12], curc[4];
    GLint   ir, ig, ib, ia;

	pos.x *= CC_CONTENT_SCALE_FACTOR();
	pos.y *= CC_CONTENT_SCALE_FACTOR();
	width *= CC_CONTENT_SCALE_FACTOR();

	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states: GL_VERTEX_ARRAY,
	// Unneeded states: GL_TEXTURE_2D, GL_TEXTURE_COORD_ARRAY, GL_COLOR_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);

	//glEnable(GL_LINE_SMOOTH);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    pntVertices[0] = pos.x;
    pntVertices[1] = pos.y;
    pntVertices[2] = pos.x - width;
    pntVertices[3] = pos.y - width;
    pntVertices[4] = pos.x - width;
    pntVertices[5] = pos.y + width;
    pntVertices[6] = pos.x + width;
    pntVertices[7] = pos.y + width;
    pntVertices[8] = pos.x + width;
    pntVertices[9] = pos.y - width;
    pntVertices[10] = pos.x - width;
    pntVertices[11] = pos.y - width;

    glGetFloatv(GL_CURRENT_COLOR,curc);
    ir = 255.0*curc[0];
    ig = 255.0*curc[1];
    ib = 255.0*curc[2];
    ia = 255.0*curc[3];

    const GLubyte pntColors[] = {
        ir, ig, ib, ia,
        ir, ig, ib, 0,
        ir, ig, ib, 0,
        ir, ig, ib, 0,
        ir, ig, ib, 0,
        ir, ig, ib, 0,
    };

    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, pntVertices);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, pntColors);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 6);
    glDisableClientState(GL_COLOR_ARRAY);

	// restore default state
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
}

/////////////////////////////////////////
void ccDrawLineWidth(CGPoint pt1, CGPoint pt2, unsigned int width, BOOL smooth) {
	GLfloat curc[4];
	glGetFloatv(GL_CURRENT_COLOR,curc);

	width *= CC_CONTENT_SCALE_FACTOR();

	if (smooth) {
		//glEnable(GL_LINE_SMOOTH);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	}

	float distance = 0.5f;
	float angle = findAngle(pt1, pt2);

	if (width > 1) {
		for (unsigned int i=0; i < width; i++) {
			if (smooth) glColor4f(curc[0], curc[1], curc[2], curc[3] * (((width - i + 2.0f) * 100.0f)/(width + 2.0f) / 100.0f));
			CGPoint pt1_1 = findPoint(pt1, angle + 90, (i*distance) + distance);
			CGPoint pt2_1 = findPoint(pt2, angle + 90, (i*distance) + distance);
			ccDrawLine(pt1_1, pt2_1);
		}
	}

	glColor4f(curc[0], curc[1], curc[2], curc[3]);
	ccDrawLine(pt1, pt2); 

	if (width > 1) {
		for (unsigned int i=0; i < width; i++) {
			if (smooth) glColor4f(curc[0], curc[1], curc[2], curc[3] * (((width - i + 2.0f) * 100.0f)/(width + 2.0f) / 100.0f));
			CGPoint pt1_2 = findPoint(pt1, angle - 90, (i*distance) + distance);
			CGPoint pt2_2 = findPoint(pt2, angle - 90, (i*distance) + distance);
			ccDrawLine(pt1_2, pt2_2);
		}
	}

}

/////////////////////////////////////////
void ccDrawDashedLine(CGPoint origin, CGPoint destination, float dashLength)
{
	origin.x *= CC_CONTENT_SCALE_FACTOR();
	origin.y *= CC_CONTENT_SCALE_FACTOR();
	destination.x *= CC_CONTENT_SCALE_FACTOR();
	destination.y *= CC_CONTENT_SCALE_FACTOR();
	dashLength *= CC_CONTENT_SCALE_FACTOR();

	float dx = destination.x - origin.x;
	float dy = destination.y - origin.y;
	float dist = sqrtf(dx * dx + dy * dy);
	float x = dx / dist * dashLength;
	float y = dy / dist * dashLength;

	CGPoint p1 = origin;
	NSUInteger segments = (int)(dist / dashLength);
	NSUInteger lines = (int)((float)segments / 2.0);

	CGPoint *vertices = malloc(sizeof(CGPoint) * segments);
	for(int i = 0; i < lines; i++)
	{
		vertices[i*2] = p1;
		p1 = CGPointMake(p1.x + x, p1.y + y);
		vertices[i*2+1] = p1;
		p1 = CGPointMake(p1.x + x, p1.y + y);
	}

	/*
	glEnableClientState(GL_VERTEX_ARRAY);
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glDrawArrays(GL_LINES, 0, segments);
	glDisableClientState(GL_VERTEX_ARRAY);
	*/

	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);

	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glDrawArrays(GL_LINES, 0, segments);

	// restore default state
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);

	free(vertices);
}

