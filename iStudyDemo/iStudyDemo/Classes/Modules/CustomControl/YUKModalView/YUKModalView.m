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

+ (void)showWithCustomView:(UIView *)customView delegate:(id<YUKModalViewDelegate>)delegate type:(YUKModalViewType)type forced:(BOOL)forced
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
    switch (type) {
        case YUKModalViewTypeCustom:
            [gYUKModelView setCanBackgroundTap:YES];
            gYUKModelView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            break;
        case YUKModalViewTypeToast:
            [gYUKModelView setCanBackgroundTap:NO];
            gYUKModelView.backgroundColor = [UIColor clearColor];
//            gYUKModelView.userInteractionEnabled = NO;
            break;
        case YUKModalViewTypeAlert:
            
            break;
        case YUKModalViewTypeProgress:
            
            break;
            
        default:
            break;
    }
    gYUKModelView.delegate = delegate;
    gYUKCustomView = customView;
    [window addSubview:gYUKModelView];
    [window addSubview:customView];
    /* 动画支持
    CGRect frame = customView.frame;
    customView.frame = CGRectMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height / 2, 0, 0);
    [UIView animateWithDuration:0.3 animations:^{
        customView.frame = frame;
    }];
     */
}

+ (void)showWithCustomView:(UIView *)customView delegate:(id<YUKModalViewDelegate>)delegate type:(YUKModalViewType)type
{
    [self showWithCustomView:customView delegate:delegate type:type forced:NO];
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
