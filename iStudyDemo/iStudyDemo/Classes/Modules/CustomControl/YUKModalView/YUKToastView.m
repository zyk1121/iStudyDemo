//
//  YUKToastView.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/8/7.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "YUKToastView.h"
#import "YUKModalView.h"

@implementation YUKToastView

+ (void)showMessage:(NSString*)message
{

}

+ (void)showMessage:(NSString*)message duration:(float)duration
{

}

+ (void)showMessage:(NSString*)message duration:(float)duration position:(YUKToastViewPosition)position
{
    if ([message length] == 0) {
        return;
    }
    
    if (duration <= 0) {
        duration = 1.0;
    }
    CGRect bounds = [UIScreen mainScreen].bounds;
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.layer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
    messageLabel.layer.cornerRadius = 6;
    messageLabel.font = [UIFont systemFontOfSize:15];
    messageLabel.textColor = [UIColor lightGrayColor];
    messageLabel.frame = CGRectMake(10, 200, 200, 40);
    messageLabel.text = message;
    
    [YUKModalView showWithCustomView:messageLabel delegate:nil type:YUKModalViewTypeToast];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [YUKModalView dismiss];
    });
}

@end
