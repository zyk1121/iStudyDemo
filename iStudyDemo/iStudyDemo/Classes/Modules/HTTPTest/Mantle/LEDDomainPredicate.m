//
//  LEDDomainPredicate.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/7.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDDomainPredicate.h"
#import <objc/runtime.h>

@interface LEDDomainPredicate ()

@end

@implementation LEDDomainPredicate

- (id)init
{
    self = [super init];
    if (self) {
        __weak typeof(self) weakSelf = self;
        _JSONKey = [^typeof(self)(NSString *key) {
            [weakSelf setKey:key];
            return weakSelf;
        } copy];
    }
    return self;
}

- (void)setKey:(NSString *)key
{
    _key = [key copy];
}

+ (instancetype)wasOptional
{
    LEDDomainPredicate *domainPredicate = [[self alloc] init];
    return [domainPredicate wasOptional];
}

+ (instancetype)hadSubstring:(NSString *)substring
{
    LEDDomainPredicate *domainPredicate = [[self alloc] init];
    return [domainPredicate hadSubstring:substring];
}

+ (instancetype)wasString
{
    LEDDomainPredicate *domainPredicate = [[self alloc] init];
    return [domainPredicate wasString];
}

+ (instancetype)wasNumber
{
    LEDDomainPredicate *domainPredicate = [[self alloc] init];
    return [domainPredicate wasNumber];
}

+ (instancetype)wasDictionary
{
    LEDDomainPredicate *domainPredicate = [[self alloc] init];
    return [domainPredicate wasDictionary];
}

+ (instancetype)wasArray
{
    LEDDomainPredicate *domainPredicate = [[self alloc] init];
    return [domainPredicate wasArray];
}

+ (instancetype)wasBoolean
{
    LEDDomainPredicate *domainPredicate = [[self alloc] init];
    return [domainPredicate wasBoolean];
}

+ (instancetype)wasNull
{
    LEDDomainPredicate *domainPredicate = [[self alloc] init];
    return [domainPredicate wasNull];
}

+ (instancetype)wasNotNull
{
    LEDDomainPredicate *domainPredicate = [[self alloc] init];
    return [domainPredicate wasNotNull];
}

+ (instancetype)didValidateValueWithBlock:(ValidatorBlock)block
{
    LEDDomainPredicate *domainPredicate = [[self alloc] init];
    return [domainPredicate didValidateValueWithBlock:block];
}

- (instancetype)wasOptional
{
    _beforeMappingPredicate = _beforeMappingPredicate ? [_beforeMappingPredicate isOptional] : [RPValidatorPredicate isOptional];
    return self;
}

- (instancetype)hadSubstring:(NSString *)substring
{
    _beforeMappingPredicate = _beforeMappingPredicate ? [_beforeMappingPredicate hasSubstring:substring] : [RPValidatorPredicate hasSubstring:substring];
    return self;
}

- (instancetype)wasString
{
    _beforeMappingPredicate = _beforeMappingPredicate ? [_beforeMappingPredicate isString] : [RPValidatorPredicate isString];
    return self;
}

- (instancetype)wasNumber
{
    _beforeMappingPredicate = _beforeMappingPredicate ? [_beforeMappingPredicate isNumber] : [RPValidatorPredicate isNumber];
    return self;
}

- (instancetype)wasDictionary
{
    _beforeMappingPredicate = _beforeMappingPredicate ? [_beforeMappingPredicate isDictionary] : [RPValidatorPredicate isDictionary];
    return self;
}

- (instancetype)wasArray
{
    _beforeMappingPredicate = _beforeMappingPredicate ? [_beforeMappingPredicate isArray] : [RPValidatorPredicate isArray];
    return self;
}

- (instancetype)wasBoolean
{
    _beforeMappingPredicate = _beforeMappingPredicate ? [_beforeMappingPredicate isBoolean] : [RPValidatorPredicate isBoolean];
    return self;
}

- (instancetype)wasNull
{
    _beforeMappingPredicate = _beforeMappingPredicate ? [_beforeMappingPredicate isNull] : [RPValidatorPredicate isNull];
    return self;
}

- (instancetype)wasNotNull
{
    _beforeMappingPredicate = _beforeMappingPredicate ? [_beforeMappingPredicate isNotNull] : [RPValidatorPredicate isNotNull];
    return self;
}

- (instancetype)didValidateValueWithBlock:(ValidatorBlock)block
{
    _beforeMappingPredicate = _beforeMappingPredicate ? [_beforeMappingPredicate validateValueWithBlock:block] : [RPValidatorPredicate validateValueWithBlock:block];
    return self;
}

+ (instancetype)isOptional
{
    /* 之前是 return [[[self alloc] init] isOptional];
     修改成这样的原因refer http://stackoverflow.com/questions/1038171/defeating-the-multiple-methods-named-xxx-found-error
     */
    LEDDomainPredicate *domainPredicate = [[self alloc] init];
    return [domainPredicate isOptional];
}

+ (instancetype)hasSubstring:(NSString *)substring
{
    LEDDomainPredicate *domainPredicate = [[self alloc] init];
    return [domainPredicate hasSubstring:substring];
}

+ (instancetype)isString
{
    LEDDomainPredicate *domainPredicate = [[self alloc] init];
    return [domainPredicate isString];
}

+ (instancetype)isNumber
{
    LEDDomainPredicate *domainPredicate = [[self alloc] init];
    return [domainPredicate isNumber];
}

+ (instancetype)isDictionary
{
    LEDDomainPredicate *domainPredicate = [[self alloc] init];
    return [domainPredicate isDictionary];
}

+ (instancetype)isArray
{
    LEDDomainPredicate *domainPredicate = [[self alloc] init];
    return [domainPredicate isArray];
}

+ (instancetype)isBoolean
{
    LEDDomainPredicate *domainPredicate = [[self alloc] init];
    return [domainPredicate isBoolean];
}

+ (instancetype)isNull
{
    LEDDomainPredicate *domainPredicate = [[self alloc] init];
    return [domainPredicate isNull];
}

+ (instancetype)isNotNull
{
    LEDDomainPredicate *domainPredicate = [[self alloc] init];
    return [domainPredicate isNotNull];
}

+ (instancetype)validateValueWithBlock:(ValidatorBlock)block
{
    LEDDomainPredicate *domainPredicate = [[self alloc] init];
    return [domainPredicate validateValueWithBlock:block];
}

- (instancetype)isOptional
{
    _afterMappingPredicate = _afterMappingPredicate ? [_afterMappingPredicate isOptional] : [RPValidatorPredicate isOptional];
    return self;
}

- (instancetype)hasSubstring:(NSString *)substring
{
    _afterMappingPredicate = _afterMappingPredicate ? [_afterMappingPredicate hasSubstring:substring] : [RPValidatorPredicate hasSubstring:substring];
    return self;
}

- (instancetype)isString
{
    _afterMappingPredicate = _afterMappingPredicate ? [_afterMappingPredicate isString] : [RPValidatorPredicate isString];
    return self;
}

- (instancetype)isNumber
{
    _afterMappingPredicate = _afterMappingPredicate ? [_afterMappingPredicate isNumber] : [RPValidatorPredicate isNumber];
    return self;
}

- (instancetype)isDictionary
{
    _afterMappingPredicate = _afterMappingPredicate ? [_afterMappingPredicate isDictionary] : [RPValidatorPredicate isDictionary];
    return self;
}

- (instancetype)isArray
{
    _afterMappingPredicate = _afterMappingPredicate ? [_afterMappingPredicate isArray] : [RPValidatorPredicate isArray];
    return self;
}

- (instancetype)isBoolean
{
    _afterMappingPredicate = _afterMappingPredicate ? [_afterMappingPredicate isBoolean] : [RPValidatorPredicate isBoolean];
    return self;
}

- (instancetype)isNull
{
    _afterMappingPredicate = _afterMappingPredicate ? [_afterMappingPredicate isNull] : [RPValidatorPredicate isNull];
    return self;
}

- (instancetype)isNotNull
{
    _afterMappingPredicate = _afterMappingPredicate ? [_afterMappingPredicate isNotNull] : [RPValidatorPredicate isNotNull];
    return self;
}

- (instancetype)validateValueWithBlock:(ValidatorBlock)block
{
    _afterMappingPredicate = _afterMappingPredicate ? [_afterMappingPredicate validateValueWithBlock:block] : [RPValidatorPredicate validateValueWithBlock:block];
    return self;
}

@end

