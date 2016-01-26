//
//  NSArray+Shuffle.m
//

#import "NSArray+Shuffle.h"

@implementation NSArray(Shuffle)

- (instancetype) shuffled
{
    // create temporary autoreleased mutable array
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[self count]];
    
    for (id anObject in self)
    {
        NSUInteger randomPos = arc4random()%([tmpArray count]+1);
        [tmpArray insertObject:anObject atIndex:randomPos];
    }
    
    return [[self class] arrayWithArray:tmpArray];  // non-mutable autoreleased copy
}

@end
