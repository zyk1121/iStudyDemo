//
//  LEDProvincesDomain.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/9.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDDomainObject.h"
//http://vmap.ishowchina.com/offline/resource?mapver=20160314
/*
 "url":"","name":"安徽省","jianpin":"ahs","pinyin":"anhuisheng","adcode":"340000","version":"20160314","size":72578309,"cities":
 */

@interface LEDProvincesDomain : LEDDomainObject

@property (nonatomic, copy) NSString* version;
@property (nonatomic, copy) NSArray* provinces;

@end
