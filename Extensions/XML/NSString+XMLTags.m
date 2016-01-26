//
//  NSString+XMLTags.m
//

#import "NSString+XMLTags.h"

@implementation NSString(XMLTags)

+(instancetype)stringWithTagStart:(NSString*)tagName
{
    return [self stringWithFormat:@"<%1$@>", tagName];
}
+(instancetype)stringWithTagEnd:(NSString*)tagName
{
    return [self stringWithFormat:@"</%1$@>", tagName];
}
+(instancetype)stringWithTagAutoClosed:(NSString*)tagName
{
    return [self stringWithFormat:@"<%1$@/>", tagName];
}
+(instancetype)stringWithTag:(NSString*)tagName withStringContent:(NSString*)content
{
    return [self stringWithFormat:@"<%1$@>%2$@</%1$@>", tagName, content];
}
+(instancetype)stringWithTag:(NSString*)tagName withIntegerContent:(NSInteger)content
{
    return [self stringWithFormat:@"<%1$@>%2$ld</%1$@>", tagName, (long)content];
}
+(instancetype)stringWithTag:(NSString*)tagName withDoubleContent:(double)content
{
    return [self stringWithFormat:@"<%1$@>%2$lf</%1$@>", tagName, content];
}

@end
