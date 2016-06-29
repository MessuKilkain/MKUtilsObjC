//
//  MKCacheFileBased+FileSize.m
//

#if __has_include("MKCacheFileBased.h")

#import "MKCacheFileBased+FileSize.h"

@implementation MKCacheFileBased(FileSize)

#pragma mark - Generic static methods - File Size of cache

+(unsigned long long)cacheFileSizeForCachePath:(NSString*)cachePath
{
    return [NSURL getDirectoryFileSize:[NSURL URLWithString:cachePath]];
}

#pragma mark - Instance specific methods - File Size of cache

-(unsigned long long)cacheFileSize
{
    return [[self class] cacheFileSizeForCachePath:[self cacheDirectoryPath]];
}

@end

#endif
