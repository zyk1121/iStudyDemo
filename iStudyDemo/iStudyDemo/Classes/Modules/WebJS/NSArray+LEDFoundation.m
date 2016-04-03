//
//  NSArray+LEDFoundation.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "NSArray+LEDFoundation.h"

@implementation NSArray (LEDFoundation)

- (void)sak_each:(void (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj, idx);
    }];
}

- (void)sak_apply:(void (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    [self enumerateObjectsWithOptions:NSEnumerationConcurrent
                           usingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop){
                               block(obj, idx);
                           }];
}

- (NSArray *)sak_map:(id (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:self.count];
    NSUInteger index = 0;
    for (id object in self) {
        id result = block(object, index++);
        if (!result) {
            result = [NSNull null];
        }
        [resultArray addObject:result];
    }
    return [resultArray copy];
}

- (id)reduce:(id (^)(id, id))block
{
    NSParameterAssert(block);
    id accumulated = nil;
    for (id object in self) {
        if (!accumulated) {
            accumulated = object;
        } else {
            accumulated = block(accumulated, object);
        }
    }
    return accumulated;
}

- (id)match:(BOOL (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    id result = nil;
    NSUInteger index = 0;
    for (id object in self) {
        if (block(object, index++)) {
            result = object;
            break;
        }
    }
    return result;
}

- (NSArray *)filter:(BOOL (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    NSMutableArray *resultArray = [NSMutableArray array];
    NSUInteger index = 0;
    for (id object in self) {
        if (block(object, index)) {
            [resultArray addObject:object];
        }
    }
    return [resultArray copy];
}

- (NSArray *)sak_select:(BOOL (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    return [self filter:block];
}

- (NSArray *)sak_reject:(BOOL (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    return [self sak_select:^BOOL(id object, NSUInteger index) {
        return !block(object, index);
    }];
}

- (BOOL)every:(BOOL (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    BOOL result = YES;
    NSUInteger index = 0;
    for (id object in self) {
        result = block(object, index++);
        if (!result) {
            break;
        }
    }
    return result;
}

- (BOOL)some:(BOOL (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    BOOL result = NO;
    NSUInteger index = 0;
    for (id object in self) {
        result = block(object, index++);
        if (result) {
            break;
        }
    }
    return result;
}

- (BOOL)notAny:(BOOL (^)(id, NSUInteger))block
{
    return ![self some:block];
}

- (BOOL)notEvery:(BOOL (^)(id, NSUInteger))block
{
    return ![self every:block];
}

@end
