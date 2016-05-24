//
//  UIView+Focus.h
//

#import <UIKit/UIKit.h>

@interface UIView(Focus)

#if TARGET_OS_TV

#pragma mark - Closest

- (nullable UIView*)closestFocusableViewIncludingItself:(BOOL)includingItself fromView:(nonnull UIView*)fromView;

+ (nullable UIView*)closestFocusableViewInView:(nullable UIView *)view includingItself:(BOOL)includingItself fromView:(nonnull UIView*)fromView;

+ (CGFloat)squaredDistanceBetweenPointA:(CGPoint)pointA andPointB:(CGPoint)pointB;
+ (CGFloat)squaredDistanceBetweenViewA:(nonnull UIView*)viewA andViewB:(nonnull UIView*)viewB;
+ (CGFloat)closestAxeAlignedDifferenceBetweenViewA:(nonnull UIView*)viewA andViewB:(nonnull UIView*)viewB;

- (CGPoint)centerInside;

#pragma mark - First

- (nullable UIView*)firstFocusableViewIncludingItself:(BOOL)includingItself;

+ (nullable UIView*)firstFocusableViewInView:(nullable UIView *)view includingItself:(BOOL)includingItself;

#endif

@end
