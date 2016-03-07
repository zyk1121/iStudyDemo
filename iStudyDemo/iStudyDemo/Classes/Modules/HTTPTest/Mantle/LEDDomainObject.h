//
//  LEDDomainObject.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/7.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDDomainPredicate.h"
#import "Mantle.h"

@interface LEDDomainObject : MTLModel <MTLJSONSerializing>

+ (NSDictionary *)predicateDictionary;

+ (instancetype)domainWithJSONDictionary:(NSDictionary *)dictionary error:(NSError **)error;

+ (instancetype)domainWithJSONDictionary:(NSDictionary *)dictionary;

@end
