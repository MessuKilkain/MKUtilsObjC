
/*
 Origianl Code from https://github.com/JohnEstropia/JEToolkit/blob/master/JEToolkit/JEToolkit/Categories/UIColor%2BJEToolkit.m
 */

#import <UIKit/UIKit.h>

@interface UIColor (HexString)

/*! Creates a color from a color hex string.
 @param hexString The RGB-hex formatted NSString to convert a color from
 @return A color from the hex formatted NSString
 */
+ (nullable UIColor *)colorWithHexString:(nonnull NSString *)hexString;
+ (nullable UIColor *)colorWithHexString:(nullable NSString *)hexString orDefault:(nullable UIColor*)defaultColor;

/*! Creates a color from a RGB integer value.
 @param RGBInt The RGB integer value to convert from
 @param alpha The extracted color's alpha value
 @return a color from the RGB integer
 */
+ (nonnull UIColor *)colorWithInt:(NSUInteger)RGBInt alpha:(CGFloat)alpha;

/*! Creates a random color.
 @return a random opaque color
 */
+ (nonnull UIColor *)randomColor;

@end
