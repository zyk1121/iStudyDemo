//
//  PYViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/23.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "PYViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "SPKADViewController.h"
#import "SPKBanner.h"

@interface PYViewController ()

@property (nonatomic, strong) SPKADViewController *ADViewController;

@end

@implementation PYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /*
     
     
     在 iOS 7 中，如果某个 UIViewController 的 self.view 第一个子视图是 UIScollView， 同时当这个 UIViewController 被 push 或 initWithRootController 成为 UINavigationController控制的Controller时，这个 UIViewController的 view 的子视图 UIScollView 的所有子视图， 都会被下移 64px。
     这个下移 64px 的前提是 navigationBar 和 statusBar 没有隐藏。因为为 statusBar 默认的 Height 是 20px，而 navigatiBar  默认的 Height 是 44px。下面来比较一下
     实例
     
     如结果显示， scrollView 背景色为蓝色的子视图位置自动下移了。 而这个下移的距离刚好是 64.0px。
     
     解决方法：
     第一种：在 ViewController 的 init 的方法中增加一行代码：
     
     
     Obj-c代码 收藏代码
     self.automaticallyAdjustsScrollViewInsets = NO;
     
     
     第二种： 让UIScrollView 不要成为 ViewController 的 View 的第一个子视图。
     */
     self.ADViewController = [SPKADViewController new];
     NSMutableArray *bannerArray = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 4; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
        SPKBanner *banner = [[SPKBanner alloc] initWithImageURL:[NSURL URLWithString:@"http://www.sharewithu.com/data/attachment/forum/201309/09/16093864usvmstci04940p.jpg"] linkURL:[NSURL URLWithString:@"http://www.baidu.com"] andImage:nil];
        [bannerArray addObject:banner];
    }
    
     [self.ADViewController setBannerArray:[bannerArray copy]];
//     self.ADViewController.didClickBannerBlock = self.didClickBannerBlock;
    self.ADViewController.didClickBannerBlock = ^(SPKBanner*banner){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:@"message" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    };
     @weakify(self);
     self.ADViewController.bannerImgLoadingFinishedBlock = ^(BOOL haveImage) {
     @strongify(self);
     if (!haveImage) {
     [self.ADViewController.view removeFromSuperview];
     self.ADViewController = nil;
     }
//     [self.view setNeedsUpdateConstraints];
     };
     [self addChildViewController:self.ADViewController];
//    self.ADViewController.view.backgroundColor  =[UIColor redColor];
     [self.view addSubview:self.ADViewController.view];
     [self.ADViewController didMoveToParentViewController:self];
    
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self.ADViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.width.equalTo(self.view);
    }];
}

@end
