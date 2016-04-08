//
//  LEDModalView.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/4.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDModalView.h"

static LEDModalView *ledModelView;
static UITapGestureRecognizer *singleTap;
static UIView *customView;
@interface LEDModalView ()

@end

@implementation LEDModalView

+ (void)showWithCustomView:(UIView *)view
{
    if (ledModelView) {
        [LEDModalView removed];
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //背景色
    ledModelView = [[LEDModalView alloc] initWithFrame:window.bounds];
    ledModelView.backgroundColor = [UIColor blackColor];
    ledModelView.alpha = 0.5;
    //添加手势 点击背景能够回收菜单
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:ledModelView action:@selector(handleRemoved)];
    [ledModelView addGestureRecognizer:singleTap];
    [window addSubview:ledModelView];
    //
    customView = view;
    [window addSubview:view];
}

+ (void)hide
{
    [self removed];
}

#pragma mark - private method

+ (void)removed {
    [ledModelView removeGestureRecognizer:singleTap];
    singleTap = nil;
    [ledModelView removeFromSuperview];
    ledModelView = nil;
    [customView removeFromSuperview];
    customView = nil;
}

- (void)handleRemoved {
    if (ledModelView) {
        [LEDModalView removed];
    }
}

- (void)dealloc
{
}

@end
