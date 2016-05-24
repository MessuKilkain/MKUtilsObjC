//
//  UIView+SimpleAnimations.m
//

#import "UIView+SimpleAnimations.h"

@implementation UIView(SimpleAnimations)

-(void)fadeInInTime:(NSTimeInterval)animationDuration completion:(void (^)(BOOL))completion
{
    __weak __typeof(self) weakSelf = self;
    [UIView
     animateWithDuration:animationDuration
     delay:0
     options:0
     animations:^{
         if( weakSelf != nil )
         {
             __strong __typeof(weakSelf) strongSelf = weakSelf;
             [strongSelf setAlpha:1.0];
         }
     }
     completion:^(BOOL finished) {
         if( completion != nil )
         {
             completion(finished);
         }
     }
     ];
}

-(void)fadeOutAndRemoveFromSuperviewInTime:(NSTimeInterval)animationDuration
{
    [self fadeOutAndRemoveFromSuperviewInTime:animationDuration withDelay:0];
}
-(void)fadeOutAndRemoveFromSuperviewInTime:(NSTimeInterval)animationDuration withDelay:(NSTimeInterval)delay
{
    __weak __typeof(self) weakSelf = self;
    [UIView
     animateWithDuration:animationDuration
     delay:delay
     options:0
     animations:^{
         if( weakSelf != nil )
         {
             __strong __typeof(weakSelf) strongSelf = weakSelf;
             [strongSelf setAlpha:0.0];
         }
     }
     completion:^(BOOL finished) {
         if( weakSelf != nil )
         {
             __strong __typeof(weakSelf) strongSelf = weakSelf;
             [strongSelf removeFromSuperview];
         }
     }
     ];
}

@end
