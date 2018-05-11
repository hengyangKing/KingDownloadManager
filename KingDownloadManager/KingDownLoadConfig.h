//
//  KingDownLoadConfig.h
//  Pods-KingDownloadManagerDemo
//
//  Created by king on 2018/5/11.
//

#import <Foundation/Foundation.h>
#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

@interface KingDownLoadConfig : NSObject
@property(nonatomic,strong,readonly)NSURL *url;
@property(nonatomic,copy,readonly)KingDownLoadConfig *(^YQURL)(NSURL *url);

@property(nonatomic,copy,readonly)NSString *savePath;
@property(nonatomic,copy,readonly)KingDownLoadConfig *(^YQSavePath)(NSString *filePath);

@property(nonatomic,assign,readonly)NSTimeInterval timeoutInterval;
@property(nonatomic,copy,readonly)KingDownLoadConfig *(^YQTimeoutInterval)(NSTimeInterval time);

+(instancetype)defaultConfig;

-(BOOL)guardConfig;
@end
