//
//  KingDownloadManagerInfo.h
//  KingDownloadManagerDemo
//
//  Created by J on 2017/6/14.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KingDownLoader.h"
#import "NSString+MD5.h"
@interface KingDownloadManagerInfo : NSMutableDictionary
-(KingDownLoader *)getDownLoaderWithURL:(NSURL *)url;
-(KingDownLoader *)MD5URL:(NSURL *)url;
@end
