//
//  DPCreationalTestViewController.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/5/5.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DPCreationalTypeSimpleFactory, // 简单工厂模式
    DPCreationalTypeAbstractFactory, // 抽象工厂模式
    DPCreationalTypeSingleton, // 单例模式
    DPCreationalTypeBuilder, // 建造者模式
    DPCreationalTypePrototype, // 原型模式
}DPCreationalType;


@interface DPCreationalTestViewController : UIViewController

- (instancetype)initWithType:(DPCreationalType)type;

@end
