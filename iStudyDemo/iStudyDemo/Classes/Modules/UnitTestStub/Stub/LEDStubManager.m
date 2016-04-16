//
//  LEDStubManager.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/10.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDStubManager.h"
//#import "OHHTTPStubs.h"
#import <OHHTTPStubs/OHHTTPStubs.h>

@implementation LEDStubManager

+ (instancetype)defaultStubManager
{
    static LEDStubManager *_sharedKit = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedKit = [[self alloc] init];
    });
    
    return _sharedKit;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setupHTTPStubs
{
    // 
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"/offline/resource" options:0 error:nil];
        return [re numberOfMatchesInString:[request.URL absoluteString] options:0 range:NSMakeRange(0, [[request.URL absoluteString] length])];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *path = [bundle pathForResource:@"testStub" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        return [OHHTTPStubsResponse responseWithData:data statusCode:200 headers:nil];
    }];

}

@end
