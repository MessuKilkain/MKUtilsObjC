//
//  UIView+Focus.m
//

#import "UIView+Focus.h"

@implementation UIView(Focus)

#if TARGET_OS_TV

#pragma mark - Closest

- (nullable UIView*)closestFocusableViewIncludingItself:(BOOL)includingItself fromView:(nonnull UIView*)fromView
{
    return [[self class] closestFocusableViewInView:self includingItself:includingItself fromView:fromView];
}

+ (nullable UIView*)closestFocusableViewInView:(nullable UIView *)view includingItself:(BOOL)includingItself fromView:(nonnull UIView*)fromView
{
    return [self closestFocusableViewInView:view includingItself:includingItself fromView:fromView currentDepth:0];
}
+ (nullable UIView*)closestFocusableViewInView:(nullable UIView *)view includingItself:(BOOL)includingItself fromView:(nonnull UIView*)fromView currentDepth:(NSUInteger)currentDepth
{
    if( view == nil )
    {
        return nil;
    }
    
    UIView* closestFocusableView = nil;
    // NOTE : undefined until closestFocusableSubview
    CGFloat closestSquaredDistance = 0.0;
    
    if(
       includingItself
       && ![view isHidden]
       && [view alpha] > 0
       && [view canBecomeFocused]
       )
    {
        closestFocusableView = [view preferredFocusedView];
        if( closestFocusableView != nil )
        {
            closestSquaredDistance = [self squaredDistanceBetweenViewA:closestFocusableView andViewB:fromView];
        }
    }
    
    // Get the subviews of the view
    NSArray<__kindof UIView*> *subviewsList = [view subviews];
    
    // Return if there are no subviews
    if ([subviewsList count] == 0)
    {
        return closestFocusableView;
    }
    
    if(
       closestFocusableView == nil
       && ![view isHidden]
       && [view alpha] > 0
       )
    {
        for( NSUInteger index = 0 ; index < [subviewsList count] ; index++ )
        {
            UIView* subview = [subviewsList objectAtIndex:index];
            if( subview != nil )
            {
                UIView* newClosestViewCandidate = [self closestFocusableViewInView:subview includingItself:YES fromView:fromView currentDepth:currentDepth+1];
                if( newClosestViewCandidate != nil )
                {
                    CGFloat newClosestDistanceCandidate = [self squaredDistanceBetweenViewA:newClosestViewCandidate andViewB:fromView];
                    if( closestFocusableView == nil )
                    {
                        closestFocusableView = newClosestViewCandidate;
                        closestSquaredDistance = newClosestDistanceCandidate;
                    }
                    else
                    {
                        if(
                           newClosestDistanceCandidate < closestSquaredDistance
                           || (
                               newClosestDistanceCandidate == closestSquaredDistance
                               && [self closestAxeAlignedDifferenceBetweenViewA:newClosestViewCandidate andViewB:fromView] < [self closestAxeAlignedDifferenceBetweenViewA:closestFocusableView andViewB:fromView]
                               )
                           )
                        {
                            closestFocusableView = newClosestViewCandidate;
                            closestSquaredDistance = newClosestDistanceCandidate;
                        }
                    }
                }
            }
        }
    }
    
    /*
    NSUInteger maxDepth = 100;
    if( currentDepth <= maxDepth )
    {
        UIView* viewForSearch = view;
        for( NSUInteger index = 0 ; index < currentDepth ; index++ )
        {
            viewForSearch = [viewForSearch superview];
        }
        CGPoint convertedCenter = [closestFocusableView convertPoint:[closestFocusableView centerInside] toView:nil];
        NSLog(@"\nforView : %@ \ncurrentDepth : %lu \nclosestFocusableView : %@ \nin %@ \ncenter : %@ \ndistance : %lf",[viewForSearch description],currentDepth,[closestFocusableView description], [view description],[NSString stringWithFormat:@"( x : %f ; y : %f )",convertedCenter.x,convertedCenter.y],closestSquaredDistance);
    }
    */
    
    return closestFocusableView;
}

+(CGFloat)squaredDistanceBetweenPointA:(CGPoint)pointA andPointB:(CGPoint)pointB
{
    CGFloat xDiff = pointA.x - pointB.x;
    CGFloat yDiff = pointA.y - pointB.y;
    return xDiff * xDiff + yDiff * yDiff;
}
+(CGFloat)squaredDistanceBetweenViewA:(nonnull UIView*)viewA andViewB:(nonnull UIView*)viewB
{
    CGPoint centerInsideA = [viewA centerInside];
    CGPoint centerInsideB = [viewB centerInside];
    CGPoint centerA = [viewA convertPoint:centerInsideA toView:nil];
    CGPoint centerB = [viewB convertPoint:centerInsideB toView:nil];
    CGFloat xDiff = centerA.x - centerB.x;
    CGFloat yDiff = centerA.y - centerB.y;
    // Abs
    xDiff = xDiff<0?-xDiff:xDiff;
    yDiff = yDiff<0?-yDiff:yDiff;
    // Substract the views half size to the difference
    xDiff = xDiff - ( centerInsideA.x + centerInsideB.x );
    yDiff = yDiff - ( centerInsideA.y + centerInsideB.y );
    // Make sure distance is not negative
    xDiff = xDiff<0?0:xDiff;
    yDiff = yDiff<0?0:yDiff;
    return xDiff * xDiff + yDiff * yDiff;
}
+(CGFloat)closestAxeAlignedDifferenceBetweenViewA:(nonnull UIView*)viewA andViewB:(nonnull UIView*)viewB
{
    CGPoint centerInsideA = [viewA centerInside];
    CGPoint centerInsideB = [viewB centerInside];
    CGPoint centerA = [viewA convertPoint:centerInsideA toView:nil];
    CGPoint centerB = [viewB convertPoint:centerInsideB toView:nil];
    CGFloat xDiff = centerA.x - centerB.x;
    CGFloat yDiff = centerA.y - centerB.y;
    // Abs
    xDiff = xDiff<0?-xDiff:xDiff;
    yDiff = yDiff<0?-yDiff:yDiff;
    return xDiff<yDiff?xDiff:yDiff;
}

-(CGPoint)centerInside
{
    return CGPointMake( [self bounds].size.width * 0.5, [self bounds].size.height * 0.5 );
}

#pragma mark - First

- (nullable UIView*)firstFocusableViewIncludingItself:(BOOL)includingItself
{
    return [[self class] firstFocusableViewInView:self includingItself:includingItself];
}

+ (nullable UIView*)firstFocusableViewInView:(nullable UIView *)view includingItself:(BOOL)includingItself
{
    if( view == nil )
    {
        return nil;
    }
    
    // Get the subviews of the view
    NSArray<__kindof UIView*> *subviewsList = [view subviews];
    
    // Return if there are no subviews
    if ([subviewsList count] == 0)
    {
        return nil;
    }
    
    UIView* firstFocusableSubview = nil;
    
    if(
       includingItself
       && ![view isHidden]
       && [view alpha] > 0
       && [view canBecomeFocused]
       )
    {
        firstFocusableSubview = view;
    }
    
    if(
       ![view isHidden]
       && [view alpha] > 0
       )
    {
        for( NSUInteger index = 0 ; index < [subviewsList count] && firstFocusableSubview == nil ; index++ )
        {
            UIView* subview = [subviewsList objectAtIndex:index];
            if( subview != nil )
            {
                firstFocusableSubview = [self firstFocusableViewInView:subview includingItself:YES];
            }
        }
    }
    
    return firstFocusableSubview;
}

#endif

@end
