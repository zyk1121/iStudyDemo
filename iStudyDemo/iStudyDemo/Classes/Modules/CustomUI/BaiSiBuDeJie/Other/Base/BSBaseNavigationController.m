//
//  BSBaseNavigationController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/6/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSBaseNavigationController.h"

@interface BSBaseNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation BSBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 右滑手势是否可用
    self.interactivePopGestureRecognizer.delegate = self;
    
    // 导航栏的背景图片
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //
    if (self.childViewControllers.count) {
        // viewController 不是最早push进来的
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
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
        
        viewController.hidesBottomBarWhenPushed = YES;// 隐藏工具条
    }
    
    // 所有设置ok后，再push
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
//    if (self.childViewControllers.count == 1) {
//        return NO;
//    }
//    return YES;
    return self.childViewControllers.count > 1;
}

@end
