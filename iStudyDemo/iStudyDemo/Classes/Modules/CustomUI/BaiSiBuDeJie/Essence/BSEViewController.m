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
    
    [self setupUI];
}

- (void)setupUI
{
    UIBarButtonItem *bardoneBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(bardoneBtnClicked)];
    UIBarButtonItem *barcancelBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(barcancelBtnClicked)];
    NSArray *rightBtns=[NSArray arrayWithObjects:barcancelBtn, nil];
    self.navigationItem.rightBarButtonItems=rightBtns;
    
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

@end
