//
//  BSEViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/6/25.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSEViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"

@implementation BSEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"百思不得姐";
    [self setupUI];
}

- (void)setupUI
{
    // 导航栏右边按钮
    UIBarButtonItem *bardoneBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(bardoneBtnClicked)];
    UIBarButtonItem *barcancelBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(barcancelBtnClicked)];
    NSArray *rightBtns=[NSArray arrayWithObjects:barcancelBtn, nil];
    self.navigationItem.rightBarButtonItems=rightBtns;
    
    
    // 导航栏左边按钮
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBarButton setImage:[UIImage imageNamed:@"MainTagSubIcon"] forState:UIControlStateNormal];
    [leftBarButton setImage:[UIImage imageNamed:@"MainTagSubIconClick"] forState:UIControlStateHighlighted];
    UIImage *image = [leftBarButton imageForState:UIControlStateNormal];
    leftBarButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [leftBarButton sizeToFit];
    [leftBarButton addTarget:self action:@selector(leftBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    
}

#pragma mark - navibar right button clicked
- (void)bardoneBtnClicked
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)barcancelBtnClicked
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)leftBarButtonClicked
{
    
}

@end
