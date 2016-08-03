//
//  XiMengViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/12.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "XiMengViewController.h"
#import "masonry.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "UIKitMacros.h"
#import "XiMengGLView.h"
#import "EAGLView.h"

@interface XiMengViewController () <GLKViewDelegate>
{
    GLfloat *vertexBuffer;
}
@property (nonatomic, strong) XiMengGLView *glView;
@property (nonatomic, strong) EAGLView *glView2;

@end

@implementation XiMengViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self setupUI];
//    [self.view setNeedsUpdateConstraints];
}

#pragma mark - private method

- (void)setupUI
{
    _glView = [[XiMengGLView alloc] initWithFrame:CGRectMake(0, 64 + 10, SCREEN_WIDTH, SCREEN_WIDTH)];
    [self.view addSubview:_glView];

    _glView.delegate = self;
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // 可以在此处绘制
}

@end
