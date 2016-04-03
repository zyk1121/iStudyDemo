//
//  LEDWebViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/31.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDWebViewController.h"
#import "UIKitMacros.h"
#import "UIView+Extension.h"
#import "UIViewAdditions.h"
#import "LEDWebViewController+Progress.h"
#import "LEDPortal.h"
#import "NSStringAdditions.h"
#import "LEDURLChecker.h"
#import <extobjc.h>

/*
 如果本类的delegate不执行回调的话，考虑修改这个地方
 WebViewJavascriptBridge.m
 
 - (void) _platformSpecificSetup:(WVJB_WEBVIEW_TYPE*)webView {
 _webView = webView;
 _webViewDelegate = _webView.delegate;
 _webView.delegate = self;
 
 _base = [[WebViewJavascriptBridgeBase alloc] init];
 _base.delegate = self;
 }
 */

static NSString *const kLEDMainURLString = @"leador://www.ishowchina.com/web";

@interface LEDWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) NSString *javascriptBridgeGoBackHandlerName;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) LEDWebViewControllerProgressProxy *progressProxy;

@end

@implementation LEDWebViewController
{
    BOOL _webPageBacking;
    UIBarButtonItem *_backButtonItem;
}

+ (void)load
{
    [LEDPortal registerPortalWithHandler:^UIViewController *(NSURL *URL, BOOL shouldTransfer, UIViewController *sourceViewController) {
        if ([URL hasSameTrunkWithURL:[NSURL URLWithString:kLEDMainURLString]]) {
            return [LEDWebViewController instanceWithURL:URL
                                          shouldTransfer:shouldTransfer
                                      fromViewController:sourceViewController];
        } else {
            return nil;
        }
    } prefixURL:[NSURL URLWithString:kLEDMainURLString]];
}

+ (UIViewController *)instanceWithURL:(NSURL *)URL
                       shouldTransfer:(BOOL)shouldTransfer
                   fromViewController:(UIViewController *)sourceViewController
{
    LEDWebViewController *viewController = [[LEDWebViewController alloc] initWithURL:URL];
    [viewController setWithURL:URL];
    if (sourceViewController.navigationController) {
        [sourceViewController.navigationController pushViewController:viewController animated:YES];
    }
    return viewController;
}

//

- (void)setWithURL:(NSURL *)URL
{
    NSDictionary *params = [[URL query] dictionaryByParseInURLParameterFormat];
    if (params[@"url"]) {
        NSString *URLString = [params[@"url"] URLDecodedString];
        
        NSURL *URLFromParameter = [NSURL URLWithString:URLString];
        self.URL = URLFromParameter;
    } else {
        self.URL = [NSURL URLWithString:@"http://ishowchina.com"];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupLeftCustomView];
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _webView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    
    _enableWebViewJavascriptBridge = YES;
    
    if (self.enableWebViewJavascriptBridge) {
        _webViewControllerJavascriptBridgeHelper = [[LEDWebViewControllerJavascriptBridgeHelper alloc] initWithWebViewController:self andWebView:_webView];
        [_webViewControllerJavascriptBridgeHelper loadTraditionalHandlers];
    }

    
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.hidesWhenStopped = YES;
    
    if ([LEDWebViewController progressEnabled]) {
        // 不隐藏进度条 且 在nav stack里
        if (!self.progressHidden && [[[self.navigationController viewControllers] lastObject] isEqual:self]) {
            self.progressProxy = [[LEDWebViewControllerProgressProxy alloc] initWithLEDWebViewController:self];
        }
    }

    [self loadWebView];
}

- (instancetype)initWithURL:(NSURL *)URL
{
    self = [super init];
    if (self) {
        _URL = URL;
        _HTTPMethod = @"GET";
        _webPageBacking = NO;
        _activityViewHidden = NO;
        self.progressHidden = NO;
    }
    return self;
}

- (void)setProgressHidden:(BOOL)progressHidden
{
    _progressHidden = progressHidden;
    [LEDWebViewController enableProgress:!progressHidden];
}

- (instancetype)init
{
    return [self initWithURL:nil];
}

- (void)dealloc
{
    _webView.delegate = nil;
    
    [_activityView stopAnimating];
    [_activityView removeFromSuperview];
    _activityView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.exitBlock) {
        self.exitBlock();
        self.exitBlock = nil;
    }
}

- (void)setURL:(NSURL *)URL
{
    _URL = URL;
    if ([self isViewLoaded]) {
        [self loadWebView];
    }
}

- (void)setupLeftCustomView
{
    CGFloat offset = 0.0f;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending) {
        offset = 11.0f;
    }
    
    UIView *customViewWithoutCloseButton = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 65 + offset, 44)];
    customViewWithoutCloseButton.hitTestEdgeInsets = UIEdgeInsetsMake(0, -21.5, 0, 0);

    UIButton *singleBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    singleBackButton.frame = CGRectMake(-3 + offset, 8.5, 23, 23);
    singleBackButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10.0f, -21.5f, -11.5f, -21.5f);
    [singleBackButton setBackgroundImage:[UIImage imageNamed:@"btn_backItem.png"] forState:UIControlStateNormal];
    [singleBackButton setBackgroundImage:[UIImage imageNamed:@"btn_backItem_highlighted.png"] forState:UIControlStateHighlighted];
    [singleBackButton addTarget:self action:@selector(didClickLeftBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    [customViewWithoutCloseButton addSubview:singleBackButton];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(singleBackButton.right, 6.5, 30, 30)];
    backButton.titleLabel.font = Font(14);
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal]; // 可以把设置文案的颜色放到外面
    [backButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(didClickLeftBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    [customViewWithoutCloseButton addSubview:backButton];
    
    _backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customViewWithoutCloseButton];
    self.navigationItem.leftBarButtonItem = _backButtonItem;

}



- (void)didClickLeftBarButtonItem
{
    if (_enableWebViewJavascriptBridge && _javascriptBridgeGoBackHandlerName.length > 0) {
        @weakify(self);
        [_webViewControllerJavascriptBridgeHelper callJavascriptHandlerName:_javascriptBridgeGoBackHandlerName withData:@"jsGoBack" andResponseCallback:^(id responseData) {
            @strongify(self);
            if (!responseData) {
                [self webViewGoBackAction];
            }
        }];
    } else {
        [self webViewGoBackAction];
    }
}

- (void)webViewGoBackAction
{
    if ([self.webView canGoBack]) {
        _webPageBacking = YES;
        [self.webView goBack];
    } else {
        [self backAction];
    }
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL shouldLoad = YES;
    if (_webPageBacking) {
        _webPageBacking = NO;
        return shouldLoad;
    }

    if ([_delegate respondsToSelector:@selector(webViewController:shouldLoadRequest:navigationType:)]) {
        shouldLoad = [_delegate webViewController:self shouldLoadRequest:request navigationType:navigationType];
    }

    if (shouldLoad) {
        shouldLoad = [self handleURLRequest:request];
    }
    return shouldLoad;
}

- (BOOL)handleURLRequest:(NSURLRequest *)request
{
    NSString *URLString = [request.URL absoluteString];
    NSString *scheme = [request.URL.scheme lowercaseString];
    BOOL shouldLoad = YES;
    
    // 判断是否是内部协议
    if([scheme isEqualToString:@"ipuny"])
    {
        [LEDPortal transferFromViewController:nil
                                        toURL:request.URL
                                   completion:nil];
        return NO;
    }
    
    // 排除由于设置iframe导致重新load的情况
    if (![request.URL isEqual:request.mainDocumentURL]) {
        return shouldLoad;
    }

    return shouldLoad;
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (webView.isLoading) {
        return;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if (!self.activityViewHidden) {
        self.activityView.frame = CGRectMake(0, 0, _webView.frame.size.width, _webView.frame.size.height);
        [_webView addSubview:self.activityView];
        [self.activityView startAnimating];
    }
    
    _javascriptBridgeGoBackHandlerName = @"";

    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewControllerDidStartLoad:)]) {
        [self.delegate webViewControllerDidStartLoad:self];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (!self.activityViewHidden) {
        [self stopActivity];
    }

    if (_webViewControllerJavascriptBridgeHelper) {
        @weakify(self);
        [_webViewControllerJavascriptBridgeHelper callJavascriptHandlerName:@"getRegisteredJsHandler" withData:@"jsGoBack" andResponseCallback:^(id responseData) {
            @strongify(self);
            if ([responseData isKindOfClass:[NSDictionary class]]) {
                self.javascriptBridgeGoBackHandlerName = responseData[@"goback"];
            }
        }];
    }


    if (_delegate && [_delegate respondsToSelector:@selector(webViewControllerDidFinishLoad:)]) {
        [_delegate webViewControllerDidFinishLoad:self];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (!self.activityViewHidden) {
        [self stopActivity];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewController:didFailLoadWithError:)]) {
        [self.delegate webViewController:self didFailLoadWithError:error];
    }
}

#pragma mark -
#pragma mark Private Methods
- (void)loadWebView
{
    if (_URL) {
        // 使用cache数据。
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_URL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
        request.HTTPMethod = _HTTPMethod;
        
        [self.webView loadRequest:request];
    }
}

#pragma mark - private method

- (void)stopActivity
{
    [self.activityView stopAnimating];
    [self.activityView removeFromSuperview];
}

@end
