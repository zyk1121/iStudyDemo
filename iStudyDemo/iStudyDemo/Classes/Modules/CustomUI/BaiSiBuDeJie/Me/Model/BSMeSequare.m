//
//  BSMeSequare.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/1.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSMeSequare.h"

@implementation BSMeSequare

+ (NSDictionary *)predicateDictionary
{
    return @{@keypath(BSMeSequare.new, name) : LEDDomainPredicate.wasOptional.isString.isOptional.JSONKey(@"name"),
              @keypath(BSMeSequare.new, icon) : LEDDomainPredicate.wasOptional.isString.isOptional.JSONKey(@"icon"),
              @keypath(BSMeSequare.new, linkURL) : LEDDomainPredicate.wasString.wasOptional.isOptional.JSONKey(@"url"),
              };
}

@end
