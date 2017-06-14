//
//  KingDownloadManagerInfo.m
//  KingDownloadManagerDemo
//
//  Created by J on 2017/6/14.
//  Copyright © 2017年 J. All rights reserved.
//

#import "KingDownloadManagerInfo.h"
@implementation KingDownloadManagerInfo
-(KingDownLoader *)getDownLoaderWithURL:(NSURL *)url
{
    NSString *urlMD5=[url.absoluteString MD5];
    KingDownLoader *downloader =[self objectForKey:urlMD5];
    if (!downloader) {
        downloader=[[KingDownLoader alloc]init];
        [self setObject:downloader forKey:urlMD5];
    }
    return downloader;
}

-(KingDownLoader *)MD5URL:(NSURL *)url
{
    if (!url.absoluteString.length) {
        return nil;
    }
    NSString *urlMD5=[url.absoluteString MD5];
    return [self objectForKey:urlMD5];
}
@end
