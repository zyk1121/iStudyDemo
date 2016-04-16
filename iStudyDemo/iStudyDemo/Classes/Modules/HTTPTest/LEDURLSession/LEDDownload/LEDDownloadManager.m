//
//  LEDDownloadManager.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/16.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDDownloadManager.h"
#import <UIKit/UIKit.h>

// http://www.jianshu.com/p/fafc67475c73
// http://blog.csdn.net/majiakun1/article/details/38133433

@interface LEDDownloadManager () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfigure;
@property (nonatomic, strong) NSURLSession* session;
@property (nonatomic, strong) NSMutableDictionary *downloadTaskDic;
@property (nonatomic, strong) NSMutableArray *downloadTaskArray;

@property (nonatomic, strong) NSURLSessionDataTask *currentDownloadTask;

@end

@implementation LEDDownloadManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static LEDDownloadManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sessionConfigure = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sessionConfigure.discretionary = YES;
        _session = [NSURLSession sessionWithConfiguration:_sessionConfigure delegate:self delegateQueue:nil];
        _downloadTaskDic = [NSMutableDictionary dictionary];
        _downloadTaskArray = [NSMutableArray array];
    }
    return self;
}

// 添加到队列
- (void)addDownloadWithURL:(NSURL *)url
{
    if (!url || [url.absoluteString length] == 0) {
        return;
    }
    
    NSURLSessionDataTask *downloadTask2 = [self.downloadTaskDic objectForKey:url.absoluteString];
    if (downloadTask2) {
        return;
    }
    //
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    
    //设置请求头信息
    NSString* header = [NSString stringWithFormat:@"bytes=%zd-", 0];
    [request setValue:header forHTTPHeaderField:@"Range"];
    
    NSURLSessionDataTask *downloadTask = [self.session dataTaskWithRequest:request];
    [self.downloadTaskDic setObject:downloadTask forKey:url.absoluteString];
    [self.downloadTaskArray addObject:downloadTask];

}

// 执行任务
- (void)startDownloadWithURL:(NSURL *)url
{
    if (!url || [url.absoluteString length] == 0) {
        return;
    }
    NSURLSessionDataTask *downloadTask = [self.downloadTaskDic objectForKey:url.absoluteString];
    if (downloadTask == self.currentDownloadTask) {
        return;
    }
    if (downloadTask) {
        // 可以执行该任务
        // 取消当前正在执行的任务
        if (self.currentDownloadTask) {
            [self.currentDownloadTask cancel];
            self.currentDownloadTask = nil;
        }
        // 执行新的任务
        [downloadTask resume];
        self.currentDownloadTask = downloadTask;
    }
}

// 取消任务
- (void)cancelDownloadWithURL:(NSURL *)url
{
    if (!url || [url.absoluteString length] == 0) {
        return;
    }
    NSURLSessionDataTask *downloadTask = [self.downloadTaskDic objectForKey:url.absoluteString];
    [downloadTask cancel];
}


#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession*)session dataTask:(NSURLSessionDataTask*)dataTask didReceiveResponse:(NSURLResponse*)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
      //此处注意,不设置为allow,其它delegate methods将不被执行
     completionHandler(NSURLSessionResponseAllow);
}

//2.当接受到服务器返回的数据的时候调用,会调用多次
- (void)URLSession:(NSURLSession*)session dataTask:(NSURLSessionDataTask*)dataTask didReceiveData:(NSData*)data
{
    
    NSLog(@"%@",[dataTask.currentRequest.URL absoluteString]);
}

//3.当整个请求结束的时候调用,error有值的话,那么说明请求失败
- (void)URLSession:(NSURLSession*)session task:(NSURLSessionTask*)task didCompleteWithError:(NSError*)error
{

    // 当调用 stopDownloadWithURL 的时候，也会执行该方法，但是error 不为空
    NSString *ttt = [task.currentRequest.URL absoluteString];
     NSLog(@"3-------%@",[task.currentRequest.URL absoluteString]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"下载完成" message:ttt  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    });
    [self.downloadTaskDic removeObjectForKey:ttt];
    [self.downloadTaskArray removeObject:task];
    
    if (!error) {
        // 正常结束
        // 开始下一个任务
        if ([self.downloadTaskArray count]) {
            self.currentDownloadTask = self.downloadTaskArray[0];
            [self.currentDownloadTask resume];
        }
    }
}

#pragma mark - NSURLSessionDownloadDelegate



//    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"downloadTaskWithURL:completionHandler");
//    }];



/* Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
//didFinishDownloadingToURL:(NSURL *)location
//{
//    // 结束后会执行，会得到文件的路径location,默认在 tmp 目录下，可以移动该文件
//     NSLog(@"didFinishDownloadingToURL");
//}
//
//
///* Sent periodically to notify the delegate of download progress. */
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
//      didWriteData:(int64_t)bytesWritten
// totalBytesWritten:(int64_t)totalBytesWritten
//totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
//{
//    // 会执行
//     NSLog(@"totalBytesExpectedToWrite");
//}
//
///* Sent when a download has been resumed. If a download failed with an
// * error, the -userInfo dictionary of the error will contain an
// * NSURLSessionDownloadTaskResumeData key, whose value is the resume
// * data.
// */
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
// didResumeAtOffset:(int64_t)fileOffset
//expectedTotalBytes:(int64_t)expectedTotalBytes
//{
//     NSLog(@"expectedTotalBytes");
//}

@end
