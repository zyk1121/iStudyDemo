//
//  LEDStubManager.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/10.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEDStubManager : NSObject

+ (instancetype)defaultStubManager;

- (void)setupHTTPStubs;

@end
