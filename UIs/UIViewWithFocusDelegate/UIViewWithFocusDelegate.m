//
//  UIViewWithFocusDelegate.m
//

#import "UIViewWithFocusDelegate.h"

@implementation UIViewWithFocusDelegate

-(BOOL)canBecomeFocused
{
    BOOL canBecomeFocused = [super canBecomeFocused];
    if(
       [self focusDelegate] != nil
       && [[self focusDelegate] respondsToSelector:@selector(canBecomeFocusedForView:withSuperValue:)]
       )
    {
        canBecomeFocused = [[self focusDelegate] canBecomeFocusedForView:self withSuperValue:canBecomeFocused];
    }
    return canBecomeFocused;
}

-(void)setNeedsFocusUpdate
{
    [super setNeedsFocusUpdate];
    if(
       [self focusDelegate] != nil
       && [[self focusDelegate] respondsToSelector:@selector(setNeedsFocusUpdateForView:)]
       )
    {
        [[self focusDelegate] setNeedsFocusUpdateForView:self];
    }
}

-(void)updateFocusIfNeeded
{
    [super updateFocusIfNeeded];
    if(
       [self focusDelegate] != nil
       && [[self focusDelegate] respondsToSelector:@selector(updateFocusIfNeededForView:)]
       )
    {
        [[self focusDelegate] updateFocusIfNeededForView:self];
    }
}

-(BOOL)shouldUpdateFocusInContext:(UIFocusUpdateContext *)context
{
    BOOL shouldUpdateFocusInContext = [super shouldUpdateFocusInContext:context];
    if(
       [self focusDelegate] != nil
       && [[self focusDelegate] respondsToSelector:@selector(shouldUpdateFocusInContext:forView:withSuperValue:)]
       )
    {
        shouldUpdateFocusInContext = [[self focusDelegate] shouldUpdateFocusInContext:context forView:self withSuperValue:shouldUpdateFocusInContext];
    }
    return shouldUpdateFocusInContext;
}

-(void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator
{
    [super didUpdateFocusInContext:context withAnimationCoordinator:coordinator];
    if(
       [self focusDelegate] != nil
       && [[self focusDelegate] respondsToSelector:@selector(didUpdateFocusInContext:withAnimationCoordinator:forView:)]
       )
    {
        [[self focusDelegate] didUpdateFocusInContext:context withAnimationCoordinator:coordinator forView:self];
    }
}

-(UIView *)preferredFocusedView
{
    UIView* preferredFocusedView = [super preferredFocusedView];
    if(
       [self focusDelegate] != nil
       && [[self focusDelegate] respondsToSelector:@selector(preferredFocusedViewForView:withSuperValue:)]
       )
    {
        preferredFocusedView = [[self focusDelegate] preferredFocusedViewForView:self withSuperValue:preferredFocusedView];
    }
    return preferredFocusedView;
}

@end
