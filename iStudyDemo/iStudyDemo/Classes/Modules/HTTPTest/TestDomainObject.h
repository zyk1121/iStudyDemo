//
//  TestDomainObject.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/7.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDDomainObject.h"

@interface TestDomainObject : LEDDomainObject

@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, strong) NSURL *iconURL;
@property (nonatomic, assign) double amount;

@end
