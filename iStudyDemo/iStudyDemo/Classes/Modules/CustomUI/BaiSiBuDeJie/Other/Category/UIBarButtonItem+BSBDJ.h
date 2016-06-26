//
//  UIBarButtonItem+BSBDJ.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/6/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIBarButtonItem (BSBDJ)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
