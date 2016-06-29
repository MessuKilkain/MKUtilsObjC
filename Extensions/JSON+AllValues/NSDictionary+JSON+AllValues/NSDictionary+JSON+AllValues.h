//
//  NSDIctionary+JSON+AllValues.h
//

#ifndef __NSDIctionary_JSON_AllValues_h__
#define __NSDIctionary_JSON_AllValues_h__

#import <Foundation/Foundation.h>

@interface NSDictionary(JSON_AllValues)

-(NSArray*)allRecursiveValuesForKey:(id)searchedKey;

@end

#endif
