//
//  LEDWebViewControllerJavascriptBridgeHelper.m
//  Created by zhangyuanke on 16/3/31.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//
//

#import "LEDWebViewControllerJavascriptBridgeHelper.h"
#import "extobjc.h"
#import "WebJSViewController.h"

static NSMutableDictionary *handlerDictionary = nil;

static NSString *const kModuleNameKey = @"moduleName";
static NSString *const kMethodNameKey = @"methodName";
static NSString *const kdataNameKey = @"data";

@implementation LEDWebViewControllerJavascriptBridgeHelper {
    WebViewJavascriptBridge *_bridge;
}

+ (void)initialize
{
    [super initialize];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handlerDictionary = [NSMutableDictionary dictionary];
    });
}

+ (void)registerHandlerForModule:(NSString *)module method:(NSString *)method block:(LEDWebViewControllerJavascriptBridgeHelperFactoryBlock)handlerBlock
{
    NSParameterAssert(module && method && handlerBlock);
    if (!handlerDictionary[module]) {
        handlerDictionary[module] = [NSMutableDictionary dictionary];
    }
    
    handlerDictionary[module][method] = handlerBlock;
}

+ (NSDictionary *)dispatchHandler:(NSDictionary *)handlerData withJavascriptBridgeHelper:(LEDWebViewControllerJavascriptBridgeHelper *)helper
{
    NSString *moduleName = handlerData[kModuleNameKey];
    NSString *methodName = handlerData[kMethodNameKey];
    if (moduleName && methodName) {
        LEDWebViewControllerJavascriptBridgeHelperFactoryBlock handlerBlock = handlerDictionary[moduleName][methodName];
        if (handlerBlock) {
            return handlerBlock(handlerData[kdataNameKey], helper);
        }
    }
    return nil;
}

- (id)initWithWebViewController:(UIViewController<UIWebViewDelegate> *)webViewController andWebView:(UIWebView *)webView
{
    self = [super init];
    if (self) {
        _webViewController = webViewController;
        _webView = webView;
        _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    }
    return self;
}

- (void)loadTraditionalHandlers
{
    @weakify(self)
    [_bridge registerHandler:@"closeWebViewHandler" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self)
        [self.webViewController.navigationController popViewControllerAnimated:YES];
    }];
    
    [_bridge registerHandler:@"callNativeMethod" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self)
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseData = [LEDWebViewControllerJavascriptBridgeHelper dispatchHandler:data withJavascriptBridgeHelper:self];
            if (responseCallback && responseData) {
                responseCallback(responseData);
            }
        }
    }];
    
    [_bridge registerHandler:@"ObjC Echo" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC Echo called with: %@", data);
        responseCallback(data);
    }];
    [_bridge callHandler:@"JS Echo" data:@"hello" responseCallback:^(id responseData) {
        NSLog(@"ObjC received response: %@", responseData);
    }];
}

- (void)addNewHandlerWithName:(NSString *)handlerName andHandlerCallbackBlock:(void (^)(id data, WVJBResponseCallback responseCallback))callbackBlock
{
    [_bridge registerHandler:handlerName handler:callbackBlock];
}

//- (void)sendMessage:(id)data withResponseCallback:(void (^)(id responseData))responseCallback
//{
//    [_bridge send:data];
//}

- (void)callJavascriptHandlerName:(NSString *)handlerName withData:(id)data andResponseCallback:(WVJBResponseCallback)responseCallback
{
    [_bridge callHandler:handlerName data:data responseCallback:responseCallback];
}

@end
