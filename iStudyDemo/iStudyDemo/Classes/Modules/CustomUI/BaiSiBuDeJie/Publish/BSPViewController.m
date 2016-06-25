//
//  BSPViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/6/25.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSPViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "PrefixHeader.pch"

@interface BSPViewController ()

@property (nonatomic, strong) UIButton *quitButton;

@end

@implementation BSPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    [self setupUI];
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - masonry

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.quitButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@44);
    }];
}

#pragma mark - private method

- (void)setupUI
{
    _quitButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor greenColor]];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitle:@"取消" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:_quitButton];
}


#pragma mark - event

- (void)buttonClicked
{
//    ZYKLog(@"Debug Log");
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
