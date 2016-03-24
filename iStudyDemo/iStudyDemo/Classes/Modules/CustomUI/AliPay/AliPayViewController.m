//
//  AliPayViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/21.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "AliPayViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "ZFBViewController.h"
#import "WDViewController.h"
#import "PYViewController.h"
#import "KBViewController.h"

@implementation AliPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 添加子控制器
    [self addChildVc:[[ZFBViewController alloc] init] title:@"支付宝" image:@"zfb" selectedImage:@"zfb_sel"];
    [self addChildVc:[[KBViewController alloc] init] title:@"口碑" image:@"kb" selectedImage:@"kb_sel"];
    [self addChildVc:[[PYViewController alloc] init] title:@"朋友" image:@"py" selectedImage:@"py_sel"];
    [self addChildVc:[[WDViewController alloc] init] title:@"我的" image:@"wd" selectedImage:@"wd_sel"];
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字(可以设置tabBar和navigationBar的文字)
    childVc.title = title;
//    childVc.view.backgroundColor = [UIColor whiteColor];
    
    // 设置子控制器的tabBarItem图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    // 禁用图片渲染
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:20/255.0 green:152/255.0 blue:234/255.0 alpha:1]} forState:UIControlStateSelected];
    //    childVc.view.backgroundColor = RandomColor; // 这句代码会自动加载主页，消息，发现，我四个控制器的view，但是view要在我们用的时候去提前加载
    
    // 为子控制器包装导航控/Users/zhangyuanke/Desktop/Projects/iOS/iStudyDemo/iStudyDemo/iStudyDemo/Images.xcassets制器
    UINavigationController *navigationVc = [[UINavigationController alloc] initWithRootViewController:childVc];
    // 添加子控制器
    [self addChildViewController:navigationVc];
}

@end
