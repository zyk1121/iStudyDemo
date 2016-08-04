//
//  CircleViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/8/4.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "CircleViewController.h"
#import "masonry.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "UIKitMacros.h"
#import "CircleGLView.h"

@interface CircleViewController() <CustomGLViewDelegate>
{
    GLfloat *vertexBuffer;
}

@property (nonatomic, strong) CircleGLView *glView;

@end

@implementation CircleViewController

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
    _glView = [[CircleGLView alloc] initWithFrame:CGRectMake(0, 64 + 10, SCREEN_WIDTH, SCREEN_WIDTH)];
    [self.view addSubview:_glView];
    _glView.customDelegate = self;
//    _glView.delegate = self;
}

#pragma mark - CustomGLViewDelegate

- (void)glkView:(GLKView *)view
{
    /*
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
    glDrawArrays(GL_LINE_LOOP, 0, 5);
    //    glDrawArrays(GL_LINE_LOOP, 0, 5);
    glDisableClientState(GL_VERTEX_ARRAY);
     */
    
    double Pi = 3.1415926;
    double R = 0.5;
    int n = 200;
    
    float *data = malloc(sizeof(float) * n * 2);
    for(int i=0; i<n; ++i)
    {
        data[2*i + 0] = R*cos(2*Pi/n*i);
        data[2*i + 1] = R*sin(2*Pi/n*i);
    }
    
//     glEnable(GL_LINE_STRIP);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glClear(GL_COLOR_BUFFER_BIT);
    glColor4f(1, 0, 0, 1);
    glVertexPointer(2, GL_FLOAT, 0, data);
    glLineWidth(3);
    glDrawArrays(GL_LINE_LOOP, 0, n);
    //    glDrawArrays(GL_LINE_LOOP, 0, 5);
    glDisableClientState(GL_VERTEX_ARRAY);
    
//    glDisable(GL_LINE_STRIP);
    
    free(data);
}

@end
