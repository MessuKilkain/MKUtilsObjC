//
//  PassingTextView.m
//

#import "PassingTextView.h"

#import "UIView+AutoLayout.h"
#import "NSString+Empty.h"

@interface PassingTextView()

#pragma mark - Subview
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint*>* textLabels_VerticalAlignmentConstraints; // This value is not currently used in reading

@property (nonatomic, weak) UILabel* staticTitleTextLabel;
@property (nonatomic, strong) NSArray<NSLayoutConstraint*>* staticTitleTextLabel_Constraints; // This value is not currently used in reading

@property (nonatomic, weak) UILabel* passingTitleTextLabel;
@property (nonatomic, weak) NSLayoutConstraint* passingTitleTextLabel_LeftConstraint;

#pragma mark - Data
@property (nonatomic) NSString* internalTitleText;
@property (nonatomic) CGFloat titleTextExpectedWidth;
@property (nonatomic) CGFloat titleTextStaticMaxWidth;

@property (nonatomic) NSString* internalTitleTextForPassingLabel;
@property (nonatomic) NSDate* passingAnimationLastStartedDate;

@property (nonatomic) BOOL titleTextPassingShouldStartWithoutDelay;
@property (nonatomic) BOOL passingTitleText_ShouldBeAnimated;
@property (nonatomic) BOOL passingTitleText_Animating;

@end

@implementation PassingTextView

#pragma mark - Simulated properties

-(void)setFont:(UIFont*)newFont
{
    if( newFont != nil )
    {
        [self buildViewIfNecessary];
        if( [self staticTitleTextLabel] != nil )
        {
            [[self staticTitleTextLabel] setFont:newFont];
        }
        if( [self passingTitleTextLabel] != nil )
        {
            [[self passingTitleTextLabel] setFont:newFont];
        }
    }
}
-(UIFont*)font
{
    [self buildViewIfNecessary];
    if( [self staticTitleTextLabel] != nil )
    {
        return [[self staticTitleTextLabel] font];
    }
    else
    {
        return nil;
    }
}
-(void)setTextColor:(UIColor*)newTextColor
{
    if( newTextColor != nil )
    {
        [self buildViewIfNecessary];
        if( [self staticTitleTextLabel] != nil )
        {
            [[self staticTitleTextLabel] setTextColor:newTextColor];
        }
        if( [self passingTitleTextLabel] != nil )
        {
            [[self passingTitleTextLabel] setTextColor:newTextColor];
        }
    }
}
-(UIColor*)textColor
{
    [self buildViewIfNecessary];
    if( [self staticTitleTextLabel] != nil )
    {
        return [[self staticTitleTextLabel] textColor];
    }
    else
    {
        return nil;
    }
}
-(void)setStaticTextAlignment:(NSTextAlignment)newTextAlignment
{
    [self buildViewIfNecessary];
    if( [self staticTitleTextLabel] != nil )
    {
        [[self staticTitleTextLabel] setTextAlignment:newTextAlignment];
    }
}
// TODO LATER : find a way to restore the animation when application comes to foreground

#pragma mark - Life cycle override

// NOTE : override of this method provide the view with the ability to restore or stop the animation if necessary
-(void)layoutSubviews
{
    [super layoutSubviews];
    // We call setTitleText to restart the animation if necessary
    [self setTitleText:[self titleText]];
}

#pragma mark - Building methods

-(void)buildViewIfNecessary
{
    BOOL shouldLayout = NO;
    if( [self textLabels_VerticalAlignmentConstraints] == nil )
    {
        [self setTextLabels_VerticalAlignmentConstraints:[NSMutableArray array]];
    }
    if( [self staticTitleTextLabel] == nil )
    {
        shouldLayout = YES;
        UILabel* staticTitleTextLabel = [[UILabel alloc] init];
        [staticTitleTextLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:staticTitleTextLabel];
        [self setStaticTitleTextLabel_Constraints:[staticTitleTextLabel pinToSuperviewEdges:JRTViewPinLeftEdge|JRTViewPinRightEdge inset:0]];
        {
            NSLayoutConstraint* verticalConstraint = [NSLayoutConstraint constraintWithItem:staticTitleTextLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
            [self addConstraint:verticalConstraint];
            [[self textLabels_VerticalAlignmentConstraints] addObject:verticalConstraint];
        }
        [self setStaticTitleTextLabel:staticTitleTextLabel];
    }
    if( [self passingTitleTextLabel] == nil )
    {
        shouldLayout = YES;
        UILabel* passingTitleTextLabel = [[UILabel alloc] init];
        [passingTitleTextLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:passingTitleTextLabel];
        {
            NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:passingTitleTextLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
            [self addConstraint:leftConstraint];
            [self setPassingTitleTextLabel_LeftConstraint:leftConstraint];
        }
        {
            NSLayoutConstraint* verticalConstraint = [NSLayoutConstraint constraintWithItem:passingTitleTextLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
            [self addConstraint:verticalConstraint];
            [[self textLabels_VerticalAlignmentConstraints] addObject:verticalConstraint];
        }
        [self setPassingTitleTextLabel:passingTitleTextLabel];
    }
    if( shouldLayout )
    {
        // NSLog(@"Set need layout");
        // [self setNeedsLayout]; // NOTE : seems unnecessary
    }
}

#pragma mark - Title Text

-(NSString*)titleText
{
    return [self internalTitleText];
}

-(void)setTitleText:(NSString*)newTitleText
{
    // NSLog(@"newTitleText : %@",newTitleText);
    
    [self setInternalTitleText:newTitleText];
    
    BOOL shouldUsePassingText = [self checkShouldBeAnimated];
    
    if( shouldUsePassingText )
    {
        // NOTE : WARNING : This line and this animation makes the application to have a lot of weird behaviour on animations (check back before looking elsewhere if a new animation bug appear)
        [self setPassingTitleText:newTitleText];
    }
    else
    {
        [self setStaticTitleText:newTitleText];
    }
}

#pragma mark - Static text

-(void)setStaticTitleText:(NSString*)newTitleText
{
    [self buildViewIfNecessary];
    if( [self staticTitleTextLabel] )
    {
        [[self staticTitleTextLabel] setHidden:NO];
        [[self staticTitleTextLabel] setText:newTitleText];
    }
    if( [self passingTitleTextLabel] )
    {
        [[self passingTitleTextLabel] setHidden:YES];
    }
//    [self setNeedsLayout]; // NOTE : seems unnecessary
    [self stopPassingTextAnimationIfNeeded];
}

#pragma mark - Animated text

-(BOOL)checkShouldBeAnimated
{
    [self buildViewIfNecessary];
    BOOL shouldUsePassingText = NO;
    if(
       [self staticTitleTextLabel]
       && ![NSString isNilOrEmptyString:[self titleText]]
       )
    {
        CGSize textSize = [[self titleText] sizeWithAttributes:@{NSFontAttributeName:[[self staticTitleTextLabel] font]}];
        [self setTitleTextExpectedWidth:textSize.width];
        [self setTitleTextStaticMaxWidth:[self frame].size.width];
        shouldUsePassingText = [self titleTextExpectedWidth] > [self titleTextStaticMaxWidth];
    }
    return shouldUsePassingText;
}
 // NOTE : seems unnecessary
-(void)setPassingTitleText:(NSString*)newTitleText
{
    [self buildViewIfNecessary];
    // shouldRestartAnimation prevent the animation to restart when the text has not changed
    BOOL shouldRestartAnimation = YES;
    if( [self staticTitleTextLabel] != nil )
    {
        [[self staticTitleTextLabel] setText:newTitleText];
    }
    if( [self passingTitleTextLabel] != nil )
    {
        NSString* oldString = [[self passingTitleTextLabel] text];
        NSString* newString = [NSString stringWithFormat:@"%1$@ - %1$@ - ",newTitleText];
        if(
           oldString != nil
           && newString != nil
           && [oldString isEqualToString:newString]
           && [self passingTitleText_ShouldBeAnimated]
           )
        {
            shouldRestartAnimation = NO;
        }
        [self setInternalTitleTextForPassingLabel:newString];
    }
    
    if( shouldRestartAnimation )
    {
        // titleTextPassingShouldStartWithoutDelay = YES;
        [self startPassingTextAnimationIfNeeded];
    }
}
-(void)startPassingTextAnimationIfNeeded
{
    __weak __typeof( self ) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if( weakSelf != nil )
        {
            __strong __typeof( weakSelf ) strongSelf = weakSelf;
            [[strongSelf staticTitleTextLabel] setHidden:YES];
            [[strongSelf passingTitleTextLabel] setText:[strongSelf internalTitleTextForPassingLabel]];
            [[strongSelf passingTitleTextLabel] setHidden:NO];
            [strongSelf setPassingTitleText_ShouldBeAnimated:YES];
            [strongSelf animatePassingTextIfPossibleForced:YES];
        }
    });
}

-(void)animatePassingTextIfPossibleForced:(BOOL)forced
{
    if( ![self passingTitleText_Animating] || forced )
    {
        [self setPassingTitleText_Animating:YES];
        
        if(
           [self passingTitleTextLabel] != nil
           && [[self passingTitleTextLabel] layer] != nil
           )
        {
            [[[self passingTitleTextLabel] layer] removeAllAnimations];
        }
        NSDate* startedDate = [NSDate date];
        [self setPassingAnimationLastStartedDate:startedDate];
        
        // NOTE : The animation duration is calculated from the width of text to display and the space/width available
        // This is done in order to keep a constant speed no matter which text is displayed
        NSTimeInterval expectedDurationForOneWidth = ( [self expectedDurationForOneWidth] >= 0.1 ? [self expectedDurationForOneWidth] : 0.1 );
        NSTimeInterval totalDuration = expectedDurationForOneWidth * ( [self titleTextExpectedWidth] / ( [self titleTextStaticMaxWidth] > 0 ? [self titleTextStaticMaxWidth] : 1.0 ) );
        NSTimeInterval delayForAnimation = [self delayForAnimation];
        if( [self titleTextPassingShouldStartWithoutDelay] )
        {
            delayForAnimation = 0.0;
            [self setTitleTextPassingShouldStartWithoutDelay:NO];
        }
        CGFloat moveSize = [self titleTextStaticMaxWidth];
        if( [self passingTitleTextLabel] != nil )
        {
            moveSize = 0.5 * [[[self passingTitleTextLabel] text] sizeWithAttributes:@{NSFontAttributeName:[[self passingTitleTextLabel] font]}].width;
        }
        
        if( [self passingTitleTextLabel_LeftConstraint] != nil )
        {
            if( [[self passingTitleTextLabel_LeftConstraint] constant] != 0 )
            {
                [[self passingTitleTextLabel_LeftConstraint] setConstant:0];
//                [self setNeedsLayout]; // NOTE : seems unnecessary
            }
        }
        if(
           [self passingTitleTextLabel] != nil
           )
        {
            CGPoint center = [[self passingTitleTextLabel] center];
            center.x = moveSize;
            [[self passingTitleTextLabel] setCenter:center];
            // NSLog(@"[[self passingTitleTextLabel] frame] : %@",[Tools stringFromCGRect:[[self passingTitleTextLabel] frame]]);
        }
        
        // NSLog(@"totalDuration : %lf",totalDuration);
        __weak __typeof( self ) weakSelf = self;
        [UIView animateWithDuration:totalDuration
                              delay:delayForAnimation
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             if( weakSelf != nil )
                             {
                                 __strong __typeof( weakSelf ) strongSelf = weakSelf;
                                 if( [strongSelf passingTitleTextLabel_LeftConstraint] != nil )
                                 {
                                     [[strongSelf passingTitleTextLabel_LeftConstraint] setConstant:-moveSize];
//                                     [strongSelf setNeedsLayout]; // NOTE : seems unnecessary
                                 }
                                 if( [strongSelf passingTitleTextLabel] != nil )
                                 {
                                     CGPoint center = [[strongSelf passingTitleTextLabel] center];
                                     center.x = 0;
                                     [[strongSelf passingTitleTextLabel] setCenter:center];
                                 }
                             }
                         }
                         completion:^(BOOL finished){
                             if( finished )
                             {
                                 if( weakSelf != nil )
                                 {
                                     __strong __typeof( weakSelf ) strongSelf = weakSelf;
                                     if( [strongSelf passingAnimationLastStartedDate] == startedDate )
                                     {
                                         [strongSelf setPassingTitleText_Animating:NO];
                                         // NSLog(@"[[strongSelf passingTitleTextLabel] frame] : %@",[Tools stringFromCGRect:[[strongSelf passingTitleTextLabel] frame]]);
                                         // NSLog(@"moveSize : %lf",moveSize);
                                         [strongSelf setPassingTitleText_ShouldBeAnimated:[strongSelf checkShouldBeAnimated]];
                                         if( [strongSelf passingTitleText_ShouldBeAnimated] )
                                         {
                                             // NSLog(@"Restart passing text animation");
                                             [strongSelf animatePassingTextIfPossibleForced:NO];
                                         }
                                         else
                                         {
                                             [strongSelf setTitleText:[strongSelf internalTitleText]];
                                             // NSLog(@"Stop passing text animation");
                                         }
                                     }
                                 }
                             }
                         }];
    }
}
-(void)stopPassingTextAnimationIfNeeded
{
    [self setPassingTitleText_ShouldBeAnimated:NO];
}

@end
