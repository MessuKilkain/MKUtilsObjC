//
//  NSMutableString+XMLTags.h
//

#ifndef XML_NSMutableString_XMLTags_h
#define XML_NSMutableString_XMLTags_h

#import <Foundation/Foundation.h>

@interface NSMutableString(XMLTags)

-(void)appendTagStart:(NSString*)tagName;
-(void)appendTagEnd:(NSString*)tagName;
-(void)appendTagAutoClosed:(NSString*)tagName;
-(void)appendTag:(NSString*)tagName withStringContent:(NSString*)content;
-(void)appendTag:(NSString*)tagName withIntegerContent:(NSInteger)content;
-(void)appendTag:(NSString*)tagName withDoubleContent:(double)content;

@end

#endif
