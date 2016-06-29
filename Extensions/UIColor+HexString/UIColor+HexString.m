
/*
 Origianl Code from https://github.com/JohnEstropia/JEToolkit/blob/master/JEToolkit/JEToolkit/Categories/UIColor%2BJEToolkit.m
 */

#import "UIColor+HexString.h"

@implementation UIColor (HexString)

#pragma mark - Public

+ (nullable UIColor *)colorWithHexString:(NSString *)hexString {
    
    for (NSString *prefix in @[@"0x", @"#", @"0X"]) {
        
        if ([hexString hasPrefix:prefix]) {
            
            hexString = [hexString substringFromIndex:[prefix length]];
            break;
        }
    }
    
    NSUInteger hexStringLength = [hexString length];
    if (hexStringLength != 6 && hexStringLength != 8) {
        
        return nil;
    }
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:hexString];
    unsigned long long hexInt = 0;
    if (![scanner scanHexLongLong:&hexInt]) {
        
        return nil;
    }
    
    switch ([hexString length]) {
            
        case 6: return [self
                        colorWithInt:(NSUInteger)hexInt
                        alpha:1.0f];
        case 8: return [self
                        colorWithInt:(NSUInteger)(hexInt >> 8)
                        alpha:(((CGFloat)(hexInt & 0xFF)) / 255.0f)];
    }
    return nil;
}

+ (nullable UIColor *)colorWithHexString:(nullable NSString *)hexString orDefault:(nullable UIColor*)defaultColor
{
    if( hexString == nil )
    {
        // NSLog(@"Case 1");
        return defaultColor;
    }
    UIColor* returnedColor = [self colorWithHexString:hexString];
    if( returnedColor != nil )
    {
        // NSLog(@"Case 2");
        return returnedColor;
    }
    else
    {
        // NSLog(@"Case 3");
        return defaultColor;
    }
}

+ (UIColor *)colorWithInt:(NSUInteger)RGBInt alpha:(CGFloat)alpha {
    
    return [UIColor
            colorWithRed:(((CGFloat)((RGBInt & 0xFF0000) >> 16)) / 255.0f)
            green:(((CGFloat)((RGBInt & 0xFF00) >> 8)) / 255.0f)
            blue:(((CGFloat)(RGBInt & 0xFF)) / 255.0f)
            alpha:alpha];
}

+ (UIColor *)randomColor {
    
    return [UIColor colorWithInt:arc4random_uniform(0x01000000) alpha:1.0f];
}

@end
