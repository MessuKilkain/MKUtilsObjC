//
//  UIImage+Tint.h
//  Inspired by https://github.com/DZamataev/DZVideoPlayerViewController
//

#ifndef UIImage_Tint_h
#define UIImage_Tint_h

#import <UIKit/UIKit.h>

@interface UIImage(Tint)

+ (UIImage*)imageWithUIColor:(UIColor*)color;
+ (UIImage*)imageWithCGColor:(CGColorRef)color;

+ (UIImage *)imageNamed:(NSString *)name tintedWithColor:(UIColor *)color;
+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle compatibleWithTraitCollection:(UITraitCollection *)traitCollection tintedWithColor:(UIColor *)color;
- (UIImage *)tintedImageWithColor:(UIColor *)color;
+ (UIImage *)tintedImage:(UIImage *)image withColor:(UIColor *)color;

@end

#endif
