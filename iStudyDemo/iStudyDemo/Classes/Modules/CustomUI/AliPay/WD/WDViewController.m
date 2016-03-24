//
//  WDViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/23.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "WDViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "WD2ViewController.h"

@implementation WDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button1 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 40, 40)];
        [button setBackgroundImage:[UIImage imageNamed:@"10000004"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:button1];
}

- (void)buttonClick
{
    WD2ViewController *vc = [[WD2ViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
