//
//  LEDPortal.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/30.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// LEDPortalHandler
typedef  UIViewController* _Nullable (^LEDPortalHandler)( NSURL * _Nonnull URL, BOOL shouldTransfer, UIViewController * _Nonnull sourceViewController);
// LEDPortal
@interface LEDPortal : NSObject
// register controller
+ (void)registerPortalWithHandler:(_Nonnull LEDPortalHandler)handler prefixURL:(NSURL * _Nonnull)prefixURL;
// show viewController
+ (void)transferFromViewController:(nullable UIViewController *)sourceViewController
                             toURL:(NSURL * _Nonnull)URL
                        completion:(void (^ __nullable)(UIViewController * _Nullable viewController,  NSError * _Nullable error))completion;
@end


@interface NSURL (SAKPortal)
// is the same URL
- (BOOL)hasSameTrunkWithURL:(NSURL * _Nonnull)URL;

@end