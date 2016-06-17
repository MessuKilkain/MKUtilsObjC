//
//  NSDictionary+DefaultValue.h
//

#import <Foundation/Foundation.h>

@interface NSDictionary(DefaultValue)

-(BOOL)boolForKey:(NSString*)keyString orDefault:(BOOL)defaultBool;
-(float)floatForKey:(NSString*)keyString orDefault:(float)defaultFloat;
-(NSString*)stringForKey:(NSString*)keyString orDefault:(NSString*)defaultString;
-(id)idFromString:(NSString*)keyString orDefault:(id)defaultValue;

@end
