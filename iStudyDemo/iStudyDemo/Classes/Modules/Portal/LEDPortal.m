//
//  LEDPortal.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/30.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDPortal.h"

static NSString * const kLEDDefaultPortalKey = @"defaultPortalKey";
static NSString * const kLEDPortalErrorDomian = @"com.puny.portal";

// 内联扩展是用来消除函数调用时的时间开销。它通常用于频繁执行的函数。 一个小内存空间的函数非常受益。

NS_INLINE NSString* keyFromURL(NSURL *URL)
{
    return URL ? [NSString stringWithFormat:@"%@://%@%@", URL.scheme, URL.host, URL.path] : nil;
}

NS_INLINE NSArray<NSString *>* extractAllLeftPossibleKeysFromURL(NSURL *url)
{
    if (!url.path) {
        return nil;
    }
    
    NSArray *pathItems = [url.path componentsSeparatedByString:@"/"];
    if ([pathItems count] <= 1) {  //  对于/PATH 结构直接返回
        return nil;
    }
    
    NSMutableArray *pathArray = [NSMutableArray array];
    for (NSUInteger idx = 1; idx < [pathItems count] - 1; idx++) {  // 首末元素过滤掉
        NSString *prefix = [pathArray lastObject] ?: @"";
        [pathArray addObject:[NSString stringWithFormat:@"%@/%@", prefix, pathItems[idx]]];
    }
    
    NSMutableArray<NSString *>* result = [NSMutableArray array];
    //匹配策略是最长的先被匹配，所以倒序遍历
    [pathArray enumerateObjectsWithOptions:NSEnumerationReverse
                                usingBlock:^(NSString*  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
                                    [result addObject:[NSString stringWithFormat:@"%@://%@%@", url.scheme, url.host ,item]];
                                }];
    
    return [NSArray arrayWithArray:result];
}


@implementation LEDPortal
static NSMutableArray *portalArray = nil;
static NSMutableDictionary<NSString *, NSMutableArray *> *portalMap = nil;
static NSMutableDictionary<NSString *, NSMutableArray *> *RNPortalMap = nil;

+(void)initialize
{
    if (self == [LEDPortal self]) {
        portalArray          = [NSMutableArray array];
        portalMap            = [NSMutableDictionary dictionary];
        RNPortalMap          = [NSMutableDictionary dictionary];
    }
}

+ (void)registerPortalWithHandler:(LEDPortalHandler)handler prefixURL:(NSURL *)prefixURL
{
    NSAssert([prefixURL.scheme length] > 0, @"Your prefixURL must contains a valid scheme");
    NSAssert([prefixURL.host length]   > 0, @"Your prefixURL must contains a valid host");
    NSAssert([prefixURL.path length]   > 0, @"Your prefixURL must contains a valid path");
    
    [self _registerPortalWithHandler:handler forKey:keyFromURL(prefixURL) atMap:portalMap];
}

+ (void)transferFromViewController:(nullable UIViewController *)sourceViewController
                             toURL:(NSURL *)URL
                        completion:(void (^ __nullable)(UIViewController * _Nullable viewController,  NSError * _Nullable error))completion
{
    NSAssert(URL, @"Please provide the URL of your destionation");
    if (!URL) {
        return;
    }
    
    UIViewController *viewController = sourceViewController ?: [self topViewController];
    [self _transferFromViewController:viewController
                                toURL:URL
                         needTransfer:YES
                           completion:completion];
}


+ (nullable UIViewController *)_transferFromViewController:(UIViewController *)sourceViewController
                                                     toURL:(NSURL *)URL
                                              needTransfer:(BOOL)needTransfer
                                                completion:(void (^ __nullable)(UIViewController * _Nullable viewController,  NSError * _Nullable error))completion
{
    // 生成需要查找的key pool
    NSMutableArray<NSArray *> *keysPool = [NSMutableArray array];
    NSString *hotestKey = keyFromURL(URL);
    if (hotestKey) {
        [keysPool addObject:@[hotestKey]];
    }
    NSArray *leftPossibleKeys = extractAllLeftPossibleKeysFromURL(URL);
    if ([leftPossibleKeys count] > 0) {
        [keysPool addObject:leftPossibleKeys];
    }
    [keysPool addObject:@[kLEDDefaultPortalKey]];
    
    __block UIViewController *destinationViewController;
    [keysPool enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *handlers = [self _combineHandlerArraysWithKeys:obj]; //
        destinationViewController = [self batchPerformHandlers:handlers
                                                       withURL:URL
                                                  needTransfer:needTransfer
                                      withSourceViewController:sourceViewController];
        *stop = !!destinationViewController;
    }];
    NSError *portalError = nil;
    if (!destinationViewController)
    {
        NSString *message = [NSString stringWithFormat:@"<Can not fetch the target UIViewController according to your URL: %@>", URL.absoluteString];
        NSAssert(NO, message);
        NSDictionary *userInfo = @{ NSURLErrorKey : [NSString stringWithFormat:@"Page not Found according to URL:%@", [URL absoluteString]]};
        portalError = [NSError errorWithDomain:kLEDPortalErrorDomian code:404 userInfo:userInfo];
    }
    
    if (completion) {
        completion(destinationViewController, portalError);
    }
    
    return destinationViewController;
}

#pragma mark - Private method

+ (void)_registerPortalWithHandler:(LEDPortalHandler)handler forKey:(NSString *)key atMap:(NSMutableDictionary *)map
{
    NSParameterAssert(handler);
    NSString *realKey = [key length] ? key : kLEDDefaultPortalKey;
    
    if (map[realKey]) {
        [map[realKey] addObject:handler];
    } else {
        map[realKey] = [NSMutableArray arrayWithObject:handler];
    }
}

+ (UIViewController *)topViewController
{
   return [self traverseTopViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController *)traverseTopViewController:(UIViewController *)rootViewController
{
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self traverseTopViewController:[navigationController.viewControllers lastObject]];
    }
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabController = (UITabBarController *)rootViewController;
        return [self traverseTopViewController:tabController.selectedViewController];
    }
    if (rootViewController.presentedViewController) {
        return [self traverseTopViewController:rootViewController.presentedViewController];
    }
    return rootViewController;
}

+ (nullable UIViewController *)batchPerformHandlers:(NSArray *)array
                                                           withURL:(NSURL *)URL
                                                      needTransfer:(BOOL)needTransfer
                                          withSourceViewController:(UIViewController *)sourceViewController
{
    if (0 == [array count]) {
        return nil;
    }
    
    __block UIViewController *viewController = nil;
    [array enumerateObjectsUsingBlock:^(UIViewController *(^block)(NSURL *, BOOL ,UIViewController *), NSUInteger idx, BOOL *stop) {
        viewController = block(URL, needTransfer, sourceViewController);
        *stop = !!viewController;
    }];
    return viewController;
}

+ (nullable NSArray *)_combineHandlerArraysWithKeys:(NSArray<NSString *> *)keys
{
    if (!keys) {
        return nil;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *key in keys) {
        if(portalMap[key] && [portalMap[key] count] > 0) {
            [array addObjectsFromArray: portalMap[key]];
        }
        if (RNPortalMap[key] && [RNPortalMap[key] count] > 0) {
            [array addObjectsFromArray: RNPortalMap[key]];
        }
    }
    return array;
}

@end

@implementation NSURL (SAKPortal)

- (BOOL)hasSameTrunkWithURL:(NSURL *)URL
{
    NSParameterAssert(URL);
    return [self.path isEqualToString:URL.path] &&
    [self.host isEqualToString:URL.host] &&
    [self.scheme isEqualToString:URL.scheme];
}

@end