//
//  NSURL+FileSize.m
//

#import "NSURL+FileSize.h"

@implementation NSURL(FileSize)

+(BOOL)getFileSize:(NSURL*)fileUrl completionCallback:(void(^)(unsigned long long fileSize))completionCallback
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    if( queue != nil )
    {
        dispatch_async(queue, ^{
            if( completionCallback != nil )
            {
                completionCallback( [NSURL getFileSize:fileUrl] );
            }
        });
        return YES;
    }
    else
    {
        // NSLog(@"ERROR : queue is nil");
        return NO;
    }
}
+(unsigned long long)getFileSize:(NSURL*)fileUrl
{
    unsigned long long result = 0;
    if( fileUrl != nil )
    {
        BOOL directory = NO;
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[fileUrl path] isDirectory:&directory];
        if( fileExists )
        {
            if( !directory )
            {
                result += [NSURL getNotDirectoryFileSize:fileUrl];
            }
            else
            {
                result += [NSURL getDirectoryFileSize:fileUrl];
            }
        }
    }
    return result;
}
+(unsigned long long)getNotDirectoryFileSize:(NSURL*)fileUrl
{
    unsigned long long result = 0;
    
    if( fileUrl == nil )
    {
        // NSLog(@"WARNING : fileUrl is nil");
    }
    else
    {
        NSError* errorOnAttributes = nil;
        NSDictionary* fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[fileUrl path] error:&errorOnAttributes];
        if( errorOnAttributes != nil )
        {
            // NSlog(@"errorOnAttributes in not nil : %@",[errorOnAttributes description]);
        }
        else if( fileAttributes == nil )
        {
            // NSLog(@"WARNING : fileAttributes is nil");
        }
        else
        {
            NSObject* fileSizeObject = [fileAttributes objectForKey:NSFileSize];
            if( fileSizeObject == nil )
            {
                // NSLog(@"WARNING : fileSizeObject is nil");
            }
            else if( ![fileSizeObject isKindOfClass:[NSNumber class]] )
            {
                // NSLog(@"WARNING : fileSizeObject is not a NSNumber");
            }
            else
            {
                result += [(NSNumber*)fileSizeObject unsignedLongLongValue];
            }
        }
    }
    
    return result;
}
+(unsigned long long)getDirectoryFileSize:(NSURL*)directoryUrl
{
    unsigned long long result = 0;
    
    if( directoryUrl == nil )
    {
        // NSLog(@"WARNING : directoryUrl is nil");
    }
    else
    {
        NSArray *properties = [NSArray arrayWithObjects: NSURLLocalizedNameKey, NSURLCreationDateKey, NSURLLocalizedTypeDescriptionKey, nil];
        
        NSArray *array = [[NSFileManager defaultManager]
                          contentsOfDirectoryAtURL:directoryUrl
                          includingPropertiesForKeys:properties
                          options:0 // NSDirectoryEnumerationSkipsHiddenFiles if appropriate
                          error:nil];
        
        if( array == nil )
        {
            // NSLog(@"WARNING : array is nil"); // NOTE : this appends also if the folder/file does not exist
        }
        else
        {
            for( NSURL *fileSystemItem in array )
            {
                result += [NSURL getFileSize:fileSystemItem];
            }
        }
    }
    
    return result;
}

@end
