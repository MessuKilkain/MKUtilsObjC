//
//  NSDIctionary+JSON+AllValues.m
//

#import "NSDIctionary+JSON+AllValues.h"

#import "NSArray+JSON+AllValues.h"

@implementation NSDictionary(JSON_AllValues)

-(NSArray*)allRecursiveValuesForKey:(id)searchedKey
{
    NSMutableArray* valuesFound = [NSMutableArray array];
    NSArray* keys = [self allKeys];
    NSUInteger keysCount = [keys count];
    for( NSUInteger keyIndex = 0 ; keyIndex < keysCount ; keyIndex++ )
    {
        id currentKey = [keys objectAtIndex:keyIndex];
        id currentValue = [self objectForKey:currentKey];
        // NSLog(@"cKey : %@",currentKey);
        // NSLog(@"cValue : %@",currentValue);
        if(
           [currentKey respondsToSelector:@selector(isEqual:)]
           && [currentKey isEqual:searchedKey]
           )
        {
            [valuesFound addObject:currentValue];
        }
        if( [currentValue respondsToSelector:@selector(isKindOfClass:)] )
        {
            if( [currentValue isKindOfClass:[NSDictionary class]] )
            {
                NSDictionary* currentDictionary = (NSDictionary*)currentValue;
                [valuesFound addObjectsFromArray:[currentDictionary allRecursiveValuesForKey:searchedKey]];
            }
            if( [currentValue isKindOfClass:[NSArray class]] )
            {
                NSArray* currentArray = (NSArray*)currentValue;
                [valuesFound addObjectsFromArray:[currentArray allRecursiveValuesForKey:searchedKey]];
            }
        }
    }
    return valuesFound;
}

@end
