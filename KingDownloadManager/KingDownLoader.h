//
//  KingDownLoader.h
//  KingDownloadManagerDemo
//
//  Created by J on 2017/6/14.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,KingDownLoaderState) {
    KingDownLoaderStatePause = 0,
    KingDownLoaderStateDownloading,
    KingDownLoaderStateSuccess,
    KingDownLoaderStateFailed,    
};
typedef void(^KingDownLoaderStateChangeBlock)(KingDownLoaderState newState);
typedef void(^KingDownLoaderDownloadInfoBlock)(long long totleSize);
typedef void(^KingDownLoaderDownloadProgressBlock)(float progress);
typedef void(^KingDownLoaderDownloadSuccessBlock)(NSString *filePath);
typedef void(^KingDownLoaderDownloadFailedBlock)(NSError *error);

//单任务下载器
@interface KingDownLoader : NSObject
//下载任务 且带有各种状态
-(void)downLoadWithUrl:(NSURL *)url andState:(KingDownLoaderStateChangeBlock)state andProgress:(KingDownLoaderDownloadProgressBlock)progress andSuccess:(KingDownLoaderDownloadSuccessBlock)success andFailed:(KingDownLoaderDownloadFailedBlock)failed;


//下载任务
-(void)downLoadWithUrl:(NSURL *)url;

//暂停任务
-(void)pauseCurrentTask;

//取消任务
-(void)cacelCurrentTask;

//取消和清空
-(void)cacelAndClean;

//继续下载
-(void)resumeCurrentTask;

//readonly 只生成get方法供外界调用 内部可自己实现set方法
@property(nonatomic,assign,readonly)KingDownLoaderState state;


//状态变化block
@property(nonatomic,copy)KingDownLoaderStateChangeBlock stateChangeBlock;


//下载信息block
@property(nonatomic,copy)KingDownLoaderDownloadInfoBlock downloadInfoBlock;

//下载进度block
@property(nonatomic,copy)KingDownLoaderDownloadProgressBlock downloadProgressBlock;

//下载成功block
@property(nonatomic,copy)KingDownLoaderDownloadSuccessBlock downloadSuccessBlock;

//下载失败block
@property(nonatomic,copy)KingDownLoaderDownloadFailedBlock downloadFailedBlock;

@end
