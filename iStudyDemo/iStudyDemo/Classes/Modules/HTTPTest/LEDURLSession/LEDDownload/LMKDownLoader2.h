//
//  LMKDownLoader2.h
//  LeadorMapSDK
//
//  Created by zhangyuanke on 16/5/7.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LMKDownLoaderItemProgress;

@protocol LMKDownLoaderProtocol <NSObject>

@optional
/**
 *  下载进度
 *
 *  @param url         下载的URL
 *  @param currentSize 当前的数据大小
 */
- (void)downLoaderProgressWithURL:(NSURL *)url progress:(LMKDownLoaderItemProgress *)progress;

/**
 *  下载完成
 *
 *  @param url 下载的URL
 */
- (void)downLoaderCompletionWithURL:(NSURL *)url;

/**
 *  下载出错
 *
 *  @param url           下载的URL
 *  @param downloadError 错误信息
 */
- (void)downLoaderErrorWithURL:(NSURL *)url error:(NSError *)downloadError;

@end

/**
 *  下载管理类
 */
@interface LMKDownLoader2 : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, weak) id<LMKDownLoaderProtocol> delegate;

// 开始添加某一个下载任务到队列
- (void)startDownloadWithURL:(NSURL *)url;

// 从队列中取消某一个下载任务
- (void)cancelDownloadWithURL:(NSURL *)url;

// 取消队列中的所有下载任务
- (void)cancelAll;

@end

/**
 *  记录当前下载文件的进度
 */
@interface LMKDownLoaderItemProgress : NSObject

@property (nonatomic, assign) NSUInteger totalSize;
@property (nonatomic, assign) NSUInteger currentSize;

@end
