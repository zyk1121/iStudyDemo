//
//  LEDWebViewController.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/31.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LEDWebViewController;
@protocol LEDWebViewControllerDelegate <NSObject>

- (BOOL)webViewController:(LEDWebViewController *)controller shouldLoadRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
@optional
- (void)webViewControllerDidFinishLoad:(LEDWebViewController *)webViewController;
- (void)webViewControllerDidStartLoad:(LEDWebViewController *)webViewController;
- (void)webViewController:(LEDWebViewController *)webViewController didFailLoadWithError:(NSError *)error;

@end

@interface LEDWebViewController : UIViewController

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *HTTPMethod;
@property (nonatomic, strong) NSURL *URL;

@property (nonatomic, weak) id<LEDWebViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL activityViewHidden; // 这个属性在 init 的过程中被设置为 YES，即默认方式为页面加载的时候不转菊花，如果使用方需要转菊花可以将这个属性手动设置为 NO，不过请评估以下效果是否符合要求：在加载过程中，展示转菊花，且转菊花期间无法响应交互操作（比如上下滑动）

@property (nonatomic, assign) BOOL progressHidden; // 是否隐藏进度条

@property (nonatomic, copy) void (^exitBlock)();


- (instancetype)initWithURL:(NSURL *)URL;

@end
