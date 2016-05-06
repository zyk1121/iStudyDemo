//
//  WeixinView.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/5/7.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "WeixinView.h"

@implementation WeixinView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
       
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    /*
    [[UIColor whiteColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,0,0);
    CGContextAddLineToPoint(context, 100, 100);
    //根据锚点位置 绘制三角
    CGContextClosePath(context);
    [[UIColor whiteColor] setFill];
    [[UIColor whiteColor] setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
     */
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    [self DrawGradientColor:context rect:CGRectMake(0, 0, 100, 1) point:CGPointMake(0, 0) point:CGPointMake(100,0) options:kCGGradientDrawsBeforeStartLocation startColor:[UIColor colorWithWhite:1 alpha:1] endColor:[UIColor colorWithWhite:0 alpha:1]];
    
    // 绘制颜色渐变
    // 创建色彩空间对象
//    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
//    // 创建起点颜色
//    CGColorRef beginColor = CGColorCreate(colorSpaceRef, (CGFloat[]){1, 1, 1, 1});
//    // 创建终点颜色
//    CGColorRef endColor = CGColorCreate(colorSpaceRef, (CGFloat[]){0, 0, 0, 0});
//    // 创建颜色数组
//    CFArrayRef colorArray = CFArrayCreate(kCFAllocatorDefault, (const void*[]){beginColor, endColor}, 2, nil);
//    // 创建渐变对象
//    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef, colorArray, (CGFloat[]){
//        0.0f,	   // 对应起点颜色位置
//        1.0f		// 对应终点颜色位置
//    });
//    // 释放颜色数组
//    CFRelease(colorArray);
//    // 释放起点和终点颜色
//    CGColorRelease(beginColor);
//    CGColorRelease(endColor);
//    // 释放色彩空间
//    CGColorSpaceRelease(colorSpaceRef);
//    CGContextDrawLinearGradient(context, gradientRef, CGPointMake(0, 0), CGPointMake(100, 100), 0);
//    // 释放渐变对象
//    CGGradientRelease(gradientRef);
}


/**
 
 画图形渐进色方法，此方法只支持双色值渐变
 @param context     图形上下文的CGContextRef
 @param clipRect    需要画颜色的rect
 @param startPoint  画颜色的起始点坐标
 @param endPoint    画颜色的结束点坐标
 @param options     CGGradientDrawingOptions
 @param startColor  开始的颜色值
 @param endColor    结束的颜色值
 */
- (void)DrawGradientColor:(CGContextRef)context
                     rect:(CGRect)clipRect
                    point:(CGPoint) startPoint
                    point:(CGPoint) endPoint
                  options:(CGGradientDrawingOptions) options
               startColor:(UIColor*)startColor
                 endColor:(UIColor*)endColor
{
    UIColor* colors [2] = {startColor,endColor};
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colorComponents[8];
    
    for (int i = 0; i < 2; i++) {
        UIColor *color = colors[i];
        CGColorRef temcolorRef = color.CGColor;
        
        const CGFloat *components = CGColorGetComponents(temcolorRef);
        for (int j = 0; j < 4; j++) {
            colorComponents[i * 4 + j] = components[j];
        }
    }
    
    CGGradientRef gradient =  CGGradientCreateWithColorComponents(rgb, colorComponents, NULL, 2);
    
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, options);
    CGGradientRelease(gradient);
}

@end
