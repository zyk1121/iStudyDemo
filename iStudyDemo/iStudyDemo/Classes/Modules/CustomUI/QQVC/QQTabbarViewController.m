//
//  QQTabbarViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/19.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "QQTabbarViewController.h"
#import "UIView+SHCZExt.h"
#import "UIKitMacros.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "QQMainViewController.h"
#import "QQContractViewController.h"
#import "QQDynamicViewController.h"
#import "UIImage+IPLImageKit.h"

@interface QQTabbarViewController ()


@end

@implementation QQTabbarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    
    QQMainViewController *messageViewController = [[QQMainViewController alloc] initWithNibName:nil bundle:nil];
    QQContractViewController *contractViewController = [[QQContractViewController alloc] initWithNibName:nil bundle:nil];
    QQDynamicViewController *dynamicViewController = [[QQDynamicViewController alloc] initWithNibName:nil bundle:nil];
    
    UINavigationController *messageNavController = [[UINavigationController alloc] initWithRootViewController:messageViewController];
    UINavigationController *contractNavController = [[UINavigationController alloc] initWithRootViewController:contractViewController];
    UINavigationController *dynamicNavController = [[UINavigationController alloc] initWithRootViewController:dynamicViewController];
    messageViewController.tabbarVC = self;
    contractViewController.tabbarVC = self;
    dynamicViewController.tabbarVC = self;
    self.viewControllers = [NSArray arrayWithObjects:messageNavController, contractNavController,dynamicNavController, nil];
    
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *tabItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabItem3 = [tabBar.items objectAtIndex:2];
    
    tabItem1.title = @"消息";
    tabItem2.title = @"联系人";
    tabItem3.title = @"动态";
    
    tabItem1.image = [[UIImage imageNamed:@"skin_tab_icon_conversation_normal"] scaleToSize:CGSizeMake(26, 26)];
    tabItem2.image = [[UIImage imageNamed:@"skin_tab_icon_contact_normal"] scaleToSize:CGSizeMake(26, 26)];
    tabItem3.image = [[UIImage imageNamed:@"skin_tab_icon_plugin_normal"] scaleToSize:CGSizeMake(26, 26)];
    
    tabItem1.selectedImage = [[[UIImage imageNamed:@"skin_tab_icon_conversation_selected"] scaleToSize:CGSizeMake(26, 26)]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabItem2.selectedImage = [[[UIImage imageNamed:@"skin_tab_icon_contact_selected"] scaleToSize:CGSizeMake(26, 26)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabItem3.selectedImage = [[[UIImage imageNamed:@"skin_tab_icon_plugin_selected"] scaleToSize:CGSizeMake(26, 26)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //    添加拖拽
//    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanEvent:)];
//    
//    
//    [self.view addGestureRecognizer:pan];
}




//实现拖拽
-(void)didPanEvent:(UIPanGestureRecognizer *)recognizer{
    
    // 1. 获取手指拖拽的时候, 平移的值
    CGPoint translation = [recognizer translationInView:recognizer.view];
    
    // 2. 让当前控件做响应的平移
    recognizer.view.transform = CGAffineTransformTranslate(recognizer.view.transform, translation.x, 0);
    // ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    
    [[[UIApplication sharedApplication].delegate window].subviews objectAtIndex:1].ttx=recognizer.view.ttx/3;
    //    NSLog(@"%f",translation.x/5);
    // ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    // 3. 每次平移手势识别完毕后, 让平移的值不要累加
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
    
    //    NSLog(@"%f",recognizer.view.transform.tx);
    //    NSLog(@"%f",translation.x);
    //    NSLog(@"====================");
    //
    
    //获取最右边范围
    CGAffineTransform  rightScopeTransform=CGAffineTransformTranslate([[UIApplication sharedApplication].delegate window].transform,[UIScreen mainScreen].bounds.size.width*0.75, 0);
    
    //    当移动到右边极限时
    if (recognizer.view.transform.tx>rightScopeTransform.tx) {
        
        //        限制最右边的范围
        recognizer.view.transform=rightScopeTransform;
        //        限制透明view最右边的范围
        [[[UIApplication sharedApplication].delegate window].subviews objectAtIndex:1].ttx=recognizer.view.ttx/3;
        
        //        当移动到左边极限时
    }else if (recognizer.view.transform.tx<0.0){
        
        //        限制最左边的范围
        recognizer.view.transform=CGAffineTransformTranslate([[UIApplication sharedApplication].delegate window].transform,0, 0);
        //    限制透明view最左边的范围
        [[[UIApplication sharedApplication].delegate window].subviews objectAtIndex:1].ttx=recognizer.view.ttx/3;
        
    }
    //    当托拽手势结束时执行
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            if (recognizer.view.x >[UIScreen mainScreen].bounds.size.width*0.5) {
                
                recognizer.view.transform=rightScopeTransform;
//                [[[UIApplication sharedApplication].delegate window] exchangeSubviewAtIndex:1 withSubviewAtIndex:2];
                [[[UIApplication sharedApplication].delegate window].subviews objectAtIndex:1].ttx=recognizer.view.ttx/3;
                
            }else{
                
                recognizer.view.transform = CGAffineTransformIdentity;
                
                [[[UIApplication sharedApplication].delegate window].subviews objectAtIndex:1].ttx=recognizer.view.ttx/3;
            }
        }];
    }
}

@end
