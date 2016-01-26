//
//  UIImage+Tint.m
//

#import "UIImage+Tint.h"

@implementation UIImage(Tint)

+ (UIImage*)imageWithUIColor:(UIColor*)color
{
    if (!color)
    {
        color = [UIColor clearColor];
    }
    return [self imageWithCGColor:[color CGColor]];
}

+ (UIImage*)imageWithCGColor:(CGColorRef)color
{
    if (!color)
    {
        color = [[UIColor clearColor] CGColor];
    }
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageNamed:(NSString *)name tintedWithColor:(UIColor *)color
{
    return [self tintedImage:[self imageNamed:name] withColor:color];
}

+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle compatibleWithTraitCollection:(UITraitCollection *)traitCollection tintedWithColor:(UIColor *)color
{
    return [self tintedImage:[self imageNamed:name inBundle:bundle compatibleWithTraitCollection:traitCollection] withColor:color];
}

- (UIImage *)tintedImageWithColor:(UIColor *)color
{
    return [[self class] tintedImage:self withColor:color];
}
+ (UIImage *)tintedImage:(UIImage *)image withColor:(UIColor *)color
{
    if (!color)
        return [image copy];
    
    CGFloat scale = image.scale;
    CGSize size = CGSizeMake(scale * image.size.width, scale * image.size.height);
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    // ---
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, image.CGImage);
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [color setFill];
    CGContextFillRect(context, rect);
    
    // ---
    CGImageRef bitmapContext = CGBitmapContextCreateImage(context);
    
    UIImage *coloredImage = [UIImage imageWithCGImage:bitmapContext scale:scale orientation:UIImageOrientationUp];
    
    CGImageRelease(bitmapContext);
    
    UIGraphicsEndImageContext();
    
    return coloredImage;
}

@end
