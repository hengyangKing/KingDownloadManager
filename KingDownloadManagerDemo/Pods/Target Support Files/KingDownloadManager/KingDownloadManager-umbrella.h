#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "KingDownLoadConfig.h"
#import "KingDownLoader.h"
#import "KingDownLoadManager.h"
#import "KingDownLoadManagerFileTool.h"
#import "KingDownloadManagerInfo.h"
#import "NSString+MD5.h"

FOUNDATION_EXPORT double KingDownloadManagerVersionNumber;
FOUNDATION_EXPORT const unsigned char KingDownloadManagerVersionString[];

