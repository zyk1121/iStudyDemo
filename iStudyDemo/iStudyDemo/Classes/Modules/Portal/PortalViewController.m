//
//  PortalViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "PortalViewController.h"

#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "LEDPortal.h"

@implementation PortalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2, 200, 40)];
    button.tag = 1;
    [button setTitle:@"Portal打开VC" forState:UIControlStateNormal];
    [button setTitle:@"Portal打开VC" forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)button1Click:(UIButton *)button
{
    // fromviewcontroller   nil  | self,最好是传入一个值
    [LEDPortal transferFromViewController:nil toURL:[NSURL URLWithString:@"ipuny://portal/launch"] completion:^(UIViewController * _Nullable viewController, NSError * _Nullable error) {
        // 可以对VC做一些后续的操作
        if (viewController && !error) {
            viewController.view.backgroundColor = [UIColor grayColor];
        }
    }];
}
@end
