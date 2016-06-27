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

@interface BSLoginRegisterViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *changeLoginButton;

@property (nonatomic, strong) BSThirdLoginView *thirdLoginView;

@end

@implementation BSLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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
    
//    _label = ({
//        UILabel *label = [[UILabel alloc] init];
//        label.numberOfLines = 0;
//        label.textAlignment = NSTextAlignmentCenter;
//        label.text = @"中华热门么领导蒙骗感觉饿哦评估金额破\ndfjioeghofei\nfjieofieenkrgn\nkfnr";
//        label.textColor = [UIColor redColor];
//        [self.view addSubview:label];
//        label;
//    });
//    
//    _button = ({
//        UIButton *button = [[UIButton alloc] init];
//        button.tag = 1;
//        //        button.backgroundColor = [UIColor whiteColor];
//        [button setTitle:@"立即登录注册" forState:UIControlStateNormal];
//        [button setTitle:@"立即登录注册" forState:UIControlStateHighlighted];
//        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//        [button setBackgroundImage:[UIImage imageNamed:@"friendsTrend_login"] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageNamed:@"friendsTrend_login_click"] forState:UIControlStateHighlighted];
//        //        [button setBackgroundImage:[UIImage imageNamed:@"route_selected"] forState:UIControlStateSelected];
//        //        [button setImage:[UIImage imageNamed:@"friendsTrend_login"] forState:UIControlStateNormal];
//        //        [button setImage:[UIImage imageNamed:@"friendsTrend_login_click"] forState:UIControlStateHighlighted];
//        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:button];
//        button;
//    });

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
//    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.imageView.mas_bottom).offset(20);
//        make.centerX.equalTo(self.view);
//        make.left.equalTo(self.view).offset(20);
//        make.right.equalTo(self.view).offset(-20);
//    }];
//    
//    [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.label.mas_bottom).offset(20);
//        make.centerX.equalTo(self.view);
//        make.left.equalTo(self.view).offset(20);
//        make.right.equalTo(self.view).offset(-20);
//    }];
}


#pragma mark - navibar clicked

- (void)leftBarButtonClicked
{
//    // 推荐关注
//    BSFRecommandFollowViewController *vc = [[BSFRecommandFollowViewController alloc] init];
//    //    vc.tabBarItem
//    //    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - event

- (void)buttonClicked:(UIButton *)button
{
    
}


@end

