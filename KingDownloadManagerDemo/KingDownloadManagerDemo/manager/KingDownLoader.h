//
//  KingDownLoader.h
//  KingDownloadManagerDemo
//
//  Created by J on 2017/6/14.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>
//单任务下载器
@interface KingDownLoader : NSObject
//下载任务
-(void)downLoadWithUrl:(NSURL *)url;

//暂停任务
-(void)pauseCurrentTask;

//取消任务
-(void)cacelCurrentTask;

//取消和清空
-(void)cacelAndClean;



@end
