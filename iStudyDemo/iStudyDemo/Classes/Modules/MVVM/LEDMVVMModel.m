//
//  LEDMVVMModel.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/10.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDMVVMModel.h"

@implementation LEDMVVMModel

#pragma mark - init

- (instancetype)init
{
    self = [super init];

    if (self) {
    }

    return self;
}

#pragma mark - public method

- (RACSignal*)fetchDataSignal
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self fetchDataFinished:^(NSDictionary* data, NSError* error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:data];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

#pragma mark - private method

- (void)fetchDataFinished:(void (^)(NSDictionary* data, NSError* error))finished
{
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"]; // 设置请求方式
    [request setURL:[NSURL URLWithString:@"http://vmap.ishowchina.com/offline/resource?mapver=20160314"]]; // 设置网络请求的URL
    [request setTimeoutInterval:10]; // 设置超出时间 10s
    // 发送异步请求
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError) {
        // 返回结果
        NSError* error = nil;
        if (connectionError) {
            error = connectionError;
        }
        else {
            id jsonData = nil;
            if (data) {
                jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                if (finished) {
                    // main thread
                    dispatch_async(dispatch_get_main_queue(), ^{
                       finished(jsonData, error);
                    });
                }
            }
        }
        if (error && finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // main thread
                finished(nil, error);
            });
        }
    }];
}

@end
