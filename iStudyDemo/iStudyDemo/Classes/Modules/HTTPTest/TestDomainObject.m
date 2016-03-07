//
//  TestDomainObject.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/7.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "TestDomainObject.h"
#import <libextobjc/extobjc.h>

@implementation TestDomainObject

+ (NSDictionary *)predicateDictionary
{
    return @{@keypath(TestDomainObject.new, bankName) : LEDDomainPredicate.isString.JSONKey(@"bankname"),
              @keypath(TestDomainObject.new, iconURL) : LEDDomainPredicate.wasString.wasOptional.isOptional.JSONKey(@"icon"),
              @keypath(TestDomainObject.new, amount) : LEDDomainPredicate.isNumber.JSONKey(@"amount"),
              };
}

+ (NSValueTransformer *)iconURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
