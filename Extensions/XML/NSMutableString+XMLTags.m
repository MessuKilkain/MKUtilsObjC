//
//  NSMutableString+XMLTags.m
//

#import "NSMutableString+XMLTags.h"

@implementation NSMutableString(XMLTags)

-(void)appendTagStart:(NSString*)tagName
{
    [self appendFormat:@"<%1$@>", tagName];
}
-(void)appendTagEnd:(NSString*)tagName
{
    [self appendFormat:@"</%1$@>", tagName];
}
-(void)appendTagAutoClosed:(NSString*)tagName
{
    [self appendFormat:@"<%1$@/>", tagName];
}
-(void)appendTag:(NSString*)tagName withStringContent:(NSString*)content
{
    [self appendFormat:@"<%1$@>%2$@</%1$@>", tagName, content];
}
-(void)appendTag:(NSString*)tagName withIntegerContent:(NSInteger)content
{
    [self appendFormat:@"<%1$@>%2$ld</%1$@>", tagName, (long)content];
}
-(void)appendTag:(NSString*)tagName withDoubleContent:(double)content
{
    [self appendFormat:@"<%1$@>%2$lf</%1$@>", tagName, content];
}

@end
