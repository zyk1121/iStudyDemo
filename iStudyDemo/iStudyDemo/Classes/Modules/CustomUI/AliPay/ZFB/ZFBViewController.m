//
//  ZFBViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/23.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "ZFBViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "ZFBTestViewController.h"

@interface ZFBViewController ()

@property (nonatomic, strong) UIView *view1;


@end

@implementation ZFBViewController
{
    UIImageView *navBarHairlineImageView;// 去除黑线第二种方法
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithRed:28/255.0 green:182/255.0 blue:165/255.0 alpha:1];
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    _view1.backgroundColor = [UIColor colorWithRed:37/255.0 green:192/255.0 blue:180/255.0 alpha:1];
    [self.view addSubview:_view1];
    
    UIButton *button1 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(40, 20, 40, 40)];
        [button setBackgroundImage:[UIImage imageNamed:@"10000004"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [_view1 addSubview:button1];
    
    UIButton *button2 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(140, 20, 40, 40)];
        [button setBackgroundImage:[UIImage imageNamed:@"10000006"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [_view1 addSubview:button2];
    
    
    UIButton *button3 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(240, 20, 40, 40)];
        [button setBackgroundImage:[UIImage imageNamed:@"10000004"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [_view1 addSubview:button3];

}

- (void)buttonClick
{
    ZFBTestViewController *vc = [[ZFBTestViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
//    self.view.backgroundColor = [UIColor colorWithRed:37/255.0 green:192/255.0 blue:180/255.0 alpha:1];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    navBarHairlineImageView = [self findHairlineImageViewUnder:navigationBar];
    // white.png图片自己下载个纯白色的色块，或者自己ps做一个
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    // 28 182 165
//    [navigationBar setShadowImage:[UIImage new]];
    // UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    /*去除黑线第一种方法  ，但是有一个缺陷-删除了translucency(半透明)
    // white.png图片自己下载个纯白色的色块，或者自己ps做一个
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"white.png"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
     */
    
    
    navBarHairlineImageView.hidden = YES;
}


- (void)viewWillDisappear:(BOOL)animated
{
    navBarHairlineImageView.hidden = NO;
}
@end
