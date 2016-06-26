//
//  UIBarButtonItem+BSBDJ.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/6/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "UIBarButtonItem+BSBDJ.h"

@implementation UIBarButtonItem (BSBDJ)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    UIImage *normalImage = [button imageForState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

@end
