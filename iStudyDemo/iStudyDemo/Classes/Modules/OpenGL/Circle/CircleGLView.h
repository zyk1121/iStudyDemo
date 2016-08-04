//
//  CircleGLView.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/8/4.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <GLKit/GLKit.h>
#import <GLKit/GLKView.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "CC3GLMatrix.h"
#import <OpenGLES/EAGL.h>
#import "glues.h"

@protocol CustomGLViewDelegate <NSObject>

@optional
- (void)glkView:(GLKView *)view;

@end

@interface CircleGLView : GLKView

@property (nonatomic, weak) id<CustomGLViewDelegate> customDelegate;

@end
