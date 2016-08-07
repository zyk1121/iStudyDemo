//
//  YUKAlertView.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/8/7.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "YUKAlertView.h"

@interface YUKAlertView ()

@property (nonatomic, weak) id<YUKAlertViewDelegate> delegate;

@end

@implementation YUKAlertView

+ (void)showWithTitle:(nullable NSString *)title
              message:(nullable NSString *)message
             delegate:(nullable id)delegate
         buttonTitles:(nullable NSArray *)buttonTitles
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"dd" otherButtonTitles:@"12", nil];
    [UIView appearance].tintColor = [UIColor redColor];
    [alertView show];
}

@end
