//
//  BSThirdLoginView.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/6/28.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSThirdLoginView.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "BSQuickLoginButton.h"

@interface BSThirdLoginView ()

@property (nonatomic, strong) UIImageView *leftLineImageView;
@property (nonatomic, strong) UILabel *longinLabel;
@property (nonatomic, strong) UIImageView *rightLineImageView;
@property (nonatomic, strong) BSQuickLoginButton *qqLoginButton;
@property (nonatomic, strong) BSQuickLoginButton *weiboLoginButton;
@property (nonatomic, strong) BSQuickLoginButton *tencentLoginButton;

@end

@implementation BSThirdLoginView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         [self setupUI];
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)setupUI
{
    _leftLineImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"login_register_left_line"];
        [self addSubview:imageView];
        imageView;
    });
    _longinLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"立即登录";
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        label;
    });
    _rightLineImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"login_register_right_line"];
        [self addSubview:imageView];
        imageView;
    });
    
    _qqLoginButton = ({
        BSQuickLoginButton *button = [[BSQuickLoginButton alloc] init];
        button.tag = 1;
        [button setTitle:@"QQ登录" forState:UIControlStateNormal];
        [button setTitle:@"QQ登录" forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"login_QQ_icon"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"login_QQ_icon_click"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        button;
    });
    
    _weiboLoginButton = ({
        BSQuickLoginButton *button = [[BSQuickLoginButton alloc] init];
        button.tag = 2;
        [button setTitle:@"微博登录" forState:UIControlStateNormal];
        [button setTitle:@"微博登录" forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"login_sina_icon"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"login_sina_icon_click"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        button;
    });
    
    _tencentLoginButton = ({
        BSQuickLoginButton *button = [[BSQuickLoginButton alloc] init];
        button.tag = 3;
        [button setTitle:@"腾讯登录" forState:UIControlStateNormal];
        [button setTitle:@"腾讯登录" forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"login_tecent_icon"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"login_tecent_icon_click"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        button;
    });
}

- (void)updateConstraints
{
    //
    [self.longinLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.centerX.equalTo(self);
    }];
    
    [self.leftLineImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self.longinLabel.mas_left).offset(-10);
        make.centerY.equalTo(self.longinLabel);
    }];
    
    [self.rightLineImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.longinLabel.mas_right).offset(10);
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self.longinLabel);
    }];
    
    [self.qqLoginButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.longinLabel.mas_bottom).offset(15);
//        make.centerX.equalTo(self);
        make.right.equalTo(self.weiboLoginButton.mas_left);
        make.width.equalTo(@(SCREEN_WIDTH / 3));
        make.height.equalTo(@(self.weiboLoginButton.imageView.image.size.height + 30));
    }];
    
    [self.weiboLoginButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.longinLabel.mas_bottom).offset(15);
        make.centerX.equalTo(self);
        make.width.equalTo(@(SCREEN_WIDTH / 3));
        make.height.equalTo(@(self.weiboLoginButton.imageView.image.size.height + 30));
        make.bottom.equalTo(self);
    }];
    
    [self.tencentLoginButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.longinLabel.mas_bottom).offset(15);
//        make.centerX.equalTo(self);
        make.left.equalTo(self.weiboLoginButton.mas_right);
        make.width.equalTo(@(SCREEN_WIDTH / 3));
        make.height.equalTo(@(self.weiboLoginButton.imageView.image.size.height + 30));
    }];
    
    
    [super updateConstraints];
}

#pragma mark - event

- (void)buttonClicked:(UIButton *)button
{
    
}



@end
