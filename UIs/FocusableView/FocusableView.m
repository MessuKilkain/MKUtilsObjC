//
//  FocusableView.m
//

#import "FocusableView.h"

#import "UIView+Focus.h"

@interface FocusableView ()

@property (nonatomic,weak) UIView* internalPreferredFocusedView;

@end

@implementation FocusableView

#pragma mark - Init methods

-(instancetype)init
{
    self = [super init];
    if( self )
    {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( self )
    {
        [self commonInit];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInit];
}

-(void)commonInit
{
    [self setPreventRestoreLastFocusedView:YES];
}


#pragma mark - Focus methods

#if TARGET_OS_TV

-(BOOL)canBecomeFocused
{
    BOOL canBecomeFocused = NO;
    if( [self preferredFocusedView] != nil )
    {
        UIView* focusedView = [[UIScreen mainScreen] focusedView];
        if(
           focusedView == nil
           || ![focusedView isDescendantOfView:self]
           )
        {
            canBecomeFocused = YES;
        }
    }
    return canBecomeFocused;
}

-(UIView *)preferredFocusedView
{
    if(
       [self preventRestoreLastFocusedView]
       || [self internalPreferredFocusedView] == nil
       || ![[self internalPreferredFocusedView] canBecomeFocused]
       || [[self internalPreferredFocusedView] isHidden]
       || [[self internalPreferredFocusedView] alpha] <= 0
       )
    {
        UIView* focusedView = [[UIScreen mainScreen] focusedView];
        if( focusedView != nil )
        {
            [self setInternalPreferredFocusedView:[self closestFocusableViewIncludingItself:NO fromView:focusedView]];
        }
        else
        {
            [self setInternalPreferredFocusedView:[self firstFocusableViewIncludingItself:NO]];
        }
    }
    return [self internalPreferredFocusedView];
}

-(void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator
{
    [super didUpdateFocusInContext:context withAnimationCoordinator:coordinator];
    if(
       context != nil
       && (
           [context previouslyFocusedView] != nil
           && [[context previouslyFocusedView] isDescendantOfView:self]
           )
       && (
           [context nextFocusedView] == nil
           || ![[context nextFocusedView] isDescendantOfView:self]
           )
       )
    {
        [self setInternalPreferredFocusedView:[context previouslyFocusedView]];
    }
}

#endif

@end
