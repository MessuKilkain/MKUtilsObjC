//
//  NSDictionary+DefaultValue.m
//

#import "NSDictionary+DefaultValue.h"

@implementation NSDictionary(DefaultValue)

-(BOOL)boolForKey:(NSString*)keyString orDefault:(BOOL)defaultBool
{
    BOOL returnedBool = defaultBool;
    if( keyString != nil )
    {
        id valueOfDict = [self objectForKey:keyString];
        if( valueOfDict != nil )
        {
            if( [valueOfDict isKindOfClass:[NSNumber class]] )
            {
                returnedBool = [(NSNumber*)valueOfDict boolValue];
            }
            else if( [valueOfDict isKindOfClass:[NSString class]] )
            {
                returnedBool = [(NSString*)valueOfDict boolValue];
            }
        }
    }
    return returnedBool;
}

-(float)floatForKey:(NSString*)keyString orDefault:(float)defaultFloat
{
    float returnedFloat = defaultFloat;
    if( keyString != nil )
    {
        id valueOfDict = [self objectForKey:keyString];
        if( valueOfDict != nil )
        {
            if( [valueOfDict isKindOfClass:[NSNumber class]] )
            {
                returnedFloat = [(NSNumber*)valueOfDict floatValue];
            }
            else if( [valueOfDict isKindOfClass:[NSString class]] )
            {
                returnedFloat = [(NSString*)valueOfDict floatValue];
            }
        }
    }
    return returnedFloat;
}

-(NSInteger)integerForKey:(NSString*)keyString orDefault:(NSInteger)defaultInteger
{
    NSInteger returnedInteger = defaultInteger;
    if( keyString != nil )
    {
        id valueOfDict = [self objectForKey:keyString];
        if( valueOfDict != nil )
        {
            if( [valueOfDict isKindOfClass:[NSNumber class]] )
            {
                returnedInteger = [(NSNumber*)valueOfDict integerValue];
            }
            else if( [valueOfDict isKindOfClass:[NSString class]] )
            {
                returnedInteger = [(NSString*)valueOfDict integerValue];
            }
        }
    }
    return returnedInteger;
}

-(NSString*)stringForKey:(NSString*)keyString orDefault:(NSString*)defaultString
{
    NSString* returnedString = defaultString;
    if( keyString != nil )
    {
        id valueOfDict = [self objectForKey:keyString];
        if( valueOfDict != nil )
        {
            if( [valueOfDict isKindOfClass:[NSString class]] )
            {
                returnedString = (NSString*)valueOfDict;
            }
        }
    }
    return returnedString;
}

-(id)idForKeyString:(NSString*)keyString orDefault:(id)defaultValue
{
    id returnedValue = defaultValue;
    if( keyString != nil )
    {
        id valueOfDict = [self objectForKey:keyString];
        if( valueOfDict != nil )
        {
            returnedValue = valueOfDict;
        }
    }
    return returnedValue;
}

@end
