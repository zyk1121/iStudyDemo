//
//  QQSettingViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/20.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "QQSettingViewController.h"

@implementation QQSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
        self.view.backgroundColor = [UIColor whiteColor];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor  =[UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
