//
//  DPUMLViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/5/7.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "DPUMLViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"

@interface DPUMLViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation DPUMLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self.view setNeedsUpdateConstraints];
}

- (void)setupUI
{
    self.imageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"UMLFigure"];
        [self.view addSubview:imageView];
        imageView;
    });
}

#pragma mark - masonry

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.bottom.equalTo(self.view);
    }];
}
@end
