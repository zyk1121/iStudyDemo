//
//  MVVMViewController.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDMVVMViewModel.h"
#import <UIKit/UIKit.h>

@interface MVVMViewController : UIViewController

// 一般viewModel需要外部调用，需要构造
- (instancetype)initWithViewModel:(LEDMVVMViewModel*)viewModel;

@end
