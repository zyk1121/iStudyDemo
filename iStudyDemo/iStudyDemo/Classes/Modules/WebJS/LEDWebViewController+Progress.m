//
//  LEDWebViewController+Progress.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//
//

#import "LEDWebViewController+Progress.h"
#import "UIViewAdditions.h"
#import "ReactiveCocoa.h"
#import "UIKitMacros.h"

static BOOL progressEnabled = NO;

@implementation LEDWebViewController (Progress)

+ (BOOL)progressEnabled
{
    return progressEnabled;
}

+ (void)enableProgress:(BOOL)isEnabled;
{
    progressEnabled = isEnabled;
}

@end


typedef NS_ENUM(NSUInteger, SAKWebViewStatus) {
    SAKWebViewNoneStatus,
    SAKWebViewCompletedStatus,
    SAKWebViewLoadingStatus,
    SAKWebViewErrorStatus,
};

static float const kProgressBarHeight = 2.0;
static float const kBaseVelocity = 0.1 / 60;

// PM说先匀速到0.8 再减速
static inline float velocity(float progress) {
    return (progress <= 0.8) ? kBaseVelocity * 4 : kBaseVelocity / 4.0;
};

@interface LEDWebViewControllerProgressProxy()

@property (nonatomic, assign) SAKWebViewStatus status;
@property (nonatomic, strong) CADisplayLink *timer;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation LEDWebViewControllerProgressProxy

- (instancetype)initWithLEDWebViewController:(LEDWebViewController *)viewController
{
    if (self = [super init]) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progressView.tintColor = HEXCOLOR(0x06c1ae);
        
        @weakify(self, viewController)
        [[viewController rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
            @strongify(self, viewController)
            //
            [viewController.navigationController.navigationBar addSubview:self.progressView];
            UINavigationBar *navigationBar = viewController.navigationController.navigationBar;
            self.progressView.frame = CGRectMake(0,  navigationBar.height - kProgressBarHeight, navigationBar.width, kProgressBarHeight);
            self.progressView.progress = 0.f;
            self.progressView.trackTintColor = navigationBar.barTintColor;
            self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            
            self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress:)];
            self.timer.paused = YES;
            [self.timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        }];
        [[viewController rac_signalForSelector:@selector(viewWillDisappear:)] subscribeNext:^(id x) {
            @strongify(self)
            self.timer.paused = YES;
            [self.timer invalidate];
            self.timer = nil;
            
            [self.progressView removeFromSuperview];
        }];
        [[viewController rac_signalForSelector:@selector(webViewDidStartLoad:)] subscribeNext:^(id x) {
            @strongify(self)
            self.status = SAKWebViewLoadingStatus;
            self.timer.paused = NO;
        }];
        [[viewController rac_signalForSelector:@selector(webViewDidFinishLoad:)] subscribeNext:^(id x) {
            @strongify(self)
            self.status = SAKWebViewCompletedStatus;
        }];
        [[viewController rac_signalForSelector:@selector(webView:didFailLoadWithError:)] subscribeNext:^(id x) {
            @strongify(self)
            self.status = SAKWebViewErrorStatus;
        }];
        [viewController.rac_willDeallocSignal subscribeCompleted:^{
            @strongify(self)
            [self.timer invalidate];
            self.timer = nil;
        }];
    }
    
    return self;
}

- (void)updateProgress: (CADisplayLink *)displayLink
{
    switch (self.status) {
        case SAKWebViewNoneStatus: {
            break;
        }
        case SAKWebViewCompletedStatus: {
            if (self.progressView.progress >= 1) {
                self.progressView.progress = 0;
                self.progressView.hidden = YES;
                self.timer.paused = YES;
            } else {
                self.progressView.progress += kBaseVelocity * pow(2, 5); // 速度快显得屌一点
            }
            break;
        }
        case SAKWebViewLoadingStatus: {
            self.timer.paused = NO;
            self.progressView.hidden = NO;
            self.progressView.progress = MIN(0.95, self.progressView.progress + velocity(self.progressView.progress));
            break;
        }
        case SAKWebViewErrorStatus: {
            self.progressView.progress = 0;
            self.progressView.hidden = YES;
            self.timer.paused = YES;
            break;
        }
            
        default: {
            break;
        }
    }
}

@end


