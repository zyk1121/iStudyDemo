//
//  LEDStudent+Other.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/10.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDStudent+Other.h"
#import <objc/runtime.h>

static void * nameKey = &nameKey;

@implementation LEDStudent (Other)

- (NSString *)name
{
    NSString *name = objc_getAssociatedObject(self, nameKey);
    return name;
}

- (void)setName:(NSString *)name
{
    objc_setAssociatedObject(self, nameKey, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


@end
