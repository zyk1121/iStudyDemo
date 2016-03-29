//
//  CustomPhotoViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/29.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "CustomPhotoViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"

@interface CustomPhotoViewController ()

@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CustomPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.button1 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
        [button setTitle:@"打开自定义相机" forState:UIControlStateNormal];
        [button setTitle:@"打开自定义相机" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    self.imageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        imageView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
        [self.view addSubview:imageView];
        imageView;
    });
}

#pragma mark - event

- (void)button1Click:(UIButton *)button
{
    // 打开自定义相机
    
}


@end
