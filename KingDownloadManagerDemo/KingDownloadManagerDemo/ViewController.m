//
//  ViewController.m
//  KingDownloadManagerDemo
//
//  Created by J on 2017/6/14.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ViewController.h"
#import "KingDownLoadManager.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)download:(id)sender {
    
    NSString *str=@"http://pop.nosdn.127.net/bd17bcf2-ce68-4c03-bfff-2e8e9f9dd813.jpg?imageView&thumbnail=64x0&quality=85";
    [[KingDownLoadManager shareInstance]downLoadWithUrl:[NSURL URLWithString:str] andState:^(KingDownLoaderState newState) {
        NSLog(@"newState---%@",@(newState));
    } andProgress:^(float progress) {
        NSLog(@"progress---%@",@(progress));
    } andSuccess:^(NSString *filePath) {
        NSLog(@"filePath--%@",filePath);
    } andFailed:^(NSError *error) {
        NSLog(@"error--%@",error);
    }];
}
- (IBAction)pause:(id)sender {
    [[KingDownLoadManager shareInstance] pauseAll];
}
- (IBAction)cacel:(id)sender {
    [[KingDownLoadManager shareInstance] cacelAll];

}
- (IBAction)path:(id)sender {
    
    NSLog(@"%@",NSHomeDirectory());
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
