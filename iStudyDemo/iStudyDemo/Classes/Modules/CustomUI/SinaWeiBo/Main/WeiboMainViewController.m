//
//  WeiboMainViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/22.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "WeiboMainViewController.h"
#import "ZTTabBar.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "WeiboSearchViewController.h"

@interface WeiboMainViewController ()<ZTTabBarDelegate>

@end

@implementation WeiboMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"新浪微博";
    // 隐藏当前的导航栏
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    // 添加子控制器
    [self addChildVc:[[UIViewController alloc] init] title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    [self addChildVc:[[UIViewController alloc] init] title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    [self addChildVc:[[WeiboSearchViewController alloc] init] title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    [self addChildVc:[[UIViewController alloc] init] title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    ZTTabBar *tabBar = [[ZTTabBar alloc] init];
    tabBar.delegate = self;
    // KVC：如果要修系统的某些属性，但被设为readOnly，就是用KVC，即setValue：forKey：。
    [self setValue:tabBar forKey:@"tabBar"];

    // 去除tab bar顶部黑线,完全透明了
    [self.tabBar setBackgroundImage:[[UIImage alloc] init]];
    [self.tabBar setShadowImage:[[UIImage alloc] init]];
    
    // tabbar 添加背景颜色
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    backView.backgroundColor = [UIColor grayColor];
    [self.tabBar insertSubview:backView atIndex:0];
    self.tabBar.opaque = YES;
//    [backView release];
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
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]} forState:UIControlStateSelected];
    //    childVc.view.backgroundColor = RandomColor; // 这句代码会自动加载主页，消息，发现，我四个控制器的view，但是view要在我们用的时候去提前加载
    
    // 为子控制器包装导航控/Users/zhangyuanke/Desktop/Projects/iOS/iStudyDemo/iStudyDemo/iStudyDemo/Images.xcassets制器
    UINavigationController *navigationVc = [[UINavigationController alloc] initWithRootViewController:childVc];
    // 添加子控制器
    [self addChildViewController:navigationVc];
}

#pragma ZTTabBarDelegate
/**
 *  加号按钮点击
 */
- (void)tabBarDidClickPlusButton:(ZTTabBar *)tabBar
{
    WeiboSearchViewController *vc = [[WeiboSearchViewController alloc] init];
    vc.title = @"测试";
    vc.view.backgroundColor = [UIColor lightGrayColor];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
//    [self.navigationController pushViewController:vc animated:YES];
}


@end
