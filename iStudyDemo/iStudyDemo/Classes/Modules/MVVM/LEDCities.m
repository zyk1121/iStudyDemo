//
//  LEDCities.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/9.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDCities.h"
#import "LEDDomainObject.h"
#import <libextobjc/extobjc.h>

@implementation LEDCities

+ (NSDictionary*)predicateDictionary
{
    return @{ @keypath(LEDCities.new, url) : LEDDomainPredicate.wasOptional.isOptional.JSONKey(@"url"),
        @keypath(LEDCities.new, name) : LEDDomainPredicate.isString.isOptional.JSONKey(@"name"),
        @keypath(LEDCities.new, jianpin) : LEDDomainPredicate.isString.isOptional.JSONKey(@"jianpin"),
        @keypath(LEDCities.new, pinyin) : LEDDomainPredicate.isString.isOptional.JSONKey(@"pinyin"),
        @keypath(LEDCities.new, adcode) : LEDDomainPredicate.isString.isOptional.JSONKey(@"adcode"),
        @keypath(LEDCities.new, citycode) : LEDDomainPredicate.isString.isOptional.JSONKey(@"citycode"),
        @keypath(LEDCities.new, version) : LEDDomainPredicate.isString.isOptional.JSONKey(@"version"),
        @keypath(LEDCities.new, md5) : LEDDomainPredicate.isString.isOptional.JSONKey(@"md5"),
        @keypath(LEDCities.new, size) : LEDDomainPredicate.isNumber.JSONKey(@"size"),
    };
}

+ (NSValueTransformer*)urlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
