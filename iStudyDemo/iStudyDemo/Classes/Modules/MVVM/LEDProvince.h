//
//  LEDProvinces.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/10.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDDomainObject.h"

@interface LEDProvince : LEDDomainObject

@property (nonatomic, strong) NSURL* url;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* jianpin;
@property (nonatomic, copy) NSString* pinyin;
@property (nonatomic, copy) NSString* adcode;
@property (nonatomic, copy) NSString* version;
@property (nonatomic, assign) NSUInteger size;
@property (nonatomic, copy) NSArray* cities;

@end
