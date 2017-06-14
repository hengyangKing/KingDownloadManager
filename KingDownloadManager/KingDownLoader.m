//
//  KingDownLoader.m
//  KingDownloadManagerDemo
//
//  Created by J on 2017/6/14.
//  Copyright © 2017年 J. All rights reserved.
//

#import "KingDownLoader.h"
#import "KingDownLoadManagerFileTool.h"
//缓存地址
#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
//临时地址
#define kTempPath NSTemporaryDirectory()

@interface KingDownLoader()<NSURLSessionDataDelegate>
{
    long long _tempSize;
    long long _totalSize;
}
@property(nonatomic,strong)NSURLSession *session;
@property(nonatomic,strong)NSURL *url;
//下载完成路径
@property(nonatomic,copy)NSString *downloadedPath;
//下载缓存路径
@property(nonatomic,copy)NSString *downloadingPath;

//NSStream
//NSStream是Cocoa平台下对流这个概念的实现类，NSInputStream和NSOutputStream则是它的两个子类，分别对应了读文件和写文件。
@property(nonatomic,strong)NSOutputStream *outpustStream;
//session 持有 同session共同销毁
@property(nonatomic,weak)NSURLSessionDataTask *dataTask;

@property(nonatomic,assign)float progress;

@end
@implementation KingDownLoader
#pragma mark lazy
-(NSURLSession *)session
{
    if (!_session) {
        NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
        
        _session=[NSURLSession sessionWithConfiguration:(config) delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}
-(void)setUrl:(NSURL *)url
{
    _url=url;
    NSString *fileName=_url.lastPathComponent;
    
    self.downloadedPath = [kCachePath stringByAppendingPathComponent:fileName];
    self.downloadingPath = [kTempPath stringByAppendingPathComponent:fileName];
    
}
-(void)setProgress:(float)progress
{
    _progress=progress;
    if (self.downloadProgressBlock) {
        self.downloadProgressBlock(_progress);
    }
}
-(void)setState:(KingDownLoaderState)state
{
    if (_state==state) {
        return;
    }
    _state=state;
    if (self.stateChangeBlock) {
        self.stateChangeBlock(_state);
    }
    if (_state==KingDownLoaderStateSuccess&&self.downloadSuccessBlock) {
        self.downloadSuccessBlock(self.downloadedPath);
    }
    
}
#pragma mark func
-(void)downLoadWithUrl:(NSURL *)url andState:(KingDownLoaderStateChangeBlock)state andProgress:(KingDownLoaderDownloadProgressBlock)progress andSuccess:(KingDownLoaderDownloadSuccessBlock)success andFailed:(KingDownLoaderDownloadFailedBlock)failed
{
    [self setStateChangeBlock:state];
    [self setDownloadProgressBlock:progress];
    [self setDownloadSuccessBlock:success];
    [self setDownloadFailedBlock:failed];
    [self downLoadWithUrl:url];
}


-(void)downLoadWithUrl:(NSURL *)url
{
    if (!url) {
        return;
    }else{
        //如果任务存在，继续下载
        if ([url isEqual:self.dataTask.originalRequest.URL]) {
            if (self.state==KingDownLoaderStatePause) {
                //判断状态是否为暂停 继续下载
                [self resumeCurrentTask];
                return;
            }
        }
        self.url=url;
    }
    
    //    文件的存放
    //    下载ing ->temp+名称
    //    md5房子重复资源
    //    下载完成=>cache +名称
    //    判断url ，对应的资源，是下载完毕(下载完成的目录内存在该文件)
    //取消当前下载
    [self cacelCurrentTask];
    if ([KingDownLoadManagerFileTool fileExistsAtPath:self.downloadedPath]) {
    //    return 下载完成 传递相关信息
        self.state=KingDownLoaderStateSuccess;
        
        return;
    }
    
    //    检测临时文件
    if (![KingDownLoadManagerFileTool fileExistsAtPath:self.downloadingPath]) {
        //    不存在 从0字节开始请求资源
        _tempSize=0;
        [self download];
        
        return;
    }
    //临时文件大小
    _tempSize=[KingDownLoadManagerFileTool fileSize:self.downloadingPath];
    [self download];
    
}
//继续下载
-(void)resumeCurrentTask
{
    //若调用几次暂停 则需要调用几次继续
    if (self.dataTask&&self.state==KingDownLoaderStatePause) {
        [self.dataTask resume];
        self.state=KingDownLoaderStateDownloading;
    }
}
//暂停任务
-(void)pauseCurrentTask
{
    //若调用几次继续 则需要调用几次暂停
    if (self.state==KingDownLoaderStateDownloading) {
        [self.dataTask suspend];
        self.state=KingDownLoaderStatePause;
    }
}
//取消任务
-(void)cacelCurrentTask
{
    [self.session invalidateAndCancel];
    self.session=nil;
    //self.session 所持有的self.dataTask 由于weak引用 所以也同被销毁
    self.state=KingDownLoaderStatePause;

}

//取消和清空
-(void)cacelAndClean
{
    [self cacelCurrentTask];
    //删除缓存
    [KingDownLoadManagerFileTool removeFile:self.downloadedPath];
    
}

#pragma mark 私有方法
/**
 下载方法
 */
-(void)download
{
    //忽略本地数据缓存
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    //设置请求头Range字段为bytes=
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-",_tempSize] forHTTPHeaderField:@"Range"];
    
    //session 分配的task 默认挂起
    self.dataTask=[self.session dataTaskWithRequest:request];
    //重新挂起task
    [self resumeCurrentTask];
}
#pragma mark NSURLSessionDelegate
//接受到响应头 调用 只有响应头信息 并没有资源内容 参数response 类型变成NSHTTPURLResponse
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(nonnull NSHTTPURLResponse *)response completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler
{
    //    对比文件大小
    //    通过回调控制是否继续请求
    
    _totalSize=[response.allHeaderFields[@"Content-Length"] longLongValue];
    NSString *contentRangStr=response.allHeaderFields[@"Content-Range"];
    if (contentRangStr.length) {
        //    [@"Content-Range"]字段在某些情况下 只有在请求头设置过才会有
        _totalSize = [[[contentRangStr componentsSeparatedByString:@"/"]lastObject] longLongValue];
    }
    if (self.downloadInfoBlock) {
        self.downloadInfoBlock(_totalSize);
    }
    if (_tempSize == _totalSize) {
        //移动到下载完成文件夹
        [KingDownLoadManagerFileTool moveFile:self.downloadingPath toPath:self.downloadedPath];
        //        取消本次请求
        completionHandler(NSURLSessionResponseCancel);
        self.state=KingDownLoaderStateSuccess;
        
        return;
    }
    if (_tempSize>_totalSize) {
        //        删除
        [KingDownLoadManagerFileTool removeFile:self.downloadingPath];
        //        取消本次请求
        completionHandler(NSURLSessionResponseCancel);
        //        从0开始下载
        [self downLoadWithUrl:response.URL];
        
        return;
    }
    
    self.state=KingDownLoaderStateDownloading;
    //打开数据流
    self.outpustStream=[NSOutputStream outputStreamToFileAtPath:self.downloadingPath append:YES];
    [self.outpustStream open];
    
    completionHandler(NSURLSessionResponseAllow);
}
//确定接收数据调用
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    _tempSize+=data.length;
    self.progress=1.0 * _tempSize/_totalSize;
    //写入数据流
    [self.outpustStream write:data.bytes maxLength:data.length];
}
//请求终结调用
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error) {
        self.state=(error.code==-999)?KingDownLoaderStatePause:KingDownLoaderStateFailed;
        if (self.state==KingDownLoaderStateFailed&&self.downloadFailedBlock) {
            self.downloadFailedBlock(error);
        }
    }else{
        //        判断本地缓存==文件总大小
        //        如果=> 验证，是否文件完整，对比md5摘要
        [KingDownLoadManagerFileTool moveFile:self.downloadingPath toPath:self.downloadedPath];
        self.state=KingDownLoaderStateSuccess;
    }
    //    关闭数据流
    [self.outpustStream close];
}


@end
