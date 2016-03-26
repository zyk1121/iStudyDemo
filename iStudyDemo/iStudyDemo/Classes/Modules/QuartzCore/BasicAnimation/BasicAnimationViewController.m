//
//  BasicAnimationViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BasicAnimationViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"

#define kYOffset 64
/*
 CAAnimation可分为四种：
 
 1.CABasicAnimation
 通过设定起始点，终点，时间，动画会沿着你这设定点进行移动。可以看做特殊的CAKeyFrameAnimation
 2.CAKeyframeAnimation
 Keyframe顾名思义就是关键点的frame，你可以通过设定CALayer的始点、中间关键点、终点的frame，时间，动画会沿你设定的轨迹进行移动
 3.CAAnimationGroup
 Group也就是组合的意思，就是把对这个Layer的所有动画都组合起来。PS：一个layer设定了很多动画，他们都会同时执行，如何按顺序执行我到时候再讲。
 4.CATransition
 这个就是苹果帮开发者封装好的一些动画
 */

/*
 CALayer是个与UIView很类似的概念，同样有layer,sublayer...，同样有backgroundColor、frame等相似的属性，我们可以将UIView看做一种特殊的CALayer，只不过UIView可以响应事件而已。一般来说，layer可以有两种用途，二者不互相冲突：一是对view相关属性的设置，包括圆角、阴影、边框等参数，更详细的参数请点击这里；二是实现对view的动画操控。因此对一个view进行core animation动画，本质上是对该view的.layer进行动画操纵。
 */

@implementation BasicAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initScaleLayer];
    [self initGroupLayer];
}

- (void)initScaleLayer
{

    //演员初始化
    CALayer *scaleLayer = [[CALayer alloc] init];
scaleLayer.backgroundColor = [UIColor blueColor].CGColor;
    scaleLayer.frame = CGRectMake(60, 20 + kYOffset, 50, 50);
    scaleLayer.cornerRadius = 10;
    [self.view.layer addSublayer:scaleLayer];
//    [scaleLayer release];
    //设定剧本
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.5];
scaleAnimation.autoreverses = YES;
scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.repeatCount = MAXFLOAT;
    scaleAnimation.duration = 0.8;
    //开演
    [scaleLayer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}



- (void)initGroupLayer
{
//演员初始化
CALayer *groupLayer = [[CALayer alloc] init];
groupLayer.frame = CGRectMake(60, 340+100 + kYOffset, 50, 50);
groupLayer.cornerRadius = 10;
groupLayer.backgroundColor = [[UIColor purpleColor] CGColor];
[self.view.layer addSublayer:groupLayer];
//设定剧本
CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
scaleAnimation.toValue = [NSNumber numberWithFloat:1.5];
scaleAnimation.autoreverses = YES;
scaleAnimation.repeatCount = MAXFLOAT;
scaleAnimation.duration = 0.8;

CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
moveAnimation.fromValue = [NSValue valueWithCGPoint:groupLayer.position];
moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(320 - 80,groupLayer.position.y)];
moveAnimation.autoreverses = YES;
moveAnimation.repeatCount = MAXFLOAT;
moveAnimation.duration = 2;

CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
rotateAnimation.toValue = [NSNumber numberWithFloat:6.0 * M_PI];
rotateAnimation.autoreverses = YES;
rotateAnimation.repeatCount = MAXFLOAT;
rotateAnimation.duration = 2;

CAAnimationGroup *groupAnnimation = [CAAnimationGroup animation];
groupAnnimation.duration = 2;
groupAnnimation.autoreverses = YES;
groupAnnimation.animations = @[moveAnimation, scaleAnimation, rotateAnimation];
groupAnnimation.repeatCount = MAXFLOAT;
//开演
[groupLayer addAnimation:groupAnnimation forKey:@"groupAnnimation"];
}

@end
