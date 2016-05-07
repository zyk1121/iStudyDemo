//
//  DPStructuralTestViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/5/5.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "DPStructuralTestViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "LEDWebViewController.h"

@interface DPStructuralTestViewController ()

@property (nonatomic, assign) DPStructuralType type;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation DPStructuralTestViewController

- (instancetype)initWithType:(DPStructuralType)type
{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

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
http://www.runoob.com/design-pattern/design-pattern-tutorial.html\n\n\
http://m.blog.csdn.net/article/details?id=9159589\
    ";
    /*
    // 根据不同的type生成不同的描述
    switch (_type) {
        case DPStructuralTypeDPAdapter:
            self.textView.text =
            @"\
http://www.runoob.com/design-pattern/design-pattern-tutorial.html\
            ";
            break;
            default:
            break;
    }
     */
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 根据不同的type执行不同的入口
}

@end
