//
//  ConfigurableButton.m
//  Based on the example provided on http://stackoverflow.com/a/32677639/4602597
//

#import "ConfigurableButton.h"

@implementation ConfigurableButton

//Sets one of the font properties, depending on which state was passed
- (void) setFont:(UIFont *)font forState:(UIControlState)state
{
    switch (state) {
        case UIControlStateNormal:
        {
            self.normalFont = font;
            break;
        }
            
        case UIControlStateHighlighted:
        {
            self.highlightedFont = font;
            break;
        }
            
        case UIControlStateDisabled:
        {
            self.disabledFont = font;
            break;
        }
            
        case UIControlStateSelected:
        {
            self.selectedFont = font;
            break;
        }
            
        case UIControlStateFocused:
        {
            self.focusedFont = font;
            break;
        }
            
        case UIControlStateApplication:
        {
            self.applicationFont = font;
            break;
        }
            
        case UIControlStateReserved:
        {
            self.reservedFont = font;
            break;
        }
            
        default:
        {
            self.normalFont = font;
            break;
        }
    }
    
    if (state==self.state||state==UIControlStateNormal) {
        [self setNeedsLayout];
    }
}

//-(void)setBackgroundColor:(UIColor *)backgroundColor
//{
//    [super setBackgroundColor:backgroundColor];
//    [self setNormalBackgroundColor:backgroundColor];
//}

- (void) setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    switch (state) {
        case UIControlStateNormal:
        {
            self.normalBackgroundColor = backgroundColor;
            break;
        }
            
        case UIControlStateHighlighted:
        {
            self.highlightedBackgroundColor = backgroundColor;
            break;
        }
            
        case UIControlStateDisabled:
        {
            self.disabledBackgroundColor = backgroundColor;
            break;
        }
            
        case UIControlStateSelected:
        {
            self.selectedBackgroundColor = backgroundColor;
            break;
        }
            
        case UIControlStateFocused:
        {
            self.focusedBackgroundColor = backgroundColor;
            break;
        }
            
        case UIControlStateApplication:
        {
            self.applicationBackgroundColor = backgroundColor;
            break;
        }
            
        case UIControlStateReserved:
        {
            self.reservedBackgroundColor = backgroundColor;
            break;
        }
            
        default:
        {
            self.normalBackgroundColor = backgroundColor;
            break;
        }
    }
    
    if (state==self.state||state==UIControlStateNormal) {
        [self setNeedsLayout];
    }
}

#pragma mark - Overrides

/**
 * Overrides layoutSubviews in UIView, to set the font for the button's state,
 * before calling [super layoutSubviews].
 */
- (void) layoutSubviews
{
    [self updateToControlState];
    [super layoutSubviews];
}

-(void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator
{
    [super didUpdateFocusInContext:context withAnimationCoordinator:coordinator];
    if(
       context != nil
       && (
           [context previouslyFocusedView] == self
           || [context nextFocusedView] == self
           )
       )
    {
        [self setNeedsLayout];
    }
}

#pragma mark - Update UI to Control State

-(void)updateToControlState
{
    
    NSUInteger state = self.state;
    
    UIFont* newFont = nil;
    UIColor* newBackgroundColor = nil;
    switch (state) {
        case UIControlStateNormal:
        {
            newFont = _normalFont;
            newBackgroundColor = _normalBackgroundColor;
            break;
        }
            
        case UIControlStateHighlighted:
        {
            newFont = _highlightedFont;
            newBackgroundColor = _highlightedBackgroundColor;
            break;
        }
            
        case UIControlStateDisabled:
        {
            newFont = _disabledFont;
            newBackgroundColor = _disabledBackgroundColor;
            break;
        }
            
        case UIControlStateSelected:
        {
            newFont = _selectedFont;
            newBackgroundColor = _selectedBackgroundColor;
            break;
        }
            
        case UIControlStateFocused:
        {
            newFont = _focusedFont;
            newBackgroundColor = _focusedBackgroundColor;
            break;
        }
            
        case UIControlStateApplication:
        {
            newFont = _applicationFont;
            newBackgroundColor = _applicationBackgroundColor;
            break;
        }
            
        case UIControlStateReserved:
        {
            newFont = _reservedFont;
            newBackgroundColor = _reservedBackgroundColor;
            break;
        }
            
        default:
        {
            newFont = _normalFont;
            newBackgroundColor = _normalBackgroundColor;
            break;
        }
    }
    
    {
        if (!newBackgroundColor) {
            newBackgroundColor = _normalBackgroundColor;
        }
        if (!newBackgroundColor) {
            newBackgroundColor = [UIColor clearColor];
        }
        if (newBackgroundColor)
        {
            [self setBackgroundColor:newBackgroundColor];
        }
    }

    if ([self titleLabel]) {
        if (!newFont) {
            newFont = _normalFont;
        }
        if (!newFont) {
            newFont = [UIFont systemFontOfSize:15];
        }
        self.titleLabel.font = newFont;
    }
}

@end
