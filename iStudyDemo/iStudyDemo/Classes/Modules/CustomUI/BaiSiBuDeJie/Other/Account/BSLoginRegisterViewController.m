//
//  BSLoginRegisterViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/6/27.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSLoginRegisterViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "BSThirdLoginView.h"
#import "BSLoginRegisterView.h"

@interface BSLoginRegisterViewController ()
{
    CGFloat _loginViewOffset;
    BOOL _animate;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *changeLoginButton;
@property (nonatomic, strong) BSLoginRegisterView *loginView;
@property (nonatomic, strong) BSLoginRegisterView *registerView;
@property (nonatomic, strong) BSThirdLoginView *thirdLoginView;

@end

@implementation BSLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _loginViewOffset = 0;
    _animate = NO;
    [self setupUI];
    [self.view updateConstraintsIfNeeded];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// 隐藏statusbar
//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}

- (void)setupUI
{
    _imageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"login_register_background"];
        [self.view addSubview:imageView];
        imageView;
    });
    
    _thirdLoginView = ({
        BSThirdLoginView *loginView = [[BSThirdLoginView alloc] init];
        [self.view addSubview:loginView];
        loginView;
    });
    
    _closeButton = ({
        UIButton *button = [[UIButton alloc] init];
        // 拉伸
        button.tag = 1;
        [button setBackgroundImage:[UIImage imageNamed:@"login_close_icon"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"login_close_icon"] forState:UIControlStateHighlighted];
        // 不拉伸
        [button setImage:[UIImage imageNamed:@"login_close_icon"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"login_close_icon"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    _changeLoginButton = ({
        UIButton *button = [[UIButton alloc] init];
        // 拉伸
        button.tag = 2;
        [button setTitle:@"注册账号" forState:UIControlStateNormal];
        [button setTitle:@"已有账号？" forState:UIControlStateSelected];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    _loginView = ({
        BSLoginRegisterView *v = [[BSLoginRegisterView alloc] initWithFrame:CGRectZero andLoginRegisterType:BSLoginRegisterTypeLogin];
        [self.view addSubview:v];
        v;
    });
    
    _registerView = ({
        BSLoginRegisterView *v = [[BSLoginRegisterView alloc] initWithFrame:CGRectZero andLoginRegisterType:BSLoginRegisterTypeRegister];
        [self.view addSubview:v];
        v;
    });
}


- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.thirdLoginView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
//        make.height.equalTo(@200);
        make.bottom.equalTo(self.view);
        
    }];
//    
    [self.closeButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(50);
        make.left.equalTo(self.view).offset(20);
    }];
    
    [self.changeLoginButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.centerY.equalTo(self.closeButton);
    }];
    
    [self.loginView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(150);
        make.left.equalTo(self.view).offset(_loginViewOffset);
        make.right.equalTo(self.view).offset(_loginViewOffset);
//        make.height.equalTo(@200);
    }];
    
    [self.registerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginView);
        make.left.equalTo(self.loginView.mas_right);
        make.width.equalTo(self.loginView);
    }];
    
    // 约束动画
    if (_animate) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutSubviews];
        }];
    }
    /* 约束  中执行动画
     // 告诉self.view约束需要更新
     [self.view setNeedsUpdateConstraints];
     // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
     [self.view updateConstraintsIfNeeded];
     
     [UIView animateWithDuration:0.3 animations:^{
     [self.view layoutIfNeeded];
     }];
     */
}

#pragma mark - event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)buttonClicked:(UIButton *)button
{
    [self.view endEditing:YES];
    switch (button.tag) {
        case 1:
            // 关闭
            [self back];
            break;
        case 2:
            // 注册登录
            [self registerAndLoginButtonClicked:button];
            break;
            
        default:
            break;
    }
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerAndLoginButtonClicked:(UIButton *)button
{
    [self.view endEditing:YES];
    _animate = YES;
    if (_loginViewOffset == 0) {
        _loginViewOffset = -SCREEN_WIDTH;
        button.selected = YES;
    } else {
        _loginViewOffset = 0;
        button.selected = NO;
    }
    [self.view setNeedsUpdateConstraints];
}

@end

