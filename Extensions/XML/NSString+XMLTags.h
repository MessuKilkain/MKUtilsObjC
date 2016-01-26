//
//  NSString+XMLTags.h
//


#ifndef XML_NSString_XMLTags_h
#define XML_NSString_XMLTags_h

#import <UIKit/UIKit.h>

@interface NSString(XMLTags)

+(instancetype)stringWithTagStart:(NSString*)tagName;
+(instancetype)stringWithTagEnd:(NSString*)tagName;
+(instancetype)stringWithTagAutoClosed:(NSString*)tagName;
+(instancetype)stringWithTag:(NSString*)tagName withStringContent:(NSString*)content;
+(instancetype)stringWithTag:(NSString*)tagName withIntegerContent:(NSInteger)content;
+(instancetype)stringWithTag:(NSString*)tagName withDoubleContent:(double)content;

@end

#endif
