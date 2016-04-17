//
//  LEDDownloadManager2.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/16.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDDownloadManager2.h"
#import <UIKit/UIKit.h>


// 可以同时支持多任务执行

@interface LEDDownloadManager2 ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfigure;
@property (nonatomic, strong) NSURLSession* session;
@property (nonatomic, strong) NSMutableDictionary *downloadTaskDic;
@property (nonatomic, strong) NSMutableArray *downloadTaskArray;

@property (nonatomic, strong) NSMutableDictionary *fileHandlerDic;

//@property (nonatomic, strong) NSURLSessionDataTask *currentDownloadTask;

@end

@implementation LEDDownloadManager2

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static LEDDownloadManager2 *manager = nil;
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
        __weak id weakself = self;
        _session = [NSURLSession sessionWithConfiguration:_sessionConfigure delegate:weakself delegateQueue:nil];
        _downloadTaskDic = [NSMutableDictionary dictionary];
        _downloadTaskArray = [NSMutableArray array];
        _fileHandlerDic = [NSMutableDictionary dictionary];
    }
    return self;
}

// 执行任务
- (void)startDownloadWithURL:(NSURL *)url
{
    if (!url || [url.absoluteString length] == 0) {
        return;
    }
    
    NSURLSessionDataTask *downloadTask2 = [self.downloadTaskDic objectForKey:url.absoluteString];
    if (downloadTask2) {
        return;
    }
    
    //
    NSString *urlString = url.absoluteString;
    NSRange range = [urlString rangeOfString:@"/" options:NSBackwardsSearch];
    if (range.location == NSNotFound || (range.location + range.length) >= [urlString length]) {
        return;
    }
    NSString *fileName = [urlString substringFromIndex:range.location + 1];
    //
    if ([fileName length] == 0) {
        return;
    }
    NSString *filePathName = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
    // 创建文件
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePathName]) {
        [[NSFileManager defaultManager] createFileAtPath:filePathName contents:nil attributes:nil];
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePathName];
    if (!fileHandle) {
        return;
    }
    [self.fileHandlerDic setObject:fileHandle forKey:url.absoluteString];
    
    NSUInteger filesize = [self getFileSizeByFilepath:filePathName];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    
    //设置请求头信息
    NSString* header = [NSString stringWithFormat:@"bytes=%zd-", filesize];
    [request setValue:header forHTTPHeaderField:@"Range"];
    
    NSURLSessionDataTask *downloadTask = [self.session dataTaskWithRequest:request];
    [self.downloadTaskDic setObject:downloadTask forKey:url.absoluteString];
    [self.downloadTaskArray addObject:downloadTask];
    //
    
    
    [downloadTask resume];
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

- (void)cancelAll
{
    [self.downloadTaskArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURLSessionDataTask *downloadTask = (NSURLSessionDataTask*)obj;
        [downloadTask cancel];
    }];
//    [self.downloadTaskArray removeAllObjects];
//    [self.downloadTaskDic removeAllObjects];
//    [self.fileHandlerDic removeAllObjects];
}


#pragma mark - private

- (NSInteger)getFileSizeByFilepath:(NSString *)filepath
{
    //0.拼接文件全路径
//    NSString* fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:filepath];
    
    //先把沙盒中的文件大小取出来
    NSDictionary* dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filepath error:nil];
    NSInteger size = [[dict objectForKey:@"NSFileSize"] integerValue];
    return size;
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
    NSString *urlString = dataTask.currentRequest.URL.absoluteString;
    NSFileHandle *fileHandle = [self.fileHandlerDic objectForKey:urlString];
    if (!fileHandle) {
        return;
    }
    // 写入数据
    /*
     NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
     
     [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
     
     
     NSData* stringData  = [string dataUsingEncoding:NSUTF8StringEncoding];
     
     [fileHandle writeData:stringData]; //追加写入数据
     
     [fileHandle closeFile];
     */
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:data];
    
    NSLog(@"%@",[dataTask.currentRequest.URL absoluteString]);
}

//3.当整个请求结束的时候调用,error有值的话,那么说明请求失败
- (void)URLSession:(NSURLSession*)session task:(NSURLSessionTask*)task didCompleteWithError:(NSError*)error
{
    
    // 当调用 stopDownloadWithURL 的时候，也会执行该方法，但是error 不为空
    NSString *ttt = [task.currentRequest.URL absoluteString];
    NSLog(@"3-------%@",[task.currentRequest.URL absoluteString]);
    
    NSString *str = @"下载完成";
    if (error) {
        str = @"下载失败";
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:str message:ttt  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    });
    [self.downloadTaskDic removeObjectForKey:ttt];
    [self.downloadTaskArray removeObject:task];
    //
    NSFileHandle *handler = [self.fileHandlerDic objectForKey:ttt];
    [handler closeFile];
    [self.fileHandlerDic removeObjectForKey:ttt];
}

// dealloc
- (void)dealloc
{
    
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
