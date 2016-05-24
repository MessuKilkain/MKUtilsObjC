//
//  UIView+SimpleAnimations.h
//

#import <UIKit/UIKit.h>

@interface UIView(SimpleAnimations)

-(void)fadeInInTime:(NSTimeInterval)animationDuration completion:(void (^ __nullable)(BOOL finished))completion;

-(void)fadeOutAndRemoveFromSuperviewInTime:(NSTimeInterval)animationDuration;
-(void)fadeOutAndRemoveFromSuperviewInTime:(NSTimeInterval)animationDuration withDelay:(NSTimeInterval)delay;

@end
