//
//  NSString+XMLTags.h
//


#ifndef XML_NSString_XMLTags_h
#define XML_NSString_XMLTags_h

#import <Foundation/Foundation.h>

@interface NSString(XMLTags)

+(instancetype)stringWithTagStart:(NSString*)tagName;
+(instancetype)stringWithTagStart:(NSString*)tagName withTagAttributes:(NSDictionary<NSString*,NSString*>*)tagAttibutes;
+(instancetype)stringWithTagEnd:(NSString*)tagName;
+(instancetype)stringWithTagAutoClosed:(NSString*)tagName;
+(instancetype)stringWithTagAutoClosed:(NSString*)tagName withTagAttributes:(NSDictionary<NSString*,NSString*>*)tagAttibutes;
+(instancetype)stringWithTag:(NSString*)tagName withStringContent:(NSString*)content;
+(instancetype)stringWithTag:(NSString*)tagName withStringContent:(NSString*)content withTagAttributes:(NSDictionary<NSString*,NSString*>*)tagAttibutes;
+(instancetype)stringWithTag:(NSString*)tagName withIntegerContent:(NSInteger)content;
+(instancetype)stringWithTag:(NSString*)tagName withIntegerContent:(NSInteger)content withTagAttributes:(NSDictionary<NSString*,NSString*>*)tagAttibutes;
+(instancetype)stringWithTag:(NSString*)tagName withDoubleContent:(double)content;
+(instancetype)stringWithTag:(NSString*)tagName withDoubleContent:(double)content withTagAttributes:(NSDictionary<NSString*,NSString*>*)tagAttibutes;
+(instancetype)stringWithTagAttributes:(NSDictionary<NSString*,NSString*>*)tagAttibutes;

@end

#endif
