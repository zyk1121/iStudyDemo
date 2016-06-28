//
//  BSLoginRegisterView.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/6/28.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum BSLoginRegisterType{
    BSLoginRegisterTypeLogin, // 登录
    BSLoginRegisterTypeRegister, // 注册
}BSLoginRegisterType;

@interface BSLoginRegisterView : UIView

@property (nonatomic, assign) BSLoginRegisterType type;

// 默认是登录界面
- (instancetype)initWithFrame:(CGRect)frame andLoginRegisterType:(BSLoginRegisterType)type;

@end
