//
//  MainGLView.m
//  iDemo
//
//  Created by 张元科 on 2019/7/27.
//  Copyright © 2019年 张元科. All rights reserved.
//

#import "MainGLView.h"
#import "GLTools.h"

@interface MainGLView ()
{
    GLuint  m_renderbuffer;
    GLuint  m_framebuffer;
    int                 m_width;
    int                 m_height;
}
@property (nonatomic, strong) CADisplayLink *displayLink;   // 绘制fps
@property (nonatomic, strong)   EAGLContext       *eaglContext;

@end

@implementation MainGLView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupGL];
    }
    return self;
}

- (void)setupGL
{
    
    _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    [EAGLContext setCurrentContext:_eaglContext];
    
    CAEAGLLayer* eaglLayer = (CAEAGLLayer*)super.layer;
    eaglLayer.opaque = YES;
    
    self.context = self.eaglContext;
    
    // 设置为当前Context
    if (![EAGLContext setCurrentContext:self.context]) {
        return ;
    }
    
    // 创建render buffer 也叫 color buffer
    
    glGenRenderbuffersOES(1, &m_renderbuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, m_renderbuffer);
    
    // step 4, 这一步一定要在step 3之后，否则会失败
    [self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
    
    
    int width;
    int height;
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &width);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &height);
    
    // step 5 创建frame buffer
    glGenFramebuffersOES(1, &m_framebuffer);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, m_framebuffer);
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, m_renderbuffer);
    // 这句可有可无
    GLenum status = glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES);
    if (status != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"err");
    }
    
    ///////
    glViewport(0, 0, width, height);
    
    glMatrixMode(GL_PROJECTION);        // 设置矩阵模式为投影变换矩阵，
    glLoadIdentity();
//    gluPerspective_igl(90, (GLfloat)width / height, 1, 10000);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    m_width = width;
    m_height = height;
    
}


// 设置layerClass
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    _displayLink.frameInterval = 1;
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode]; // 支持滑动刷新
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

// render
- (void)render:(CADisplayLink *)displayLink
{
    if ([displayLink isPaused]) {
        return;
    }
    [self beforeRender];
//    glClearColor(1, 0, 0, 1);
//    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);  //清除surface内容，恢复至初始状态。
}

- (void)beforeRender
{
//    glMatrixMode(GL_PROJECTION);        // 设置矩阵模式为投影变换矩阵，
//    glLoadIdentity();
//    glShadeModel(GL_SMOOTH);
//    glEnable(GL_DEPTH_TEST);            // 所作深度测试的类型
//    glDepthFunc(GL_LEQUAL);
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
//    glAlphaFunc(GL_GREATER ,0.99);//
//    if (m_goForward >= kiglChangePanoDistance - 1) {
//        gluPerspective_igl(m_camera->getFOV(), (GLfloat)m_width / m_height, iglPerspectiveZNear, iglPerspectiveZFar + kiglChangePanoDistance * 2);
//    } else {
//        gluPerspective_igl(m_camera->getFOV(), (GLfloat)m_width / m_height, iglPerspectiveZNear, iglPerspectiveZFar);
//    }
//     gluPerspective_igl(90, (GLfloat)1.0, 0, 1);
    
//    glMatrixMode(GL_MODELVIEW);
//    glLoadIdentity();
    
//     glViewport(0, 0, m_width, m_height);
     glClearColor(1.0f, 0, 0, 1.0);
//    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);    // 清除颜色数据和深度数据（清屏）
    glClear(GL_COLOR_BUFFER_BIT);
//    glClearColor(1, 0, 0, 1);
//    glLoadIdentity();

}


@end
