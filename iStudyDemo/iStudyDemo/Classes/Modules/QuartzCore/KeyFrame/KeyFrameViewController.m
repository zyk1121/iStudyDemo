//
//  KeyFrameViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "KeyFrameViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"

// http://www.cnblogs.com/wengzilin/p/4256468.html#3384074
@implementation KeyFrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initRectLayer];
}
/*
 对CAKeyFrameAnimation的使用与CABasicAnimation大同小异，有些属性是共通的，因此小翁建议你先阅读上一篇文章。KeyFrame的意思是关键帧，所谓“关键”就是改变物体运动趋势的帧，在该点处物体将发生运动状态，比如矩形的四个角，抛物线的顶点等。因此，聪明的你应该知道了，在上述例子中共有5个关键帧(图3中的ABCDE)。上个关键帧到当前关键帧之间的路径与当前关键帧相联系，比如AB->B，我们可以对AB进行定义动画定义，而自定义要通过众多CAKeyFrameAnimation的属性达到目的。CAKeyFrameAnimation的使用中有以下主要的属性需要注意，有些属性可能比较绕比较难以理解，我会结合图片进行必要的说明。
 
 （1）values属性
 
 values属性指明整个动画过程中的关键帧点，例如上例中的A-E就是通过values指定的。需要注意的是，起点必须作为values的第一个值。
 
 （2）path属性
 
 作用与values属性一样，同样是用于指定整个动画所经过的路径的。需要注意的是，values与path是互斥的，当values与path同时指定时，path会覆盖values，即values属性将被忽略。例如上述例子等价于代码中values方式的path设置方式为：
 
 （3）keyTimes属性
 
 该属性是一个数组，用以指定每个子路径(AB,BC,CD)的时间。如果你没有显式地对keyTimes进行设置，则系统会默认每条子路径的时间为：ti=duration/(5-1)，即每条子路径的duration相等，都为duration的1\4。当然，我们也可以传个数组让物体快慢结合。例如，你可以传入{0.0, 0.1,0.6,0.7,1.0}，其中首尾必须分别是0和1，因此tAB=0.1-0, tCB=0.6-0.1, tDC=0.7-0.6, tED=1-0.7.....
 
 （4）timeFunctions属性
 
 用过UIKit层动画的同学应该对这个属性不陌生，这个属性用以指定时间函数，类似于运动的加速度，有以下几种类型。上例子的AB段就是用了淡入淡出效果。记住，这是一个数组，你有几个子路径就应该传入几个元素
 
 1 kCAMediaTimingFunctionLinear//线性
 2 kCAMediaTimingFunctionEaseIn//淡入
 3 kCAMediaTimingFunctionEaseOut//淡出
 4 kCAMediaTimingFunctionEaseInEaseOut//淡入淡出
 5 kCAMediaTimingFunctionDefault//默认
 
 
 calculationMode属性
 
 该属性决定了物体在每个子路径下是跳着走还是匀速走，跟timeFunctions属性有点类似
 
 1 const kCAAnimationLinear//线性，默认
 2 const kCAAnimationDiscrete//离散，无中间过程，但keyTimes设置的时间依旧生效，物体跳跃地出现在各个关键帧上
 3 const kCAAnimationPaced//平均，keyTimes跟timeFunctions失效
 4 const kCAAnimationCubic//平均，同上
 5 const kCAAnimationCubicPaced//平均，同上
 
 */
//绕矩形循环跑
- (void)initRectLayer
{
    CALayer *rectLayer = [[CALayer alloc] init];
    rectLayer.frame = CGRectMake(15, 200, 30, 30);
    rectLayer.cornerRadius = 15;
    rectLayer.backgroundColor = [[UIColor blackColor] CGColor];
    [self.view.layer addSublayer:rectLayer];
    CAKeyframeAnimation *rectRunAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    rectRunAnimation.values = @[[NSValue valueWithCGPoint:rectLayer.frame.origin],
                                [NSValue valueWithCGPoint:CGPointMake(320 - 15,
                                                                      rectLayer.frame.origin.y)],
                                [NSValue valueWithCGPoint:CGPointMake(320 - 15,
                                                                      rectLayer.frame.origin.y + 100)],
                                [NSValue valueWithCGPoint:CGPointMake(15, rectLayer.frame.origin.y + 100)],
                                [NSValue valueWithCGPoint:rectLayer.frame.origin]];
    //设定每个关键帧的时长，如果没有显式地设置，则默认每个帧的时间=总duration/(values.count - 1)
    rectRunAnimation.keyTimes = @[[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.6],
                                  [NSNumber numberWithFloat:0.7], [NSNumber numberWithFloat:0.8],
                                  [NSNumber numberWithFloat:1]];
    rectRunAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    rectRunAnimation.repeatCount = 1000;
    rectRunAnimation.autoreverses = YES;
    rectRunAnimation.calculationMode = kCAAnimationLinear;
    rectRunAnimation.duration = 4;
    [rectLayer addAnimation:rectRunAnimation forKey:@"rectRunAnimation"];
}


// 此外，动画的暂停与开始可以通过下面的方式做到：
-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}
-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}


@end
