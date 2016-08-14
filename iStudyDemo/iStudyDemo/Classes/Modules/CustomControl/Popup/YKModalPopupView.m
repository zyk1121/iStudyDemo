//
//  YKModalPopupView.m
//  YKModalPopup
//
//  Created by zhangyuanke on 16/8/14.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "YKModalPopupView.h"
#import "YKModalPopup.h"


@interface YKModalPopupView ()<UITextFieldDelegate>

{
    UITextField *textField;
}
@end

@implementation YKModalPopupView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)show
{
//    UILabel *messageLabel = [[UILabel alloc] init];
//    messageLabel.layer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
//    messageLabel.layer.cornerRadius = 6;
//    messageLabel.font = [UIFont systemFontOfSize:15];
//    messageLabel.textColor = [UIColor lightGrayColor];
//    messageLabel.frame = CGRectMake(10, 200, 200, 40);
//    messageLabel.text = @"2334";
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 100, 44)];
    textField.backgroundColor = [UIColor lightGrayColor];
    textField.delegate = self;
    [self addSubview:textField];
    
    [YKModalPopup showWithCustomView:self delegate:nil];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [YKModalPopup dismiss];
//    });

}

- (void)dealloc
{

}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}
- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

@end
