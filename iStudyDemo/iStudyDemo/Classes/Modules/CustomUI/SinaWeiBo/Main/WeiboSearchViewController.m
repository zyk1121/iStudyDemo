//
//  WeiboSearchViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/22.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "WeiboSearchViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "ZTSearchBar.h"

@implementation WeiboSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];

    self.navigationItem.titleView = [ZTSearchBar searchBar];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
