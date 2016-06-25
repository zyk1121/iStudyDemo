//
//  BSMainViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/6/25.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSMainViewController.h"
#import "BSEViewController.h"
#import "BSFViewController.h"
#import "BSMViewController.h"
#import "BSNViewController.h"
#import "BSPViewController.h"
#import "ZTTabBar.h"
#import "UIKitMacros.h"

@interface BSMainViewController ()<ZTTabBarDelegate>

@end

@implementation BSMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 添加子控制器
    [self addChildVc:[[BSEViewController alloc] init] title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    [self addChildVc:[[BSNViewController alloc] init] title:@"新帖" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    [self addChildVc:[[BSFViewController alloc] init] title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    [self addChildVc:[[BSMViewController alloc] init] title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    
    //  另外一种方案：中间加入一个，空的控制器，titile和image，然后可以在中间加入一个按钮解决问题
    /*不过中间的发布按钮添加的时机应该是：viewwillappear中添加，因为如果过早的加入了按钮，按钮会在tabbar下面，点击的时候不响应，所以，需要在tabbaritem添加之后添加按钮*/
    
    
    
    // 这个时候tabbar还没有设置，所以可以在内部先加入一个按钮，其他的tabbaritem是在view将要显示的时候才加入的，在这个按钮添加之后添加的，时机问题  ****************
    ZTTabBar2 *tabBar = [[ZTTabBar2 alloc] init];
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
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]} forState:UIControlStateSelected];
    //    childVc.view.backgroundColor = RandomColor; // 这句代码会自动加载主页，消息，发现，我四个控制器的view，但是view要在我们用的时候去提前加载
    
    // 为子控制器包装导航控/Users/zhangyuanke/Desktop/Projects/iOS/iStudyDemo/iStudyDemo/iStudyDemo/Images.xcassets制器
    UINavigationController *navigationVc = [[UINavigationController alloc] initWithRootViewController:childVc];
    // 添加子控制器
    [self addChildViewController:navigationVc];
}

- (void)test
{
    // 全局设置item属性
    UITabBarItem *item = [UITabBarItem appearance];
    // 全局设置UISwitch开关的属性
    /*
     @property(nullable, nonatomic, strong) UIColor *onTintColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
     @property(null_resettable, nonatomic, strong) UIColor *tintColor NS_AVAILABLE_IOS(6_0);
     @property(nullable, nonatomic, strong) UIColor *thumbTintColor NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
     
     @property(nullable, nonatomic, strong) UIImage *onImage NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
     @property(nullable, nonatomic, strong) UIImage *offImage NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
     */
    UISwitch *sw = [UISwitch appearance];
    sw.onTintColor = [UIColor redColor];// UI_APPEARANCE_SELECTOR
}

#pragma ZTTabBarDelegate
/**
 *  加号按钮点击
 */
- (void)tabBarDidClickPlusButton:(ZTTabBar *)tabBar
{
    BSPViewController *bspVC = [[BSPViewController alloc] init];
    [self presentViewController:bspVC animated:YES completion:^{
        
    }];
}


@end
