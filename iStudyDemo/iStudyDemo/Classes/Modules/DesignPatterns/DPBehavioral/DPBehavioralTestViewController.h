//
//  DPBehavioralTestViewController.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/5/5.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DPBehavioralTypeDPChainResponsibility, // 责任链模式
    DPBehavioralTypeDPCommand, // 命令模式
    DPBehavioralTypeDPInterpreter, // 解释器模式
    DPBehavioralTypeDPIterator, // 迭代器模式
    DPBehavioralTypeDPMediator, // 中介者模式
    DPBehavioralTypeDPMemento, // 备忘录模式
    DPBehavioralTypeDPNULLObject, // 空对象模式
    DPBehavioralTypeDPObserver, // 观察者模式
    DPBehavioralTypeDPState, // 状态模式
    DPBehavioralTypeDPStrategy, // 策略式
    DPBehavioralTypeDPTemplate, // 模版模式
    DPBehavioralTypeDPVisitor, // 访问者模式
}DPBehavioralType;

@interface DPBehavioralTestViewController : UIViewController

- (instancetype)initWithType:(DPBehavioralType)type;

@end
