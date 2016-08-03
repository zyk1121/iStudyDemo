//
//  FiveStarViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/8/3.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "FiveStarViewController.h"
#import "masonry.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "UIKitMacros.h"
#import "FiveStarGLView.h"

@interface FiveStarViewController() <GLKViewDelegate>
{
    GLfloat *vertexBuffer;
}

@property (nonatomic, strong) FiveStarGLView *glView;

@end

@implementation FiveStarViewController

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
    _glView = [[FiveStarGLView alloc] initWithFrame:CGRectMake(0, 64 + 10, SCREEN_WIDTH, SCREEN_WIDTH)];
    [self.view addSubview:_glView];
    
    _glView.delegate = self;
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // 可以在此处绘制,先执行
//    glClearColor(0, 0, 0, 1);
    GLfloat trangleVerts[] = {
        -0.1, 0.1, -0.1,
        -0.1, -0.1, -0.1,
        0.1, -0.1, -0.1,
        0.1, 0.1, -0.1
    };
    glEnableClientState(GL_VERTEX_ARRAY);
//    glClear(GL_COLOR_BUFFER_BIT);
//     glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);// 清空屏幕
    glColor4f(1, 0, 0, 1);
    
    glLoadIdentity();
    
    glVertexPointer(3, GL_FLOAT, 0, trangleVerts);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 3);
    glDisableClientState(GL_VERTEX_ARRAY);
    
//    glClear(GL_COLOR_BUFFER_BIT);
     glColor4f(1, 1, 1, 1);
//    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);// 默认，设置完颜色需要设置回去
}

@end
