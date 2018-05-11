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


/**
 定义下载路径下载任务

 @param url url
 @param savePath 下载路径
 @param state 状态
 @param progress 进度
 @param success 成功回调
 @param failed 失败回调
 */
-(void)downLoadWithUrl:(NSURL *)url andSavePath:(NSString *)savePath andState:(KingDownLoaderStateChangeBlock)state andProgress:(KingDownLoaderDownloadProgressBlock)progress andSuccess:(KingDownLoaderDownloadSuccessBlock)success andFailed:(KingDownLoaderDownloadFailedBlock)failed ;


/**
 默认下载任务

 @param url url
 @param state 状态
 @param progress 进度
 @param success 成功回调
 @param failed 失败回调
 */
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
