//
//  LEDDomainObject.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/7.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDDomainObject.h"
#import "RPJSONValidator.h"

#pragma mark - NSDictionary Category

@interface NSDictionary (LEDJSONValidator)

- (NSDictionary *)mapJSONValidator:(id (^)(id object, id key))block;

@end

@implementation NSDictionary (LEDJSONValidator)

- (NSDictionary *)mapJSONValidator:(id (^)(id, id))block
{
    NSParameterAssert(block);
    NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionaryWithCapacity:self.count];
    for (id key in self) {
        id value = self[key];
        id result = block(value, key);
        if (!result) {
            result = [NSNull null];
        }
        resultDictionary[key] = result;
    }
    return [resultDictionary copy];
}

@end

#pragma mark - SAKDomainObject

@interface LEDDomainObject ()

@end

@implementation LEDDomainObject

+ (instancetype)domainWithJSONDictionary:(NSDictionary *)dictionary
{
    NSError *error;
    LEDDomainObject *domainObject = [self domainWithJSONDictionary:dictionary error:&error];
    if (error) {
        NSString *errorDescription = [NSString stringWithFormat:@"%@校验失败，请检查后重试!", NSStringFromClass(self)];
        NSAssert(NO, errorDescription);
    }
    return domainObject;
}

+ (instancetype)domainWithJSONDictionary:(NSDictionary *)dictionary error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(!dictionary || [dictionary isKindOfClass:[NSDictionary class]]);
    if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]] || ![dictionary count]) {
        return nil;
    }
    
    NSError *localError = nil;
    NSDictionary *predicateDictionary = [self predicateDictionary];
    NSMutableDictionary *beforeMappingPredicateDictionary = [NSMutableDictionary dictionary];
    [predicateDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, LEDDomainPredicate *predicate, BOOL *stop) {
        NSString *JSONKey = predicate.key ? : key;
        [beforeMappingPredicateDictionary setValue:predicate.beforeMappingPredicate forKeyPath:JSONKey];
    }];
    BOOL valid = [RPJSONValidator validateValuesFrom:dictionary
                                    withRequirements:beforeMappingPredicateDictionary
                                               error:&localError];
    if (localError) {
        NSLog(@"%@", localError);
    }
    
    if (!valid) {
        if (error) {
            *error = [NSError errorWithDomain:@"domainWithJSONDictionaryError" code:-1 userInfo:nil];
        }
        return nil;
    }
    
    LEDDomainObject *domainObject = [MTLJSONAdapter modelOfClass:self fromJSONDictionary:dictionary error:&localError];
    if (localError) {
        if (error) {
            *error = [NSError errorWithDomain:@"domainWithJSONDictionaryError" code:-1 userInfo:nil];
        }
    }
    
    return domainObject;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *predicateDictionary = [self predicateDictionary];
    NSDictionary *JSONDictionary = [predicateDictionary mapJSONValidator:^id (LEDDomainPredicate *predicate, NSString *keypath) {
        return predicate.key ? : keypath;
    }];
    return JSONDictionary;
}

+ (NSDictionary *)validationRequirements
{
    return [self predicateDictionary];
}

+ (NSDictionary *)predicateDictionary
{
    return nil;
}

- (instancetype)initWithJSON:(NSDictionary *)dictionary error:(NSError *__autoreleasing *)error
{
    return [super initWithDictionary:dictionary error:error];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error
{
    NSMutableDictionary *afterMappingPredicateDictionary = [NSMutableDictionary dictionary];
    [[[self class] predicateDictionary] enumerateKeysAndObjectsUsingBlock:^(NSString *key, LEDDomainPredicate *predicate, BOOL *stop) {
        [afterMappingPredicateDictionary setValue:predicate.afterMappingPredicate ? : predicate.beforeMappingPredicate forKeyPath:key];
    }];
    if ([RPJSONValidator validateValuesFrom:dictionaryValue
                           withRequirements:afterMappingPredicateDictionary
                                      error:error]) {
        return [super initWithDictionary:dictionaryValue error:error];
    } else {
        return nil;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    
    return [[self.class allocWithZone:zone] initWithJSON:self.dictionaryValue error:nil];
}

@end

