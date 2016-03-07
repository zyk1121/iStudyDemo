//
//  LEDDomainPredicate.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/7.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "RPValidatorPredicate.h"

@interface LEDDomainPredicate : RPValidatorPredicate

@property (nonatomic, readonly) RPValidatorPredicate *beforeMappingPredicate;
@property (nonatomic, readonly) RPValidatorPredicate *afterMappingPredicate;

@property (nonatomic, readonly) NSString *key;
@property (nonatomic, readonly) LEDDomainPredicate *(^JSONKey)(NSString *key);

+ (instancetype)wasOptional;
+ (instancetype)hadSubstring:(NSString *)substring;
+ (instancetype)wasString;
+ (instancetype)wasNumber;
+ (instancetype)wasDictionary;
+ (instancetype)wasArray;
+ (instancetype)wasBoolean;
+ (instancetype)wasNull;
+ (instancetype)wasNotNull;
+ (instancetype)didValidateValueWithBlock:(ValidatorBlock)block;

+ (instancetype)isOptional;
+ (instancetype)hasSubstring:(NSString *)substring;
+ (instancetype)isString;
+ (instancetype)isNumber;
+ (instancetype)isDictionary;
+ (instancetype)isArray;
+ (instancetype)isBoolean;
+ (instancetype)isNull;
+ (instancetype)isNotNull;
+ (instancetype)validateValueWithBlock:(ValidatorBlock)block;

- (instancetype)wasOptional;
- (instancetype)hadSubstring:(NSString *)substring;
- (instancetype)wasString;
- (instancetype)wasNumber;
- (instancetype)wasDictionary;
- (instancetype)wasArray;
- (instancetype)wasBoolean;
- (instancetype)wasNull;
- (instancetype)wasNotNull;
- (instancetype)didValidateValueWithBlock:(ValidatorBlock)block;

- (instancetype)isOptional;
- (instancetype)hasSubstring:(NSString *)substring;
- (instancetype)isString;
- (instancetype)isNumber;
- (instancetype)isDictionary;
- (instancetype)isArray;
- (instancetype)isBoolean;
- (instancetype)isNull;
- (instancetype)isNotNull;
- (instancetype)validateValueWithBlock:(ValidatorBlock)block;

@end
