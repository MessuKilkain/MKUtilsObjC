//
//  NSURL+FileSize.h
//

#import <Foundation/Foundation.h>

@interface NSURL(FileSize)

+(BOOL)getFileSize:(NSURL*)fileUrl completionCallback:(void(^)(unsigned long long fileSize))completionCallback;
+(unsigned long long)getFileSize:(NSURL*)fileUrl;
+(unsigned long long)getNotDirectoryFileSize:(NSURL*)fileUrl;
+(unsigned long long)getDirectoryFileSize:(NSURL*)directoryUrl;

@end
