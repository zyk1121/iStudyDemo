//
//  AppDelegate.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/6.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
// 本地推送通知
// 设置本地通知
+ (void)registerLocalNotification:(NSInteger)alertTime;

@end

