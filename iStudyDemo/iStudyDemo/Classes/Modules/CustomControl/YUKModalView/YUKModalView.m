//
//  YUKModalView.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/8/7.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "YUKModalView.h"

static YUKModalView *gYUKModelView;             // 全局modalView
static UITapGestureRecognizer *gYUKSingleTap;   // 当前View的手势
static UIView *gYUKCustomView;                  // 自定义View

@interface YUKModalView ()

@property (nonatomic, weak) id<YUKModalViewDelegate> delegate;
@property (nonatomic, assign) BOOL canBackgroundTap; // 默认为NO，设置YES可以通过点击背景隐藏销毁当前View

@end

@implementation YUKModalView

+ (void)showWithCustomView:(UIView *)customView delegate:(id<YUKModalViewDelegate>)delegate forced:(BOOL)forced
{
    if (!customView || ![customView isKindOfClass:[UIView class]]) {
        return;
    }
    if (!forced && gYUKModelView) {
        return;
    }
    if (forced && gYUKModelView) {
        if (gYUKModelView) {
            [YUKModalView removed];
        }
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    gYUKModelView = [[YUKModalView alloc] initWithFrame:window.bounds];
    gYUKModelView.delegate = delegate;
    gYUKModelView.backgroundColor = [UIColor blackColor];
    gYUKModelView.alpha = 0.5;
    [window addSubview:gYUKModelView];
    gYUKCustomView = customView;
    [window addSubview:customView];
    [gYUKModelView setCanBackgroundTap:YES];
}

+ (void)showWithCustomView:(UIView *)customView delegate:(id<YUKModalViewDelegate>)delegate
{
    [self showWithCustomView:customView delegate:delegate forced:NO];
}

+ (void)dismiss
{
    [self removed];
}

- (void)dealloc
{

}

#pragma mark setter & getter

- (void)setCanBackgroundTap:(BOOL)canBackgroundTap
{
    _canBackgroundTap = canBackgroundTap;
    if (canBackgroundTap) {
        if (gYUKModelView) {
            gYUKSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:gYUKModelView action:@selector(handleBackgroundTouched)];
            [gYUKModelView addGestureRecognizer:gYUKSingleTap];
        }
    } else {
        if (gYUKModelView) {
            [gYUKModelView removeGestureRecognizer:gYUKSingleTap];
            gYUKSingleTap = nil;
        }
    }
}

#pragma mark - private method

+ (void)removed
{
    if (gYUKModelView && gYUKSingleTap) {
        [gYUKModelView removeGestureRecognizer:gYUKSingleTap];
        gYUKSingleTap = nil;
    }
    if (gYUKCustomView) {
        [gYUKCustomView removeFromSuperview];
        gYUKCustomView = nil;
    }
    if (gYUKModelView) {
        [gYUKModelView removeFromSuperview];
        gYUKModelView = nil;
    }
}

#pragma mark - 手势Handelr

- (void)handleBackgroundTouched
{
    if (gYUKModelView && gYUKModelView.delegate && [gYUKModelView.delegate respondsToSelector:@selector(modalViewBackgroundTouched)]) {
        [gYUKModelView.delegate modalViewBackgroundTouched];
    }
}

@end
