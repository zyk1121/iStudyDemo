//
//  BSFRecommandFollowViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/6/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSFRecommandFollowViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "UIBarButtonItem+BSBDJ.h"

@implementation BSFRecommandFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"推荐关注";
    [self setupUI];
}

- (void)setupUI
{
    // 重写左边按钮
//    UIBarButtonItem *settingBtn = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingBtnClicked)];
//    self.navigationItem.leftBarButtonItem=settingBtn;
    
}


@end
