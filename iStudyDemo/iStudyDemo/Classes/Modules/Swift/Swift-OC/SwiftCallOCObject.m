//
//  SwiftCallOCObject.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/17.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "SwiftCallOCObject.h"


void testOCGlobal()
{
    NSLog(@"test OC global");
}

@implementation SwiftCallOCObject

- (void)swiftCallOC
{
    NSLog(@"Swift call oc hello world");
}

- (void)test2
{
    NSLog(@"新加入的函数不需要重新clean");
}

@end
