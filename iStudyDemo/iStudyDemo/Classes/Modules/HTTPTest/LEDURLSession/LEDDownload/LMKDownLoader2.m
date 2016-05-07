//
//  LMKDownLoader2.m
//  LeadorMapSDK
//
//  Created by zhangyuanke on 16/5/7.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LMKDownLoader2.h"

@interface LMKDownLoader2 ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfigure;
@property (nonatomic, strong) NSURLSession* session;
@property (nonatomic, strong) NSMutableDictionary *downloadTaskDic; // 当前正在下载的任务字典
@property (nonatomic, strong) NSMutableArray *downloadTaskArray; // 当前正在下载的任务队列

@property (nonatomic, strong) NSMutableDictionary *fileHandlerDic; // 存放文件handler
@property (nonatomic, strong) NSMutableDictionary *downloadProgress; // 文件下载进度记录

@end

@implementation LMKDownLoader2

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static LMKDownLoader2 *manager = nil;
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
        _downloadProgress = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)startDownloadWithURL:(NSURL *)url
{
    if (!url || [url.absoluteString length] == 0) {
        return;
    }
    
    // 判断当前正在下载
    NSURLSessionDataTask *downloadTaskTemp = [self.downloadTaskDic objectForKey:url.absoluteString];
    if (downloadTaskTemp) {
        return;
    }
    
    // 文件名
    NSString *urlString = url.absoluteString;
    NSRange range = [urlString rangeOfString:@"/" options:NSBackwardsSearch];
    if (range.location == NSNotFound || (range.location + range.length) >= [urlString length]) {
        return;
    }
    NSString *fileName = [urlString substringFromIndex:range.location + 1];
    if ([fileName length] == 0) {
        return;
    }
    // 文件路径
    NSString *filePathName = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
    // 创建文件
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePathName]) {
        [[NSFileManager defaultManager] createFileAtPath:filePathName contents:nil attributes:nil];
    }
    
    // 文件句柄
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePathName];
    if (!fileHandle) {
        return;
    }
    [self.fileHandlerDic setObject:fileHandle forKey:url.absoluteString];
    
    // 当前文件大小
    NSUInteger filesize = [self getFileSizeByFilepath:filePathName];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    
    // 设置请求头信息
    NSString* header = [NSString stringWithFormat:@"bytes=%zd-", filesize];
    [request setValue:header forHTTPHeaderField:@"Range"];
    
    NSURLSessionDataTask *downloadTask = [self.session dataTaskWithRequest:request];
    [self.downloadTaskDic setObject:downloadTask forKey:url.absoluteString];
    [self.downloadTaskArray addObject:downloadTask];
    // 当前进度
    LMKDownLoaderItemProgress *progress = [[LMKDownLoaderItemProgress alloc] init];
    progress.currentSize = filesize;
    [self.downloadProgress setObject:progress forKey:url.absoluteString];
    // 开始执行
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
}


#pragma mark - private

- (NSInteger)getFileSizeByFilepath:(NSString *)filepath
{
    // 先把沙盒中的文件大小取出来
    NSDictionary* dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filepath error:nil];
    NSInteger size = [[dict objectForKey:@"NSFileSize"] integerValue];
    return size;
}


#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession*)session dataTask:(NSURLSessionDataTask*)dataTask didReceiveResponse:(NSURLResponse*)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    // 此处注意,不设置为allow,其它delegate methods将不被执行
    completionHandler(NSURLSessionResponseAllow);
    // 请求下载文件大小
    NSString *urlString = dataTask.currentRequest.URL.absoluteString;
    LMKDownLoaderItemProgress *progress = [self.downloadProgress objectForKey:urlString];
    NSDictionary *dictResponse = [(NSHTTPURLResponse*)response allHeaderFields];
    NSString *contentRange = [dictResponse objectForKey:@"Content-Range"];
    if ([contentRange length]) {
        NSRange range = [contentRange rangeOfString:@"/" options:NSBackwardsSearch];
        if (range.location == NSNotFound) {
            progress.totalSize = 0;
            return;
        }
        NSString *totalSizeStr = [contentRange substringFromIndex:range.location + 1];
        if ([totalSizeStr length]) {
            NSInteger totalSize = [totalSizeStr integerValue];
            progress.totalSize = totalSize;
        } else {
            progress.totalSize = 0;
        }
    } else {
        progress.totalSize = 0;
    }
}

// 当接受到服务器返回的数据的时候调用, 会调用多次
- (void)URLSession:(NSURLSession*)session dataTask:(NSURLSessionDataTask*)dataTask didReceiveData:(NSData*)data
{
    NSString *urlString = dataTask.currentRequest.URL.absoluteString;
    NSFileHandle *fileHandle = [self.fileHandlerDic objectForKey:urlString];
    if (!fileHandle) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [[NSError alloc] initWithDomain:@"文件句柄错误，取消该下载任务。" code:-1 userInfo:nil];
            if ([self.delegate respondsToSelector:@selector(downLoaderErrorWithURL:error:)]) {
                [self.delegate downLoaderErrorWithURL:dataTask.currentRequest.URL error:error];
            }
        });
        [dataTask cancel];
        return;
    }
    
    // 进度回传
    LMKDownLoaderItemProgress *progress = [self.downloadProgress objectForKey:urlString];
    if (progress.totalSize >= (progress.currentSize + data.length)) {
        // 写入数据
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:data];
        progress.currentSize += data.length;
    } else {
        // 下载完成
        progress.totalSize = progress.currentSize;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(downLoaderProgressWithURL:progress:)]) {
            [self.delegate downLoaderProgressWithURL:dataTask.currentRequest.URL progress:progress];
        }
    });
}

// 当整个请求结束的时候调用, error有值的话, 那么说明请求失败
- (void)URLSession:(NSURLSession*)session task:(NSURLSessionTask*)task didCompleteWithError:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
            if ([self.delegate respondsToSelector:@selector(downLoaderErrorWithURL:error:)]) {
                [self.delegate downLoaderErrorWithURL:task.currentRequest.URL error:error];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(downLoaderCompletionWithURL:)]) {
                [self.delegate downLoaderCompletionWithURL:task.currentRequest.URL];
            }
        }
    });
    // 清空
    NSString *urlString = [task.currentRequest.URL absoluteString];
    
    [self.downloadTaskDic removeObjectForKey:urlString];
    [self.downloadTaskArray removeObject:task];
    //
    NSFileHandle *handler = [self.fileHandlerDic objectForKey:urlString];
    [handler closeFile];
    [self.fileHandlerDic removeObjectForKey:urlString];
}

@end

/**
 *  下载进度
 */
@implementation LMKDownLoaderItemProgress

@end