//
//  BSNViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/6/25.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSNViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"

@implementation BSNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"百思不得姐";
    [self setupUI];
}

- (void)setupUI
{
    // 导航栏左边按钮
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBarButton setImage:[UIImage imageNamed:@"MainTagSubIcon"] forState:UIControlStateNormal];
    [leftBarButton setImage:[UIImage imageNamed:@"MainTagSubIconClick"] forState:UIControlStateHighlighted];
    UIImage *image = [leftBarButton imageForState:UIControlStateNormal];
    leftBarButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [leftBarButton sizeToFit];
    [leftBarButton addTarget:self action:@selector(leftBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];

}

#pragma mark - event


- (void)leftBarButtonClicked
{
    
}


@end
