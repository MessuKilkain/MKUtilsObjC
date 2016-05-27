//
//  NSString+XMLTags.m
//

#import "NSString+XMLTags.h"

@implementation NSString(XMLTags)

+(instancetype)stringWithTagStart:(NSString*)tagName
{
    return [self stringWithTagStart:tagName withTagAttributes:nil];
}
+(instancetype)stringWithTagStart:(NSString*)tagName withTagAttributes:(NSDictionary<NSString*,NSString*>*)tagAttibutes
{
    return [self stringWithFormat:@"<%1$@%2$@>", tagName, [self stringWithTagAttributes:tagAttibutes]];
}
+(instancetype)stringWithTagEnd:(NSString*)tagName
{
    return [self stringWithFormat:@"</%1$@>", tagName];
}
+(instancetype)stringWithTagAutoClosed:(NSString*)tagName
{
    return [self stringWithTagAutoClosed:tagName withTagAttributes:nil];
}
+(instancetype)stringWithTagAutoClosed:(NSString*)tagName withTagAttributes:(NSDictionary<NSString*,NSString*>*)tagAttibutes
{
    return [self stringWithFormat:@"<%1$@%2$@/>", tagName, [self stringWithTagAttributes:tagAttibutes]];
}
+(instancetype)stringWithTag:(NSString*)tagName withStringContent:(NSString*)content
{
    return [self stringWithTag:tagName withStringContent:content withTagAttributes:nil];
}
+(instancetype)stringWithTag:(NSString*)tagName withStringContent:(NSString*)content withTagAttributes:(NSDictionary<NSString*,NSString*>*)tagAttibutes
{
    return [self stringWithFormat:@"<%1$@%3$@>%2$@</%1$@>", tagName, content, [self stringWithTagAttributes:tagAttibutes]];
}
+(instancetype)stringWithTag:(NSString*)tagName withIntegerContent:(NSInteger)content
{
    return [self stringWithTag:tagName withIntegerContent:content withTagAttributes:nil];
}
+(instancetype)stringWithTag:(NSString*)tagName withIntegerContent:(NSInteger)content withTagAttributes:(NSDictionary<NSString*,NSString*>*)tagAttibutes
{
    return [self stringWithTag:tagName withStringContent:[NSString stringWithFormat:@"%ld",(long)content] withTagAttributes:tagAttibutes];
}
+(instancetype)stringWithTag:(NSString*)tagName withDoubleContent:(double)content
{
    return [self stringWithTag:tagName withDoubleContent:content withTagAttributes:nil];
}
+(instancetype)stringWithTag:(NSString*)tagName withDoubleContent:(double)content withTagAttributes:(NSDictionary<NSString*,NSString*>*)tagAttibutes
{
    return [self stringWithTag:tagName withStringContent:[NSString stringWithFormat:@"%lf",content] withTagAttributes:tagAttibutes];
}
+(instancetype)stringWithTagAttributes:(NSDictionary<NSString*,NSString*>*)tagAttibutes
{
    NSMutableString* attributesString = [NSMutableString string];
    if(
       tagAttibutes != nil
       && [tagAttibutes count] > 0
       )
    {
        [tagAttibutes
         enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
             [attributesString appendFormat:@" %@=\"%@\"",key,[obj stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"]];
         }];
    }
    if( [attributesString length] > 0 )
    {
        [attributesString appendString:@" "];
    }
    return attributesString;
}

@end
