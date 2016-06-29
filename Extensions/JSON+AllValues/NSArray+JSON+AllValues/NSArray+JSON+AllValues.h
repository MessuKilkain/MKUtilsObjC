//
//  NSArray+JSON+AllValues.h
//

#ifndef __NSArray_JSON_AllValues_h__
#define __NSArray_JSON_AllValues_h__

#import <Foundation/Foundation.h>

@interface NSArray(JSON_AllValues)

-(NSArray*)allRecursiveValuesForKey:(id)searchedKey;

@end

#endif
