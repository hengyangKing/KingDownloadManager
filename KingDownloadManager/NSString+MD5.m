//
//  NSString+MD5.m
//  KingDownloadManagerDemo
//
//  Created by J on 2017/6/14.
//  Copyright © 2017年 J. All rights reserved.
//

#import "NSString+MD5.h"
//#import "<Security/Security.h>"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)
-(NSString *)MD5
{
    const char *data=self.UTF8String;
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    //    char --->md5 char
    CC_MD5(data, (CC_LONG)strlen(data), md);
//    md 转32位字符串
    NSMutableString *result=[NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x",md[i]];
    }
    return result;
}
@end
