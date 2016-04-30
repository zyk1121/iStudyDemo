//
//  LEDEventHandler.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/30.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LEDEventProtocol;

@interface LEDEventHandler : NSObject

+ (instancetype)sharedEventHandler;

// 默认为YES
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;
@property (nonatomic, assign) dispatch_queue_t defaultQueue; // 默认是主队列

// 添加一个监听者
- (BOOL)addEventListener:(id<LEDEventProtocol>)listener;
// 移除一个监听者
- (BOOL)removeEventListener:(id<LEDEventProtocol>)listener;
// 移除所有监听者
- (BOOL)removeAllEventListener;

// 添加一个队列和消息
- (void)addEventToQueue:(NSUInteger)eventID message:(id)message;

@end
