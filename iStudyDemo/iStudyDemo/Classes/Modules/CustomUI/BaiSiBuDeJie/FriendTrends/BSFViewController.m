//
//  BSFViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/6/25.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSFViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "BSFRecommandFollowViewController.h"
#import "BSLoginRegisterViewController.h"

@interface BSFViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;

@end

@implementation BSFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的关注";
    [self setupUI];
    [self.view updateConstraintsIfNeeded];
}

- (void)setupUI
{
    // 导航栏右边按钮
//    UIBarButtonItem *bardoneBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(bardoneBtnClicked)];
//    UIBarButtonItem *barcancelBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(barcancelBtnClicked)];
//    NSArray *rightBtns=[NSArray arrayWithObjects:barcancelBtn, nil];
//    self.navigationItem.rightBarButtonItems=rightBtns;
    
    
    // 导航栏左边按钮
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBarButton setImage:[UIImage imageNamed:@"friendsRecommentIcon"] forState:UIControlStateNormal];
    [leftBarButton setImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] forState:UIControlStateHighlighted];
    UIImage *image = [leftBarButton imageForState:UIControlStateNormal];
    leftBarButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [leftBarButton sizeToFit];
    [leftBarButton addTarget:self action:@selector(leftBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    
    //
    _imageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.image = [UIImage imageNamed:@"header_cry_icon"];
        [self.view addSubview:imageView];
        imageView;
    });
    
    _label = ({
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"中华热门么领导蒙骗感觉饿哦评估金额破\ndfjioeghofei\nfjieofieenkrgn\nkfnr";
        label.textColor = [UIColor redColor];
        [self.view addSubview:label];
        label;
    });
    
    _button = ({
        UIButton *button = [[UIButton alloc] init];
        button.tag = 1;
//        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:@"立即登录注册" forState:UIControlStateNormal];
        [button setTitle:@"立即登录注册" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"friendsTrend_login"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"friendsTrend_login_click"] forState:UIControlStateHighlighted];
//        [button setBackgroundImage:[UIImage imageNamed:@"route_selected"] forState:UIControlStateSelected];
//        [button setImage:[UIImage imageNamed:@"friendsTrend_login"] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"friendsTrend_login_click"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
}


- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.centerX.equalTo(self.view);
    }];
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(20);
         make.right.equalTo(self.view).offset(-20);
    }];
    
    [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
         make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
}


#pragma mark - navibar clicked

- (void)leftBarButtonClicked
{
    // 推荐关注
    BSFRecommandFollowViewController *vc = [[BSFRecommandFollowViewController alloc] init];
//    vc.tabBarItem
//    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - event

- (void)buttonClicked:(UIButton *)button
{
    BSLoginRegisterViewController *loginVC = [[BSLoginRegisterViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:^{
        
    }];
}


@end
