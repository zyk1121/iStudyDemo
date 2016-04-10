//
//  LEDMVVMModel.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/10.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "ReactiveCocoa/ReactiveCocoa.h"
#import <Foundation/Foundation.h>

// 处理网络数据请求相关，可以写一个网络处理的基类，然后所有model继承它处理网络
/*
 @interface SPKModel : SAKBaseModel
 
 @property (nonatomic, copy) NSString *version;
 @property (nonatomic, copy) NSString *domain;
 
 - (void)postToPaymentPath:(NSString *)path
 parameter:(NSDictionary *)parameter
 finished:(SAKModelRequestCallback)finishied;
 
 - (void)postToPaymentPath:(NSString *)path
 parameter:(NSDictionary *)parameter
 hasFingerprint:(BOOL)hasFingerprint
 finished:(SAKModelRequestCallback)finishied;
 
 - (SAKError *)actualErrorFromResponse:(NSDictionary *)responseDictionary
 originalError:(SAKError *)originalError;
 
 @end
 */

@interface LEDMVVMModel : NSObject

- (RACSignal*)fetchDataSignal;

@end
