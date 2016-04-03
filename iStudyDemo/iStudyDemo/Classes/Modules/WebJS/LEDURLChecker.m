//
//  LEDURLChecker.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDURLChecker.h"

@implementation LEDURLChecker

+ (BOOL)isPermissiveHostURL:(NSURL *)URL
{
    NSRegularExpression *permissiveHost = [NSRegularExpression regularExpressionWithPattern:@"^(.*\\.)?(leador\\.com|ishowchaina\\.com)(\\.)?$"
                                                                                    options:NSRegularExpressionCaseInsensitive
                                                                                      error:nil];
    NSString *host = URL.host;
    return (host && [permissiveHost numberOfMatchesInString:host options:0 range:NSMakeRange(0, [host length])]);
}

+ (BOOL)isHTTPURL:(NSURL *)URL
{
    return [URL.scheme caseInsensitiveCompare:@"http"] == NSOrderedSame;
}

+ (BOOL)isHTTPSURL:(NSURL *)URL
{
    return [URL.scheme caseInsensitiveCompare:@"https"] == NSOrderedSame;
}

+ (BOOL)isHTTPOrHTTPSURL:(NSURL *)URL
{
    return [self isHTTPURL:URL] || [self isHTTPSURL:URL];
}

+ (BOOL)isPermissiveResourceURL:(NSURL *)URL
{
    NSRegularExpression *permissiveResource = [NSRegularExpression regularExpressionWithPattern:@"^(.*\\.)?(leador\\.net|ishowchina\\.com)(\\.)?$"
                                                                                    options:NSRegularExpressionCaseInsensitive
                                                                                      error:nil];
    NSString *host = URL.host;
    return (host && [permissiveResource numberOfMatchesInString:host options:0 range:NSMakeRange(0, [host length])]);
}

@end
