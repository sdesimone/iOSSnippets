#import "CCOscillate.h"
#import <math.h>

//
// OscillateTo
//
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
@implementation CCOscillateTo

/////////////////////////////////////////////////////////////////////////////////////////
+ (id)actionWithDuration:(ccTime)t position:(CGPoint)dest passes:(NSUInteger)p damping:(float)dmp
{
    return [[[self alloc] initWithDuration:t position:dest passes:p damping:dmp] autorelease];
}

/////////////////////////////////////////////////////////////////////////////////////////
+ (id)actionWithPassesInterval:(ccTime)t position:(CGPoint)dest passes:(NSUInteger)p damping:(float)dmp
{
    return [[[self alloc] initWithPassesInterval:t position:dest passes:p damping:dmp] autorelease];
}

/////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDuration:(ccTime)t position:(CGPoint)dest passes:(NSUInteger)p damping:(float)dmp
{
    if ((self = [super initWithDuration:t]) == nil) return nil;
    
    passes = p;
    frequency = 0.5f * passes - 0.25f;
    damping = dmp;
    
    destination = dest;
    
    return self;
}

/////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithPassesInterval:(ccTime)t position:(CGPoint)dest passes:(NSUInteger)p damping:(float)dmp
{
    if ((self = [self initWithDuration:1.0f position:dest passes:p damping:dmp]) == nil) return nil;
    
    duration_ = (p - 0.5f) * t; // (p - 0.5) equals (2 * frequency)
    
    return self;
}

/////////////////////////////////////////////////////////////////////////////////////////
- (id)copyWithZone:(NSZone*)zone
{
    CCAction *copy = [[[self class] allocWithZone:zone] initWithDuration:duration_ position:destination passes:passes damping:damping];
    return copy;
}

/////////////////////////////////////////////////////////////////////////////////////////
-(void) startWithTarget:(CCNode *)aTarget
{
	[super startWithTarget:aTarget];
    if (damping < 0.0f) {
        fullAmplitude = ccpSub(destination, aTarget.position);
        pivot = aTarget.position;
    } else {
        fullAmplitude = ccpSub(aTarget.position, destination);
        pivot = destination;
    }
}

/////////////////////////////////////////////////////////////////////////////////////////
- (void)update:(ccTime)t
{
    float ratio;
    
    if (damping < 0.0f) {
        t = 1.0f - t;
        ratio = powf((1.0f - t), -damping);
    } else
        ratio = powf((1.0f - t), damping);
    
    CGPoint amplitude = ccpMult(fullAmplitude, ratio * cosf(2.0f * (float)M_PI * frequency * t));
    
    [target_ setPosition:ccpAdd(pivot, amplitude)];
}

@end


//
// OscillateBy
//
@implementation CCOscillateBy

/////////////////////////////////////////////////////////////////////////////////////////
+ (id)actionWithDuration:(ccTime)t position:(CGPoint)d passes:(NSUInteger)p damping:(float)dmp
{
    return [[[self alloc] initWithDuration:t position:d passes:p damping:dmp] autorelease];
}

/////////////////////////////////////////////////////////////////////////////////////////
+ (id)actionWithPassesInterval:(ccTime)t position:(CGPoint)d passes:(NSUInteger)p damping:(float)dmp
{
    return [[[self alloc] initWithPassesInterval:t position:d passes:p damping:dmp] autorelease];
}

/////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDuration:(ccTime)t position:(CGPoint)d passes:(NSUInteger)p damping:(float)dmp
{
    if ((self = [super initWithDuration:t position:CGPointZero passes:p damping:dmp]) == nil) return nil;
    
    delta = d;
    
    return self;
}

/////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithPassesInterval:(ccTime)t position:(CGPoint)d passes:(NSUInteger)p damping:(float)dmp
{
    if ((self = [super initWithPassesInterval:t position:CGPointZero passes:p damping:dmp]) == nil) return nil;
    
    delta = d;
    
    return self;
}

/////////////////////////////////////////////////////////////////////////////////////////
- (id)copyWithZone:(NSZone*)zone
{
    CCAction *copy = [[[self class] allocWithZone:zone] initWithDuration:duration_ position:destination passes:passes damping:damping];
    return copy;
}

/////////////////////////////////////////////////////////////////////////////////////////
-(void) startWithTarget:(CCNode *)aTarget
{
    destination = ccpAdd([aTarget position], delta);
	[super startWithTarget:aTarget];
}

/////////////////////////////////////////////////////////////////////////////////////////
- (CCActionInterval*)reverse
{
    return [[self class] actionWithDuration:duration_ position:ccpMult(delta, -1.0f) passes:passes damping:-damping];
}

@end
