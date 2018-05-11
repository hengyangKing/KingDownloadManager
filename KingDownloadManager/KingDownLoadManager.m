//
//  KingDownLoadManager.m
//  KingDownloadManagerDemo
//
//  Created by J on 2017/6/14.
//  Copyright © 2017年 J. All rights reserved.
//

#import "KingDownLoadManager.h"

@interface KingDownLoadManager()<NSCopying,NSMutableCopying>
@property(nonatomic,assign)KingDownloadManagerInfo *downloaderInfo;
@end
@implementation KingDownLoadManager
static KingDownLoadManager *_shareInstance;
+(instancetype)shareInstance
{
    if (!_shareInstance) {
        _shareInstance=[[KingDownLoadManager alloc]init];
    }
    return _shareInstance;
}
//从内存调用创建
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (!_shareInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance=[super allocWithZone:zone];
        });
    }
    return _shareInstance;
}
-(id)copyWithZone:(NSZone *)zone
{
    return _shareInstance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _shareInstance;
}

-(KingDownloadManagerInfo *)downloaderInfo
{
    if (!_downloaderInfo) {
        _downloaderInfo=[KingDownloadManagerInfo dictionary];
    }
    return _downloaderInfo;
}
-(void)downLoadWithConfig:(void(^)(KingDownLoadConfig *config))config andState:(KingDownLoaderStateChangeBlock)state andProgress:(KingDownLoaderDownloadProgressBlock)progress andSuccess:(KingDownLoaderDownloadSuccessBlock)success andFailed:(KingDownLoaderDownloadFailedBlock)failed {
    
    KingDownLoadConfig *downLoadConfig = [KingDownLoadConfig defaultConfig];
    !config?:config(downLoadConfig);
    if ([downLoadConfig guardConfig]) {
        [[self.downloaderInfo getDownLoaderWithURL:downLoadConfig.url] downLoadWithConfig:downLoadConfig andState:state andProgress:progress andSuccess:success andFailed:failed];
    }
}
-(void)downLoadWithUrl:(NSURL *)url andState:(KingDownLoaderStateChangeBlock)state andProgress:(KingDownLoaderDownloadProgressBlock)progress andSuccess:(KingDownLoaderDownloadSuccessBlock)success andFailed:(KingDownLoaderDownloadFailedBlock)failed {
    [[self.downloaderInfo getDownLoaderWithURL:url] downLoadWithUrl:url andState:state andProgress:progress andSuccess:^(NSString *filePath) {
        //移除
        [self.downloaderInfo removeObjectForKey:url.absoluteString.MD5];
        if (success) {
            success(filePath);
        }
    } andFailed:failed];
}
-(void)pauseWithURL:(NSURL *)url
{
    [[self.downloaderInfo MD5URL:url] pauseCurrentTask];
}
-(void)cancelWithURL:(NSURL *)url
{
    [[self.downloaderInfo MD5URL:url] cacelCurrentTask];
}
-(void)resumeWithURL:(NSURL *)url
{
    [[self.downloaderInfo MD5URL:url] resumeCurrentTask];
}
-(void)pauseAll
{
    [self.downloaderInfo.allValues performSelector:@selector(pauseCurrentTask) withObject:nil];
}
-(void)resumeAll
{
    [self.downloaderInfo.allValues performSelector:@selector(resumeCurrentTask) withObject:nil];
}
-(void)cancelAll
{
    [self.downloaderInfo.allValues performSelector:@selector(cacelCurrentTask) withObject:nil];
}
@end
