#import "cocos2d.h"

/** This action can be used to simulate spring-like motion on CocosNodes.
 You get significant control over how the "spring" works. You can set oscillation
 duration, the point around which to oscillate, the number of times the CocosNode will
 pass over this point, and a damping factor.
 
 It works somewhat like a damped harmonic oscillator ('passes' gives the oscillation
 frequency and correlates to k, 'damping' correlates to b). 
 
 Behavior is dictated by damping:
 
 * if damping >= 0, you get spring-like behavior as described above. The CocosNode oscillates
 around the given destination, gradually slowing down until it stops in the center.
 (i.e. go around the destination, towards the destination)
 
 * if damping < 0, you get the reverse. The CocosNode oscillates around its initial position,
 gradually speeding up until it reaches the destination, where it abruptly stops.
 (i.e. go around the initial position, towards the destination)
 */

@interface CCOscillateTo : CCActionInterval <NSCopying>
{
    CGPoint destination;
    NSUInteger passes;
    float damping;
@private
    float frequency;
    CGPoint pivot, fullAmplitude;
}
+ (id)actionWithDuration:(ccTime)t position:(CGPoint)destination passes:(NSUInteger)passes damping:(float)damping;
+ (id)actionWithPassesInterval:(ccTime)t position:(CGPoint)destination passes:(NSUInteger)passes damping:(float)damping;

- (id)initWithDuration:(ccTime)t position:(CGPoint)destination passes:(NSUInteger)passes damping:(float)damping;
/** Sets duration implicitly according to number & interval between passes */
- (id)initWithPassesInterval:(ccTime)t position:(CGPoint)destination passes:(NSUInteger)passes damping:(float)damping;
@end


@interface CCOscillateBy : CCOscillateTo
{
@private
    CGPoint delta;
}
+ (id)actionWithDuration:(ccTime)t position:(CGPoint)delta passes:(NSUInteger)passes damping:(float)damping;
+ (id)actionWithPassesInterval:(ccTime)t position:(CGPoint)delta passes:(NSUInteger)passes damping:(float)damping;

- (id)initWithDuration:(ccTime)t position:(CGPoint)delta passes:(NSUInteger)passes damping:(float)damping;
- (id)initWithPassesInterval:(ccTime)t position:(CGPoint)delta passes:(NSUInteger)passes damping:(float)damping;
@end