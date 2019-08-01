//
//  MainGLKitViewController.m
//  iDemo
//
//  Created by 张元科 on 2019/7/31.
//  Copyright © 2019 张元科. All rights reserved.
//

#import "MainGLKitViewController.h"

@interface MainGLKitViewController ()
{
    EAGLContext *context;
    GLKBaseEffect *cEffect;
}
@end

@implementation MainGLKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //1.OpenGL ES初始化
    [self setUpConfig];
    
    //2.加载顶点、纹理坐标数据
    [self setUpVertex];
    //3.加载纹理(使用GLKBaseEffect)
    [self setUpTexture];
}

#pragma mark - OpenGL ES setUpConfig

-(void)setUpConfig{
    //1.初始化上下文&设置当前上下文
    /*
     EAGLContext 是苹果iOS平台下实现OpenGLES 渲染层.
     kEAGLRenderingAPIOpenGLES1 = 1, 固定管线
     kEAGLRenderingAPIOpenGLES2 = 2,
     kEAGLRenderingAPIOpenGLES3 = 3,
     */
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!context) {
        NSLog(@"创建 ES context 失败");
    }
    //设置当前上下文
    [EAGLContext setCurrentContext:context];
    
    //2.获取GLKView & 设置context
    GLKView *view = (GLKView *)self.view;
    view.context = context;
    /*3.配置视图创建的渲染缓存区.
     
     (1). drawableColorFormat: 颜色缓存区格式.
     简介:  OpenGL ES 有一个缓存区，它用以存储将在屏幕中显示的颜色。你可以使用其属性来设置缓冲区中的每个像素的颜色格式。
     
     GLKViewDrawableColorFormatRGBA8888 = 0,
     默认.缓存区的每个像素的最小组成部分（RGBA）使用8个bit，（所以每个像素4个字节，4*8个bit）。
     
     GLKViewDrawableColorFormatRGB565,
     如果你的APP允许更小范围的颜色，即可设置这个。会让你的APP消耗更小的资源（内存和处理时间）
     
     (2). drawableDepthFormat: 深度缓存区格式
     
     GLKViewDrawableDepthFormatNone = 0,意味着完全没有深度缓冲区
     GLKViewDrawableDepthFormat16,
     GLKViewDrawableDepthFormat24,
     如果你要使用这个属性（一般用于3D游戏），你应该选择GLKViewDrawableDepthFormat16
     或GLKViewDrawableDepthFormat24。这里的差别是使用GLKViewDrawableDepthFormat16
     将消耗更少的资源
     
     */
    
    //3.配置视图创建的渲染缓存区.
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    //设置背影颜色
    glClearColor(1, 1, 1, 1.0);
    
}


#pragma mark - OpenGL ES setUpVertex

-(void)setUpVertex{
    
    //注意纹理坐标的(0,0)在左下，就是二维的。顶点坐标的(0,0,0）在屏幕中间
    
    //两个三角形，前三个顶点是上面的三角形，后面三个顶点是下面的三角形
    GLfloat vertexData[] = {
        0.5,-0.5,0,     1,0,    //右下
        0.5,0.5,0,      1,1,    //右上
        -0.5,0.5,0,     0,1,    //左上
        
        -0.5,-0.5,0,    0,0,    //左下
        -0.5,0.5,0,     0,1,    //左上
        0.5,-0.5,0 ,    1,0,  //右下
    };
    
    //顶点数组 将低顶点数据放在cpu
    //顶点缓冲区，性能更高的做法是，提前分配一块显存，将顶点数据预先传入到显存当中。这部分的显存，就被称为顶点缓冲区
    //2.开辟顶点缓冲区
    GLuint bufferID;
    glGenBuffers(1, &bufferID);
    glBindBuffer(GL_ARRAY_BUFFER, bufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);
    
    //打开通道
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 0);
    
    //纹理坐标数据
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) *5, (GLfloat *)NULL + 3);
    
    
}

#pragma makr - OpenGL ES setUpTexture
-(void)setUpTexture{
    //1.获取纹理图片路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"jpg"];
    //2.设置纹理参数
    //纹理原点是左下角，但是图片原点应该是做上角
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@(1),GLKTextureLoaderOriginBottomLeft, nil];
    
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    
    //3.使用苹果GLKit 提供的GLKBaseEffect完成着色器工作（顶点、片元）
    cEffect = [[GLKBaseEffect alloc] init];
    cEffect.texture2d0.enabled = GL_TRUE;
    cEffect.texture2d0.name = textureInfo.name;
}

/**
 绘制视图内容
 GLKView对象使 OpenGL ES 上下文称为当前的上下文，并将其framebuffer绑定OpenGL ES呈现命令的目标，然后委托方法绘制视图的内容
 */
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    //1.
    glClear(GL_COLOR_BUFFER_BIT);
    
    //2.准备绘制
    [cEffect prepareToDraw];
    
    //3.开始绘制
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

//GLView自带的方法
-(void)update{
    NSLog(@"dasdfa");
}

@end
