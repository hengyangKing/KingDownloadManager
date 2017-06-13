//
//  KingDownLoadManager.m
//  KingDownloadManagerDemo
//
//  Created by J on 2017/6/14.
//  Copyright © 2017年 J. All rights reserved.
//

#import "KingDownLoadManager.h"
#import "KingDownLoadManagerFileTool.h"
//缓存地址
#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
//临时地址
#define kTempPath NSTemporaryDirectory()
//资源大小标识
#define kContentLength @"Content-Length"
@interface KingDownLoadManager()<NSURLSessionDataDelegate>
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
@end
@implementation KingDownLoadManager
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
-(void)downLoadWithUrl:(NSURL *)url
{
    
    if (!url) {
        return;
    }else{
        self.url=url;
    }
//    文件的存放
//    下载ing ->temp+名称
//    md5房子重复资源
//    下载完成=>cache +名称
   
//    判断url ，对应的资源，是下载完毕(下载完成的目录内存在该文件)
    if ([KingDownLoadManagerFileTool fileExistsAtPath:self.downloadedPath]) {
        
//    return 下载完成 传递相关信息
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
    NSURLSessionDataTask *dataTask=[self.session dataTaskWithRequest:request];
    //重新挂起task
    [dataTask resume];
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
    if (_tempSize == _totalSize) {
        //移动到下载完成文件夹
        [KingDownLoadManagerFileTool moveFile:self.downloadingPath toPath:self.downloadedPath];
//        取消本次请求
        completionHandler(NSURLSessionResponseCancel);
        return;
    }
    if (_tempSize>_totalSize) {
//        删除
        [KingDownLoadManagerFileTool removeFile:self.downloadingPath];
//        从0开始下载
        [self downLoadWithUrl:self.url];
//        取消本次请求
        completionHandler(NSURLSessionResponseCancel);
        return;
    }
    completionHandler(NSURLSessionResponseAllow);
}
//确定接收数据调用
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    
}
//请求终结调用
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    
}

@end
