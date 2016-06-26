//
//  BSBaseViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/6/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSBaseViewController.h"

@interface BSBaseViewController ()

@end

@implementation BSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 导航栏左边按钮，可以放到基类vc中,也可以自定义导航控制器
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBarButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    [leftBarButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [leftBarButton sizeToFit];
    // 左边距离调整
    leftBarButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [leftBarButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
