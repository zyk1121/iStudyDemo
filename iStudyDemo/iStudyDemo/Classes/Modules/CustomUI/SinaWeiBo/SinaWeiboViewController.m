//
//  SinaWeiboViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/20.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "SinaWeiboViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "WeiboMainViewController.h"

@implementation SinaWeiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 2 - 100, SCREEN_WIDTH, 50)];
    [button setTitle:@"开启新浪微博" forState:UIControlStateNormal];
    [button setTitle:@"开启新浪微博" forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 2 , SCREEN_WIDTH, 50)];
    [button2 setTitle:@"新浪微博新特性" forState:UIControlStateNormal];
    [button2 setTitle:@"新浪微博新特性" forState:UIControlStateHighlighted];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    
    [button2 addTarget:self action:@selector(button2Clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}

- (void)buttonClicked
{
//    [self.navigationController pushViewController:[[WeiboMainViewController alloc] init] animated:YES];
    [self presentViewController:[[WeiboMainViewController alloc] init] animated:YES completion:^{
        
    }];
}

- (void)button2Clicked
{
    // 新特性 入口
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新特性" message:@"参看app delegate" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

@end
