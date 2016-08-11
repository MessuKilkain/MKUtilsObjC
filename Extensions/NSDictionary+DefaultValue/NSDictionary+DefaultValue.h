//
//  NSDictionary+DefaultValue.h
//

#import <Foundation/Foundation.h>

@interface NSDictionary(DefaultValue)

-(BOOL)boolForKey:(NSString*)keyString orDefault:(BOOL)defaultBool;
-(float)floatForKey:(NSString*)keyString orDefault:(float)defaultFloat;
-(NSInteger)integerForKey:(NSString*)keyString orDefault:(NSInteger)defaultInteger;
-(NSString*)stringForKey:(NSString*)keyString orDefault:(NSString*)defaultString;
-(NSArray*)arrayForKeyString:(NSString*)keyString orDefault:(NSArray*)defaultValue;
-(id)idForKeyString:(NSString*)keyString orDefault:(id)defaultValue;

@end
