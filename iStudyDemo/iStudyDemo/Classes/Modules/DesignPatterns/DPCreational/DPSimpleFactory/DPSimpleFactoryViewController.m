//
//  DPSimpleFactoryViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/5/4.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "DPSimpleFactoryViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "LEDWebViewController.h"

@interface DPSimpleFactoryViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation DPSimpleFactoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self setupData];
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - masonry

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - private method

- (void)setupUI
{
    
    _textView = [[UITextView alloc] init];
    _textView.editable = NO;
    _textView.userInteractionEnabled = NO;
    _textView.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_textView];
    
}

- (void)setupData
{
    self.textView.text =
    @"\
简单工厂模式描述：\n\
    简单工厂模式是。。。。。\
dddd\
    ";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

@end
