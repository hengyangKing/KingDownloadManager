//
//  KingDownLoadConfig.m
//  Pods-KingDownloadManagerDemo
//
//  Created by king on 2018/5/11.
//

#import "KingDownLoadConfig.h"
#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

@implementation KingDownLoadConfig
-(void)setUrl:(NSURL *)url {
    _url = url;
}
-(void)setSavePath:(NSString *)savePath {
    _savePath = savePath;
}
-(void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    _timeoutInterval = timeoutInterval;
}

-(KingDownLoadConfig *(^)(NSURL *))YQURL {
    return ^(NSURL *url){
        self.url = url;
        return self;
    };
}
-(KingDownLoadConfig *(^)(NSString *))YQSavePath {
    return ^(NSString *path){
        self.savePath = path;
        return self;
    };
}
-(KingDownLoadConfig *(^)(NSTimeInterval))YQTimeoutInterval {
    return ^(NSTimeInterval time){
        self.timeoutInterval = time;
        return self;
    };
}
+(instancetype)defaultConfig{
    KingDownLoadConfig *config = [[KingDownLoadConfig alloc]init];
    config.YQTimeoutInterval(100).YQSavePath(kCachePath);
    return config;
}

-(BOOL)guardConfig{
    if (!self.savePath.length) {return NO;}
    if (!self.url) {return NO;}
    if (!self.url.absoluteString.length) {return NO;}
    return YES;
}
@end
