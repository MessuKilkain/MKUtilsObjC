//
//  NSArray+JSON+AllValues.m
//

#import "NSArray+JSON+AllValues.h"

#import "NSDictionary+JSON+AllValues.h"

@implementation NSArray(JSON_AllValues)

-(NSArray*)allRecursiveValuesForKey:(id)searchedKey
{
    NSMutableArray* valuesFound = [NSMutableArray array];
    NSUInteger valuesCount = [self count];
    for( NSUInteger keyIndex = 0 ; keyIndex < valuesCount ; keyIndex++ )
    {
        id currentValue = [self objectAtIndex:keyIndex];
        // NSLog(@"cValue : %@",currentValue);
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
