//
//  YUKModalView.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/8/7.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YUKModalViewType) {
    YUKModalViewTypeCustom,
    YUKModalViewTypeToast,
    YUKModalViewTypeAlert,
    YUKModalViewTypeProgress,
};

@protocol YUKModalViewDelegate <NSObject>

@optional
// 背景被点击，可以隐藏当前视图
- (void)modalViewBackgroundTouched;

@end

@interface YUKModalView : UIView

// 显示自定义view
+ (void)showWithCustomView:(UIView *)customView delegate:(id<YUKModalViewDelegate>)delegate type:(YUKModalViewType)type;
// 强制显示自定义view
+ (void)showWithCustomView:(UIView *)customView delegate:(id<YUKModalViewDelegate>)delegate type:(YUKModalViewType)type forced:(BOOL)forced;
// 隐藏当前View
+ (void)dismiss;

@end
