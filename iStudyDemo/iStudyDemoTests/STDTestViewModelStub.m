//
//  STDTestViewModelStub.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/6.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "STDTestViewModelStub.h"
#import <OHHTTPStubs/OHHTTPStubs.h>

@implementation STDTestViewModelStub

+ (void)getSuccessStub
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"/offline/resource" options:0 error:nil];
        return [re numberOfMatchesInString:[request.URL absoluteString] options:0 range:NSMakeRange(0, [[request.URL absoluteString] length])];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *path = [bundle pathForResource:@"TestSucessStub" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        return [OHHTTPStubsResponse responseWithData:data statusCode:200 headers:nil];
    }];
    
}

+ (void)getFailStub
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"/offline/resource" options:0 error:nil];
        return [re numberOfMatchesInString:[request.URL absoluteString] options:0 range:NSMakeRange(0, [[request.URL absoluteString] length])];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *path = [bundle pathForResource:@"TestFailStub" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        return [OHHTTPStubsResponse responseWithData:data statusCode:200 headers:nil];
    }];
}

+ (void)getFailNetworkStub
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"/offline/resource" options:0 error:nil];
        return [re numberOfMatchesInString:[request.URL absoluteString] options:0 range:NSMakeRange(0, [[request.URL absoluteString] length])];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *path = [bundle pathForResource:@"TestFailStub" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        return [OHHTTPStubsResponse responseWithData:data statusCode:300 headers:nil];
    }];
}

@end
