//
//  NSMutableString+XMLTags.m
//

#import "NSMutableString+XMLTags.h"

@implementation NSMutableString(XMLTags)

-(void)appendTagStart:(NSString*)tagName
{
    [self appendTagStart:tagName withTagAttributes:nil];
}
-(void)appendTagStart:(NSString*)tagName withTagAttributes:(NSDictionary<NSString*,NSString*>*)tagAttibutes
{
    [self appendString:[NSString stringWithTagStart:tagName withTagAttributes:tagAttibutes]];
}
-(void)appendTagEnd:(NSString*)tagName
{
    [self appendString:[NSString stringWithTagEnd:tagName]];
}
-(void)appendTagAutoClosed:(NSString*)tagName
{
    [self appendTagAutoClosed:tagName withTagAttributes:nil];
}
-(void)appendTagAutoClosed:(NSString*)tagName withTagAttributes:(NSDictionary<NSString*,NSString*>*)tagAttibutes
{
    [self appendString:[NSString stringWithTagAutoClosed:tagName withTagAttributes:tagAttibutes]];
}
-(void)appendTag:(NSString*)tagName withStringContent:(NSString*)content
{
    [self appendTag:tagName withStringContent:content withTagAttributes:nil];
}
-(void)appendTag:(NSString*)tagName withStringContent:(NSString*)content withTagAttributes:(NSDictionary<NSString*,NSString*>*)tagAttibutes
{
    [self appendString:[NSString stringWithTag:tagName withStringContent:content withTagAttributes:tagAttibutes]];
}
-(void)appendTag:(NSString*)tagName withIntegerContent:(NSInteger)content
{
    [self appendTag:tagName withIntegerContent:content withTagAttributes:nil];
}
-(void)appendTag:(NSString*)tagName withIntegerContent:(NSInteger)content withTagAttributes:(NSDictionary<NSString*,NSString*>*)tagAttibutes
{
    [self appendString:[NSString stringWithTag:tagName withIntegerContent:content withTagAttributes:tagAttibutes]];
}
-(void)appendTag:(NSString*)tagName withDoubleContent:(double)content
{
    [self appendTag:tagName withDoubleContent:content withTagAttributes:nil];
}
-(void)appendTag:(NSString*)tagName withDoubleContent:(double)content withTagAttributes:(NSDictionary<NSString*,NSString*>*)tagAttibutes
{
    [self appendString:[NSString stringWithTag:tagName withDoubleContent:content withTagAttributes:tagAttibutes]];
}

@end
