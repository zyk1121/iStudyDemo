//
//  LEDProvinces.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/10.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDCities.h"
#import "LEDProvince.h"
#import "LEDProvincesDomain.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import <libextobjc/extobjc.h>

@implementation LEDProvince

+ (NSDictionary*)predicateDictionary
{
    return @{ @keypath(LEDProvince.new, url) : LEDDomainPredicate.wasOptional.isOptional.JSONKey(@"url"),
        @keypath(LEDProvince.new, name) : LEDDomainPredicate.isString.isOptional.JSONKey(@"name"),
        @keypath(LEDProvince.new, jianpin) : LEDDomainPredicate.isString.isOptional.JSONKey(@"jianpin"),
        @keypath(LEDProvince.new, pinyin) : LEDDomainPredicate.isString.isOptional.JSONKey(@"pinyin"),
        @keypath(LEDProvince.new, adcode) : LEDDomainPredicate.isString.isOptional.JSONKey(@"adcode"),
        @keypath(LEDProvince.new, version) : LEDDomainPredicate.isString.isOptional.JSONKey(@"version"),
        @keypath(LEDProvince.new, size) : LEDDomainPredicate.isNumber.JSONKey(@"size"),
        @keypath(LEDProvince.new, cities) : LEDDomainPredicate.wasArray.wasOptional.isOptional.JSONKey(@"cities"),
    };
}

+ (NSValueTransformer*)citiesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[LEDCities class]];
}

@end
