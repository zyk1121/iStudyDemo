//
//  LEDMVVMViewModel.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/10.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDProvincesDomain.h"
#import <Foundation/Foundation.h>

@class RACCommand;
@interface LEDMVVMViewModel : NSObject

@property (nonatomic, strong) RACCommand* loadCommand;
@property (nonatomic, strong) LEDProvincesDomain* provinces;

@end
