//
//  NSMutableString+XMLTags.h
//

#ifndef XML_NSMutableString_XMLTags_h
#define XML_NSMutableString_XMLTags_h

#import <Foundation/Foundation.h>

@interface NSMutableString(XMLTags)

-(void)appendTagStart:(NSString*)tagName;
-(void)appendTagStart:(NSString*)tagName withTagAttributes:(NSDictionary<NSString*,NSString*>*)tagAttibutes;
-(void)appendTagEnd:(NSString*)tagName;
-(void)appendTagAutoClosed:(NSString*)tagName;
-(void)appendTagAutoClosed:(NSString*)tagName withTagAttributes:(NSDictionary<NSString*,NSString*>*)tagAttibutes;
-(void)appendTag:(NSString*)tagName withStringContent:(NSString*)content;
-(void)appendTag:(NSString*)tagName withStringContent:(NSString*)content withTagAttributes:(NSDictionary<NSString*,NSString*>*)tagAttibutes;
-(void)appendTag:(NSString*)tagName withIntegerContent:(NSInteger)content;
-(void)appendTag:(NSString*)tagName withIntegerContent:(NSInteger)content withTagAttributes:(NSDictionary<NSString*,NSString*>*)tagAttibutes;
-(void)appendTag:(NSString*)tagName withDoubleContent:(double)content;
-(void)appendTag:(NSString*)tagName withDoubleContent:(double)content withTagAttributes:(NSDictionary<NSString*,NSString*>*)tagAttibutes;

@end

#endif
