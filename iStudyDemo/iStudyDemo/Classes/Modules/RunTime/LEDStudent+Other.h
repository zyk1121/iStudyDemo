//
//  LEDStudent+Other.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/10.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEDStudent.h"

// 分类，我们知道，使用Category可以很方便地为现有的类增加方法，但却无法直接增加实例变量。
@interface LEDStudent (Other)

@property (nonatomic, copy) NSString *name;

@end
