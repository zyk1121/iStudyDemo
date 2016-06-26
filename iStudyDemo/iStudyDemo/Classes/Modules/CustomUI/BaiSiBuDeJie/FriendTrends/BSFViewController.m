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

@implementation BSFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的关注";
    [self setupUI];
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


@end
