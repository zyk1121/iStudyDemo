//
//  XiMengViewController.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/12.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XiMengViewController : UIViewController

@end

/*
 openGL两种投影方式
 from http://hi.baidu.com/fcqian/blog/item/cc5794ec76807a3f27979131.html
 
 投影变换是一种很关键的图形变换，OpenGL中只提供了两种投影方式，一种是正射投影，另一种是透视投影。不管是调用哪种投影函数，为了避免不必要的变换，其前面必须加上以下两句：
 
 glMAtrixMode(GL_PROJECTION);
 
 glLoadIdentity();
 
 事实上，投影变换的目的就是定义一个视景体，使得视景体外多余的部分裁剪掉，最终图像只是视景体内的有关部分。本节将详细讲述投影变换的概念以及用法。
 
 1 正射投影(Orthographic Projection)
 
 正射投影，又叫平行投影。这种投影的视景体是一个矩形的平行管道，也就是一个长方体，如图所示。正射投影的最大一个特点是无论物体距离相机多远，投影后的物体大小尺寸不变。这种投影通常用在建筑蓝图绘制和计算机辅助设计等方面，这些行业要求投影后的物体尺寸及相互间的角度不变，以便施工或制造时物体比例大小正确。
 
 此种模式下，不需要设定照相机位置、方向以及视点的位置，也就是说不需要gluLookAt函数。
 
 OpenGL正射投影函数共有两个。
 
 一个函数是：
 
 void glOrtho(GLdouble left,GLdouble right,GLdouble bottom,GLdouble top, GLdouble near,GLdouble far)
 
 它创建一个平行视景体。实际上这个函数的操作是创建一个正射投影矩阵，并且用这个矩阵乘以当前矩阵。其中近裁剪平面是一个矩形，矩形左下角点三维空间坐标是(left,bottom,-near)，右上角点是(right,top,-near)；远裁剪平面也是一个矩形，左下角点空间坐标是(left,bottom,-far)，右上角点是(right,top,-far)。所有的near和far值同时为正或同时为负。如果没有其他变换，正射投影的方向平行于Z轴，且视点朝向Z负轴。这意味着物体在视点前面时far和near都为负值，物体在视点后面时far和near都为正值。
 
 
 另一个函数是：
 
 void gluOrtho2D(GLdouble left,GLdouble right,GLdouble bottom,GLdouble top)
 
 它是一个特殊的正射投影函数，主要用于二维图像到二维屏幕上的投影。它的near和far缺省值分别为-1.0和1.0，所有二维物体的Z坐标都为0.0。因此它的裁剪面是一个左下角点为(left,bottom)、右上角点为(right,top)的矩形。
 
 
 2 透视投影(Perspective Projection)
 
 透视投影符合人们心理习惯，即离视点近的物体大，离视点远的物体小，远到极点即为消失，成为灭点。它的视景体类似于一个顶部和底部都被切除掉的棱椎，也就是棱台。这个投影通常用于动画、视觉仿真以及其它许多具有真实性反映的方面。OpenGL透视投影函数也有两个，其中函数glFrustum()。
 
 此种情况下，需要用gluLookAt设定照相机位置、照相机方向(一般设置为(0,1,0))、以及视点位置。
 
 这个函数原型为：
 
 void glFrustum(GLdouble left,GLdouble Right,GLdouble bottom,GLdouble top, GLdouble near,GLdouble far);
 
 它创建一个透视视景体。其操作是创建一个透视投影矩阵，并且用这个矩阵乘以当前矩阵。这个函数的参数只定义近裁剪平面的左下角点和右上角点的三维空间坐标，即(left,bottom,-near)和(right,top,-near)；最后一个参数far是远裁剪平面的Z负值，其左下角点和右上角点空间坐标由函数根据透视投影原理自动生成。near和far表示离视点的远近，它们总为正值。
 
 另一个函数是：
 
 void gluPerspective(GLdouble fovy,GLdouble aspect,GLdouble zNear, GLdouble zFar);
 
 它也创建一个对称透视视景体，但它的参数定义于前面的不同，如图所示。其操作是创建一个对称的透视投影矩阵，并且用这个矩阵乘以当前矩阵。参数fovy定义视野在X-Z平面的角度，范围是[0.0,180.0]；参数aspect是投影平面宽度与高度的比率；参数zNear和Far分别是远近裁剪面到眼睛的距离，它们总为正值。
 */
