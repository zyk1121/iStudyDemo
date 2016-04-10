//
//  CCModalViewViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/4.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "CCModalViewViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "LEDModalView.h"

@implementation CCModalViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 2, SCREEN_WIDTH, 40)];
    [button setTitle:@"显示ModalView" forState:UIControlStateNormal];
    [button setTitle:@"显示ModalView" forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setBackgroundColor:[UIColor grayColor]];
    [button addTarget:self action:@selector(button1Clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)button1Clicked
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 100, SCREEN_HEIGHT / 2 - 100, 200, 200)];
    view.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    view.layer.cornerRadius = 10;
    [LEDModalView showWithCustomView:view];
}

@end
