//
//  LEDDownloadManager2.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/16.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEDDownloadManager2 : NSObject

+ (instancetype)sharedManager;

// 开始执行
- (void)startDownloadWithURL:(NSURL *)url;
// 取消任务
- (void)cancelDownloadWithURL:(NSURL *)url;

- (void)cancelAll;
@end
