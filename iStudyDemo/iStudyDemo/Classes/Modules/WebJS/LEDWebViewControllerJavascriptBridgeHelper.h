//
//  LEDWebViewControllerJavascriptBridgeHelper.h
//  Created by zhangyuanke on 16/3/31.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"

/*
 1) Import the header file and declare an ivar property:
 
 #import "WebViewJavascriptBridge.h"
 ...
 
 @property WebViewJavascriptBridge* bridge;
 2) Instantiate WebViewJavascriptBridge with a UIWebView (iOS) or WebView (OSX):
 
 self.bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
 3) Register a handler in ObjC, and call a JS handler:
 
 [self.bridge registerHandler:@"ObjC Echo" handler:^(id data, WVJBResponseCallback responseCallback) {
 NSLog(@"ObjC Echo called with: %@", data);
 responseCallback(data);
 }];
 [self.bridge callHandler:@"JS Echo" responseCallback:^(id responseData) {
 NSLog(@"ObjC received response: %@", responseData);
 }];
 4) Copy and paste setupWebViewJavascriptBridge into your JS:
 
 function setupWebViewJavascriptBridge(callback) {
 if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
 if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
 window.WVJBCallbacks = [callback];
 var WVJBIframe = document.createElement('iframe');
 WVJBIframe.style.display = 'none';
 WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
 document.documentElement.appendChild(WVJBIframe);
 setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
 }
 5) Finally, call setupWebViewJavascriptBridge and then use the bridge to register handlers and call ObjC handlers:
 
 setupWebViewJavascriptBridge(function(bridge) {
 


bridge.registerHandler('JS Echo', function(data, responseCallback) {
    console.log("JS Echo called with:", data)
    responseCallback(data)
})
bridge.callHandler('ObjC Echo', function responseCallback(responseData) {
    console.log("JS received response:", responseData)
})
})
 */

@interface LEDWebViewControllerJavascriptBridgeHelper : NSObject

@property (nonatomic, weak) UIViewController<UIWebViewDelegate> *webViewController;
@property (nonatomic, weak) UIWebView *webView;

typedef NSDictionary *(^LEDWebViewControllerJavascriptBridgeHelperFactoryBlock)(NSDictionary *, LEDWebViewControllerJavascriptBridgeHelper *);
+ (void)registerHandlerForModule:(NSString *)module method:(NSString *)method block:(LEDWebViewControllerJavascriptBridgeHelperFactoryBlock)handlerBlock;

- (id)initWithWebViewController:(UIViewController<UIWebViewDelegate> *)webViewController andWebView:(UIWebView *)webView;

- (void)loadTraditionalHandlers;

- (void)addNewHandlerWithName:(NSString *)handlerName andHandlerCallbackBlock:(void (^)(id data, WVJBResponseCallback responseCallback))callbackBlock;

//- (void)sendMessage:(id)data withResponseCallback:(void (^)(id responseData))responseCallback;

- (void)callJavascriptHandlerName:(NSString *)handlerName withData:(id)data andResponseCallback:(WVJBResponseCallback)responseCallback;

@end
