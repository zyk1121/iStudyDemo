//
//  JsonModelDomainObject.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/4.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "JsonModelDomainObject.h"

@implementation Student


@end

@implementation JsonModelDomainObject

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"bankname": @"bankName",
                                                       @"icon": @"iconURL",
                                                       @"amount": @"amount" ,// 这里就采用了KVC的方式来取值，它赋给price属性
                                                       @"arr": @"arr"
                                                       }];
}
@end
