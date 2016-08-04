//
//  CircleGLView.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/8/4.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "CircleGLView.h"

#define USE_DEPTH_BUFFER 1
#define DEGREES_TO_RADIANS(__ANGLE) ((__ANGLE) / 180.0 * M_PI)

@interface CircleGLView ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) GLuint textureID;

@end

@implementation CircleGLView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // init context
        self.backgroundColor = [UIColor clearColor];
        self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        [EAGLContext setCurrentContext:self.context];
        
        [self setupView];
    }
    
    return self;
}

- (void)setupView {
    CGRect rect = self.bounds;
    // 默认投影为正交投影，单位立方体
    glViewport(0, 0, rect.size.width, rect.size.height);
    /*
     
     gluLookAt()共有九个参数，分别是眼睛的位置，眼睛朝向的位置，以及相机朝向的方向。
     该函数定义了视点矩阵，并用该矩阵乘以当前矩阵。eyex、eyey、eyez定义了视点的位置；centerx、centery和centerz变量指定了参考点的位置，该点通常为相机所瞄准的场景中心轴线上的点；upx、upy、upz变量指定了向上向量的方向。（注意，这是一个向量，不是一个坐标）
     
     */
    gluLookAt(0,0,0,0,-1,-1,0,1,0);// 在默认情况下，照相机位于原点，指向z轴的负方向，朝上向量为(0,1,0)。
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
}


#pragma mark - opengl

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
    _displayLink.frameInterval = 5;
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes]; // 支持滑动刷新
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)render:(CADisplayLink *)displayLink
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);// 清空屏幕
    glClearColor(0, 0, 0, 1);
    
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(glkView:)]) {
        [self.customDelegate glkView:self];
    }
 
    [self display];
//    glFlush();
}

/* 判断一个整数是否为2的次方幂 */
-(BOOL)isValidWidthForTextureWithWidth:(int)value
{
    BOOL flag = NO;
    if((value > 0) && (value & (value - 1)) == 0) {
        flag = YES;
    }
    return flag;
}

- (GLuint)getTextureIDFromImage:(UIImage *)image
{
    if (!image) {
        return 0;
    }
    
    size_t width = image.size.width;
    size_t height = image.size.height;
    if (![self isValidWidthForTextureWithWidth:width] || ![self isValidWidthForTextureWithWidth:height]) {
        return 0;
    }
    
    unsigned char *data = [self convertUIImageToBitmapRGBA8:image];
    if (data == NULL) {
        return 0;
    }
    
    GLuint textureId = 0;
    
    glGenTextures(1, &textureId);
    
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, textureId);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width,  (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
    free(data);
    
    glBindTexture(GL_TEXTURE_2D, 0);
    glDisable(GL_TEXTURE_2D);
    
    return textureId;
}


#pragma mark - private method

- (unsigned char *)convertUIImageToBitmapRGBA8:(UIImage *)image {
    
    // is image texture
    CGImageRef cgimage = image.CGImage;
    if(!cgimage)
        return nil;
    
    CGSize textureSize = CGSizeMake((int)CGImageGetWidth(cgimage), (int)CGImageGetHeight(cgimage));
    
    int size = textureSize.width * textureSize.height * 4;
    unsigned char *textureBuffer = (unsigned char *)malloc(size);
    // Use  the bitmatp creation function provided by the Core Graphics framework.
    CGContextRef brushContext = CGBitmapContextCreate(textureBuffer, textureSize.width, textureSize.height, 8, textureSize.width * 4, CGImageGetColorSpace(cgimage), kCGImageAlphaPremultipliedLast);
    for(int i = 0; i < size; i+=4) {
        textureBuffer[i+0] = 0xFF;
        textureBuffer[i+1] = 0xFF;
        textureBuffer[i+2] = 0xFF;
        textureBuffer[i+3] = 0x00;
    }
    
    CGContextTranslateCTM(brushContext, 0.0, CGImageGetHeight(cgimage));
    CGContextScaleCTM(brushContext, 1.0f, -1.0f);
    // After you create the context, you can draw the  image to the context.
    CGContextDrawImage(brushContext, CGRectMake(0.0, 0.0, (CGFloat)textureSize.width, (CGFloat)textureSize.height), cgimage);
    // You don't need the context at this point, so you need to release it to avoid memory leaks.
    CGContextRelease(brushContext);
    
    return textureBuffer;
}


- (GLuint)getTextureIDFromFilePath:(NSString *)filePath
{
    UIImage *image = [UIImage imageNamed:filePath];
    if (!image) {
        return 0;
    }
    
    size_t width = image.size.width;
    size_t height = image.size.height;
    
    unsigned char *data = [self convertUIImageToBitmapRGBA8:image];
    if (data == NULL) {
        return 0;
    }
    
    GLuint textureId = 0;
    
    glGenTextures(1, &textureId);
    
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, textureId);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width,  (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
    free(data);
    
    glBindTexture(GL_TEXTURE_2D, 0);
    glDisable(GL_TEXTURE_2D);
    
    return textureId;
}


// 纹理

- (void)textureTest
{
    static float rota = 0;
    
    
    GLfloat trangleVerts[] = {
        -0.5, 0.5, 0,
        -0.5, -0.5, 0,
        0.5, -0.5, 0,
        0.5, 0.5, 0
    };
    
    const GLshort squareTextureCoords[] = {
        0, 1,       // top left
        0, 0,       // bottom left
        1, 0,       // bottom right
        1, 1        // top right
    };
    
    if (_textureID ==0) {
        UIImage *image = [UIImage imageNamed:@"bamboo.png"];
        _textureID = [self getTextureIDFromImage:image];
    }
    
    glColor4f(1.0, 0, 0, 1.0);
    /*
     二、设置颜色
     
     根据需要设置当前颜色。一旦一种颜色被设置为当前颜色，其后所有物体都将用该颜色绘出，直到当前颜色被设置为新的颜色为止。设置颜色的函数是glColor()。
     */
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);// 默认
    //    glClearColor(1.0, 0, 0, 1.0);
    //    glClear(GL_COLOR_BUFFER_BIT);
    //    glFlush();
    
    //    glMatrixMode(GL_MODELVIEW);
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, _textureID);
    
    glLoadIdentity();
    glRotatef(rota, 1.0, 0.0, 0.0);
    //    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, trangleVerts);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glTexCoordPointer(2, GL_SHORT, 0, squareTextureCoords);     // NEW
    // NEW
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);               // NEW
    
    glBindTexture(GL_TEXTURE_2D, 0);
    glDisable(GL_TEXTURE_2D);
    
    
    rota += 1;
    
}

// 颜色
- (void)colorTest
{
    
    glClearColor(0, 0, 0, 1);
    GLfloat trangleVerts[] = {
        -0.5, 0.5, 0,
        -0.5, -0.5, 0,
        0.5, -0.5, 0,
        0.5, 0.5, 0
    };
    const GLfloat squareColours[] = {
        1.0, 0.0, 0.0, 1.0,// Red - top left - colour for squareVertices[0]
        0.0, 1.0, 0.0, 1.0,   // Green - bottom left - squareVertices[1]
        0.0, 0.0, 1.0, 1.0,   // Blue - bottom right - squareVerticies[2]
        0.5, 0.5, 0.5, 1.0    // Grey - top right- squareVerticies[3]
    };
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, trangleVerts);
    
    glEnableClientState(GL_COLOR_ARRAY);
    glColorPointer(4, GL_FLOAT, 0, squareColours);// NEW
    
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
}



// 平移和旋转

/*
 - (void)setupView {
 
 const GLfloat zNear = 0.1, zFar = 1000.0, fieldOfView = 60.0;
 GLfloat size;
 
 glEnable(GL_DEPTH_TEST);
 glMatrixMode(GL_PROJECTION);
 size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0);
 
 // This give us the size of the iPhone display
 CGRect rect = self.bounds;
 glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size / (rect.size.width / rect.size.height), zNear, zFar);
 glViewport(0, 0, rect.size.width, rect.size.height);
 
 glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
 }
 
 
 */
- (void)translateAndRotate
{
    static float rota = 0;
    const GLfloat triangleVertices[] = {
        0.0, 1.0, 0.0,                // Triangle top centre
        -1.0, -1.0, 0.0,              // bottom left
        1.0, -1.0, 0.0                // bottom right
    };
    
    const GLfloat squareVertices[] = {
        -1.0, 1.0, 0.0,               // Top left
        -1.0, -1.0, 0.0,              // Bottom left
        1.0, -1.0, 0.0,               // Bottom right
        1.0, 1.0, 0.0                 // Top right
    };
    
    glViewport(0, 0, self.frame.size.width * 2, self.frame.size.height *2);
    glClearColor(0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glMatrixMode(GL_MODELVIEW);
    
    glVertexPointer(3, GL_FLOAT, 0, triangleVertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    rota += 0.5;
    
    glLoadIdentity();
    glTranslatef(-1.5, 0.0, -6.0);
    glRotatef(rota, 0.0, 0.0, 1.0);
    glVertexPointer(3, GL_FLOAT, 0, triangleVertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    glLoadIdentity();
    glTranslatef(1.5, 0.0, -6.0);
    glRotatef(rota, 0.0, 0.0, 1.0);
    glVertexPointer(3, GL_FLOAT, 0, squareVertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    
    
    
    [self display];
    
}

//  五角星
- (void)fiveStar
{
    glClearColor(0, 0, 0, 1);
    GLfloat a = sqrt(0.2 / (2 - 2 * cos(72.0 * M_PI / 180)));
    GLfloat bx = a * cos(18.0 * M_PI / 180);
    GLfloat by = a * sin(18.0 * M_PI / 180);
    GLfloat cx = a * cos(54.0 * M_PI / 180);
    GLfloat cy = -a * sin(54.0 * M_PI / 180);
    //    GLfloat PointA[2] = { 0, a },
    //    PointB[2] = { bx, by },
    //    PointC[2] = { cx, cy },
    //    PointD[2] = { -cx, cy },
    //    PointE[2] = { -bx, by };
    GLfloat point[] = {0, a, bx, by,cx, cy ,-cx, cy ,-bx, by };
    glEnableClientState(GL_VERTEX_ARRAY);
    glClear(GL_COLOR_BUFFER_BIT);
    glColor4f(1, 0, 0, 1);
    glVertexPointer(2, GL_FLOAT, 0, point);
    glDrawArrays(GL_POINTS, 0, 5);
    //    glDrawArrays(GL_LINE_LOOP, 0, 5);
    glDisableClientState(GL_VERTEX_ARRAY);
}

// 三角形
- (void)trangle
{
    glClearColor(0, 0, 0, 1);
    GLfloat trangleVerts[] = {
        -0.1, 0.1, -0.1,
        -0.1, -0.1, -0.1,
        0.1, -0.1, -0.1,
        0.1, 0.1, -0.1
    };
    glEnableClientState(GL_VERTEX_ARRAY);
    glClear(GL_COLOR_BUFFER_BIT);
    glColor4f(1, 0, 0, 1);
    
    glVertexPointer(3, GL_FLOAT, 0, trangleVerts);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 3);
    glDisableClientState(GL_VERTEX_ARRAY);
}

// 四边形
- (void)render2:(CADisplayLink *)displayLink
{
    // 四边形
    glClearColor(0, 0, 0, 1);
    // 绘制
    GLfloat squareVerts[] = {
        -0.5, 0.5, 0.0,
        -0.5, -0.5, 0.0,
        0.5, -0.5, 0.0,
        0.5, 0.5, 0.0
    };
    
    glEnable(GL_BLEND);
    glDisable(GL_DEPTH_TEST);
    glBlendFunc(GL_SRC_ALPHA, GL_SRC_COLOR);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glClear(GL_COLOR_BUFFER_BIT);
    glColor4f(1, 0, 0, 1);
    
    glVertexPointer(3, GL_FLOAT, 0, squareVerts);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    
    // 绘制end
    [self display];
    /* display 可以使得下面的方法重绘
     #pragma mark - GLKViewDelegate
     
     - (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
     {
     }
     */
}

@end

