//
//  DPStructuralTestViewController.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/5/5.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DPStructuralTypeDPAdapter, // 适配器模式
    DPStructuralTypeDPBridge, // 桥接模式
    DPStructuralTypeDPComposite, // 组合模式
    DPStructuralTypeDPDecorator, // 装饰器模式
    DPStructuralTypeDPFacade, // 外观模式
    DPStructuralTypeDPFilter, // 过滤器模式
    DPStructuralTypeDPFlyweight, // 享元模式
    DPStructuralTypeDPProxy, // 代理模式
}DPStructuralType;

@interface DPStructuralTestViewController : UIViewController

- (instancetype)initWithType:(DPStructuralType)type;

@end
