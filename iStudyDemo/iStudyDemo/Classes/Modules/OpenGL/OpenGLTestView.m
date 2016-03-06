//
//  OpenGLTestView.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/6.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "OpenGLTestView.h"
//#import "masonry.h"
//#import "ReactiveCocoa/ReactiveCocoa.h"
#import "UIKitMacros.h"
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface OpenGLTestView ()

@property (nonatomic, strong) CAEAGLLayer *eaglLayer;
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, assign) GLuint colorRenderBuffer;

@end

@implementation OpenGLTestView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupLayer];
        [self setupContext];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        [self render];
    }
    
//    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    return self;
}

#pragma mark - masonry

//+ (BOOL)requiresConstraintBasedLayout
//{
//    return YES;
//}
//
//- (void)updateConstraints
//{
//    // 添加布局
//    [super updateConstraints];
//}

#pragma mark - opengl

// 设置layerClass
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

// 设置layer为不透明
- (void)setupLayer
{
    _eaglLayer = (CAEAGLLayer *)self.layer;
    _eaglLayer.opaque = YES;
}

// 创建OpenGL context
- (void)setupContext
{
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Filed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Filed to set current OpenGLES context");
        exit(1);
    }
}

// 创建render buffer
- (void)setupRenderBuffer
{
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

// 创建一个frame buffer(帧缓冲区)
- (void)setupFrameBuffer
{
    GLuint frameBuffer;
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
}

// 清理屏幕
- (void)render
{
    glClearColor(0, 104.0 / 255.0, 55.0 / 255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

@end
