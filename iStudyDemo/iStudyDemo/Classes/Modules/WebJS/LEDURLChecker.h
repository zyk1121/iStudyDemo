//
//  LEDURLChecker.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEDURLChecker : NSObject

+ (BOOL)isPermissiveHostURL:(NSURL *)URL;
+ (BOOL)isHTTPURL:(NSURL *)URL;
+ (BOOL)isHTTPSURL:(NSURL *)URL;
+ (BOOL)isHTTPOrHTTPSURL:(NSURL *)URL;
+ (BOOL)isPermissiveResourceURL:(NSURL *)URL;

@end
