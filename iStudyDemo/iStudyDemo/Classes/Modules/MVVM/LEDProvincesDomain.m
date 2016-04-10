//
//  LEDProvincesDomain.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/9.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDCities.h"
#import "LEDProvince.h"
#import "LEDProvincesDomain.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import <libextobjc/extobjc.h>

@implementation LEDProvincesDomain

+ (NSDictionary*)predicateDictionary
{
    return @{
        @keypath(LEDProvincesDomain.new, version) : LEDDomainPredicate.isString.isOptional.JSONKey(@"version"),
        @keypath(LEDProvincesDomain.new, provinces) : LEDDomainPredicate.wasArray.wasOptional.isOptional.JSONKey(@"provinces"),
    };
}

+ (NSValueTransformer*)provincesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[LEDProvince class]];
}

@end
