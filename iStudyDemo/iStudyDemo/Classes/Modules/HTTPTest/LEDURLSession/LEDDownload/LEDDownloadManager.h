//
//  LEDDownloadManager.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/16.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEDDownloadManager : NSObject

+ (instancetype)sharedManager;

// 添加到队列
- (void)addDownloadWithURL:(NSURL *)url;
// 开始执行
- (void)startDownloadWithURL:(NSURL *)url;
// 取消任务
- (void)cancelDownloadWithURL:(NSURL *)url;

@end
