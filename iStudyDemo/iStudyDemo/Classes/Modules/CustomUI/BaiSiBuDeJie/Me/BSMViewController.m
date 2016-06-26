//
//  BSMViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/6/25.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSMViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "UIBarButtonItem+BSBDJ.h"

@implementation BSMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的";
    [self setupUI];
}

- (void)setupUI
{
    // 导航栏右边按钮
//    UIBarButtonItem *settingBtn = ({
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setImage:[UIImage imageNamed:@"mine-setting-icon"] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"mine-setting-icon-click"] forState:UIControlStateHighlighted];
//        UIImage *image = [button imageForState:UIControlStateNormal];
//        button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//        [button sizeToFit];
//        [button addTarget:self action:@selector(settingBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//        [[UIBarButtonItem alloc] initWithCustomView:button];
//    });
//    UIBarButtonItem *nightStyleBtn = ({
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setImage:[UIImage imageNamed:@"mine-moon-icon"] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"mine-moon-icon-click"] forState:UIControlStateHighlighted];
//        UIImage *image = [button imageForState:UIControlStateNormal];
//        button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//        [button sizeToFit];
//        [button addTarget:self action:@selector(nightStyleBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//        [[UIBarButtonItem alloc] initWithCustomView:button];
//    });
    
    UIBarButtonItem *settingBtn = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingBtnClicked)];
    
    UIBarButtonItem *nightStyleBtn = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(nightStyleBtnClicked)];
    
    NSArray *rightBtns=[NSArray arrayWithObjects:settingBtn,nightStyleBtn, nil];
    self.navigationItem.rightBarButtonItems=rightBtns;
    
}

#pragma mark - navibar clicked

- (void)settingBtnClicked
{
    // 设置按钮点击
    UIViewController *vc = [[UIViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)nightStyleBtnClicked
{
    // 夜间模式点击
    UIViewController *vc = [[UIViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
