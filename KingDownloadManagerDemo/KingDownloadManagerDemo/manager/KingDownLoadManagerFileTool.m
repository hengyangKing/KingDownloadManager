//
//  KingDownLoadManagerFileTool.m
//  KingDownloadManagerDemo
//
//  Created by J on 2017/6/14.
//  Copyright © 2017年 J. All rights reserved.
//

#import "KingDownLoadManagerFileTool.h"
#define FILEMANAGER [NSFileManager defaultManager]
@implementation KingDownLoadManagerFileTool
+(BOOL)fileExistsAtPath:(NSString *)path;
{
    if (!path.length) {
        return NO;
    }
    return [FILEMANAGER fileExistsAtPath:path];
}
+(long long)fileSize:(NSString *)path
{
    if (![self fileExistsAtPath:path]) {
        return 0;
    }
    NSDictionary *fileInfo=[FILEMANAGER attributesOfItemAtPath:path error:nil];
    return  [fileInfo[NSFileSize] longLongValue];
    
}
+(BOOL)moveFile:(NSString *)path toPath:(NSString *)toPath
{
    if (![self fileExistsAtPath:path]) {
        return NO;
    }
    return  [FILEMANAGER moveItemAtPath:path toPath:toPath error:nil];
}
+(BOOL)removeFile:(NSString *)path
{
    if (![self fileExistsAtPath:path]) {
        return NO;
    }
    return [FILEMANAGER removeItemAtPath:path error:nil];
}

@end
