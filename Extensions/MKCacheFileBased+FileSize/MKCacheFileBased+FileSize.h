//
//  MKCacheFileBased+FileSize.h
//

#import "MKCacheFileBased.h"
#import "NSURL+FileSize.h"

@interface MKCacheFileBased(FileSize)

#pragma mark - Generic static methods

// File Size of cache
+(unsigned long long)cacheFileSizeForCachePath:(NSString*)cachePath;

#pragma mark - Instance specific

// File Size of cache
-(unsigned long long)cacheFileSize;

@end
