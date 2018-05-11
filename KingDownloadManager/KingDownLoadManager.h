//
//  KingDownLoadManager.h
//  KingDownloadManagerDemo
//
//  Created by J on 2017/6/14.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KingDownloadManagerInfo.h"
#import "KingDownLoadConfig.h"
@interface KingDownLoadManager : NSObject

+(instancetype)shareInstance;
///自定义下载参数下载
-(void)downLoadWithConfig:(void(^)(KingDownLoadConfig *config))config andState:(KingDownLoaderStateChangeBlock)state andProgress:(KingDownLoaderDownloadProgressBlock)progress andSuccess:(KingDownLoaderDownloadSuccessBlock)success andFailed:(KingDownLoaderDownloadFailedBlock)failed;



///默认存储地址下载
-(void)downLoadWithUrl:(NSURL *)url andState:(KingDownLoaderStateChangeBlock)state andProgress:(KingDownLoaderDownloadProgressBlock)progress andSuccess:(KingDownLoaderDownloadSuccessBlock)success andFailed:(KingDownLoaderDownloadFailedBlock)failed;


-(void)pauseAll;

-(void)resumeAll;

-(void)cancelAll;

-(void)pauseWithURL:(NSURL *)url;

-(void)resumeWithURL:(NSURL *)url;

-(void)cancelWithURL:(NSURL *)url;


@end
