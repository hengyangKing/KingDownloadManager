//
//  KingDownLoadManagerFileTool.h
//  KingDownloadManagerDemo
//
//  Created by J on 2017/6/14.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KingDownLoadManagerFileTool : NSObject
//检测文件是否存在
+(BOOL)fileExistsAtPath:(NSString *)path;
//文件大小
+(long long)fileSize:(NSString *)path;
//移动文件
+(BOOL)moveFile:(NSString *)path toPath:(NSString *)toPath;
//删除
+(BOOL)removeFile:(NSString *)path;

@end
