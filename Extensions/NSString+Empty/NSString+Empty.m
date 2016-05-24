//
//  NSString+Empty.m
//

#import "NSString+Empty.h"

@implementation NSString(Empty)

+(BOOL)isNilOrEmptyString:(NSString *)str
{
    if( str == nil )
    {
        return YES;
    }
    else
    {
        return [self isEmptyString:str];
    }
}
+(BOOL)isEmptyString:(NSString *)str {
    return ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0);
}

@end
