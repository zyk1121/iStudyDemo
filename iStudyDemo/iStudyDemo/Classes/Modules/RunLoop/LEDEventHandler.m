//
//  LEDEventHandler.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/30.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDEventHandler.h"
#import "LEDEventProtocol.h"

@interface LEDEventHandler ()
{
    NSMutableArray *_listenerArray;
}

@end

@implementation LEDEventHandler


+ (instancetype)sharedEventHandler
{
    static LEDEventHandler *_sharedKit = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedKit = [[self alloc] init];
    });
    
    return _sharedKit;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _enabled = YES;
        _defaultQueue = dispatch_get_main_queue();
        _listenerArray = [[NSMutableArray alloc] init];
    }
    return self;
}

// 添加一个监听者
- (BOOL)addEventListener:(id<LEDEventProtocol>)listener
{
    if (listener && ![_listenerArray containsObject:listener]) {
        [_listenerArray addObject:listener];
        return YES;
    }
    return NO;
}
// 移除一个监听者
- (BOOL)removeEventListener:(id<LEDEventProtocol>)listener
{
    if (listener && [_listenerArray containsObject:listener]) {
        [_listenerArray removeObject:listener];
        return YES;
    }
    return NO;
}
// 移除所有监听者
- (BOOL)removeAllEventListener
{
    [_listenerArray removeAllObjects];
    return YES;
}

- (void)addEventToQueue:(NSUInteger)eventID message:(id)message
{
    dispatch_async(_defaultQueue, ^{
        if (!_enabled) {
            return ;
        }
        sleep(2);//  同步sleep
//        [NSThread sleepForTimeInterval:2];
        [_listenerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id<LEDEventProtocol> eventListener = obj;
            // 给 eventListener  发送消息
            [eventListener test];
//            NSLog(@"%@,%ld,%@",eventListener,(unsigned long)eventID,message);
        }];
    });
}

@end
