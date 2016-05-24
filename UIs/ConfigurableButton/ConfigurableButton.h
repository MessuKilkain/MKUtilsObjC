//
//  ConfigurableButton.h
//  Based on the example provided on http://stackoverflow.com/a/32677639/4602597
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

/**
 * A button that allows fonts to be assigned to each of the button's states.
 *
 * A state font can be specified using setFont:forState, or through one of the
 * four state Font properties.
 *
 * If a font is not specified for a given state, then
 * the NormalFont will be used.
 * If a normal font is not specified for a normal state or as a fallback, then
 * the System font will be displayed with a font size of 15.
 */
@interface ConfigurableButton : UIButton

@property (strong, nonatomic) UIFont *normalFont;
@property (strong, nonatomic) UIFont *highlightedFont;
@property (strong, nonatomic) UIFont *selectedFont;
@property (strong, nonatomic) UIFont *disabledFont;
@property (strong, nonatomic) UIFont *focusedFont;
@property (strong, nonatomic) UIFont *applicationFont;
@property (strong, nonatomic) UIFont *reservedFont;

@property (strong, nonatomic) UIColor *normalBackgroundColor;
@property (strong, nonatomic) UIColor *highlightedBackgroundColor;
@property (strong, nonatomic) UIColor *selectedBackgroundColor;
@property (strong, nonatomic) UIColor *disabledBackgroundColor;
@property (strong, nonatomic) UIColor *focusedBackgroundColor;
@property (strong, nonatomic) UIColor *applicationBackgroundColor;
@property (strong, nonatomic) UIColor *reservedBackgroundColor;

/**
 * Set a font for a button state.
 *
 * @param font  the font
 * @param state a control state -- can be
 *      UIControlStateNormal
 *      UIControlStateHighlighted
 *      UIControlStateDisabled
 *      UIControlStateSelected
 *      UIControlStateFocused
 *      UIControlStateApplication
 *      UIControlStateReserved
 */
- (void) setFont:(UIFont *)font forState:(UIControlState)state;

/**
 * Set a BackgroundColor for a button state.
 *
 * @param backgroundColor the color to use for background
 * @param state a control state -- can be
 *      UIControlStateNormal
 *      UIControlStateHighlighted
 *      UIControlStateDisabled
 *      UIControlStateSelected
 *      UIControlStateFocused
 *      UIControlStateApplication
 *      UIControlStateReserved
 */
- (void) setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end
