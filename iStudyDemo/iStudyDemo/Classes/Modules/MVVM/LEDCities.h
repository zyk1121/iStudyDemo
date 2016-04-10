//
//  LEDCities.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/9.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDDomainObject.h"

//{"adcode":"340100","url":"http://vmapdownload.ishowchina.com/vmap/mapdata/20160314/hefei.zip","name":"合肥市","citycode":"","pinyin":"hefei","jianpin":"hf","version":"20160314","size":8707336,"md5":"36143af8df85b9033d134e2d01eb211b"}

@interface LEDCities : LEDDomainObject

@property (nonatomic, strong) NSURL* url;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* jianpin;
@property (nonatomic, copy) NSString* pinyin;
@property (nonatomic, copy) NSString* adcode;
@property (nonatomic, copy) NSString* citycode;
@property (nonatomic, copy) NSString* version;
@property (nonatomic, assign) NSUInteger size;
@property (nonatomic, copy) NSString* md5;

@end
