//
//  YUKAlertView.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/8/7.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "YUKAlertView.h"
#import "Masonry.h"
#import "YUKModalView.h"

@interface YUKAlertView ()

@property (nonatomic, weak) id<YUKAlertViewDelegate> delegate;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;

@end

@implementation YUKAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma - mark override

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

// 布局
- (void)updateConstraints
{
//    self.frame = CGRectMake(0, 0, 200, 200);
    UIView *lastView = self;
    if (self.titleLabel) {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(15);
            make.left.greaterThanOrEqualTo(self).offset(15);
            make.right.lessThanOrEqualTo(self).offset(-15);
        }];
        lastView = self.titleLabel;
    }
    
    if (self.messageLabel) {
        [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.mas_bottom).offset(15);
            make.left.greaterThanOrEqualTo(self).offset(15);
            make.right.lessThanOrEqualTo(self).offset(-15);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-15);
        }];
    }
    
    [super updateConstraints];
}

// 设置view的frame
- (void)doLayout
{
    CGRect bounds = self.bounds;
    CGRect winBounds = [UIScreen mainScreen].bounds;
    CGFloat width = bounds.size.width;
    CGFloat height = bounds.size.height;
    
    self.frame = CGRectMake(0, 0, 200, 200);
    
    [self updateConstraintsIfNeeded];
}

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                              message:(nullable NSString *)message
                             delegate:(nullable id)delegate
                         buttonTitles:(nullable NSArray *)buttonTitles
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //
        if ([title length]) {
            _titleLabel = ({
                UILabel *label = [[UILabel alloc] init];
                label.textColor = [UIColor blackColor];
                label.font = [UIFont boldSystemFontOfSize:19];
                label.text = title;
                label;
            });
            [self addSubview:_titleLabel];
        }
        //
        if ([message length]) {
            _messageLabel = ({
                UILabel *label = [[UILabel alloc] init];
                label.textColor = [UIColor grayColor];
                label.font = [UIFont boldSystemFontOfSize:17];
                label.text = message;
                label;
            });
            [self addSubview:_messageLabel];
        }
        self.translatesAutoresizingMaskIntoConstraints = NO;
        //
    }
    return self;
}

- (void)show
{
//     [self doLayout];
//    self.frame = CGRectMake(0, 0, 200, 200);
//    [YUKModalView showWithCustomView:self delegate:nil type:YUKModalViewTypeAlert];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title"   message:@"message" delegate:_delegate cancelButtonTitle:@"dd" otherButtonTitles:@"12", nil];
        [UIView appearance].tintColor = [UIColor redColor];
        [alertView show];
}

+ (void)showWithTitle:(nullable NSString *)title
              message:(nullable NSString *)message
             delegate:(nullable id)delegate
         buttonTitles:(nullable NSArray *)buttonTitles
{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"dd" otherButtonTitles:@"12", nil];
//    [UIView appearance].tintColor = [UIColor redColor];
//    [alertView show];
    
    
}

@end
