//
//  TransitionViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "TransitionViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"

@interface TransitionViewController ()
{
    CALayer *_layer;
}

@end

@implementation TransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置背景(注意这个图片其实在根图层)
//    UIImage *backgroundImage=[UIImage imageNamed:@"background.jpg"];
//    self.view.backgroundColor=[UIColor colorWithPatternImage:backgroundImage];
    
    //自定义一个图层
    _layer=[[CALayer alloc]init];
    _layer.bounds=CGRectMake(0, 0, 50, 50);
    _layer.position=CGPointMake(150, 150);
    _layer.contents=(id)[UIImage imageNamed:@"10000004.png"].CGImage;
    [self.view.layer addSublayer:_layer];
}


- (void)viewDidAppear:(BOOL)animated
{
    [self buttonClick];
}



- (void)buttonClick{
    CATransition* transition = [CATransition animation];
    //只执行0.5-0.6之间的动画部分
    //    transition.startProgress = 0.5;
    //    transition.endProgress = 0.6;
    //动画持续时间
    transition.duration = 1.0;
    //进出减缓
    transition.timingFunction = UIViewAnimationCurveEaseInOut;
    //动画效果
    transition.type = @"pageCurl";
    transition.subtype = kCATransitionFromBottom;
    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:nil];
    //view之间的切换
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
}

//动画开始调用此函数

//- (void)animationDidStart:(CAAnimation *)anim{
//    NSLog(@"animationDidStart");
//}
////动画结束调用此函数
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//     NSLog(@"animationDidStop");
//    CATransition* transition = [CATransition animation];
//    transition.duration = 2.0;
//    transition.timingFunction = UIViewAnimationCurveEaseInOut;
//    transition.type = @"pageUnCurl";
//    transition.subtype = kCATransitionFromBottom;
//    [self.view.layer addAnimation:transition forKey:nil];
//    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
//}


/*
CATransition的type属性

1.#define定义的常量
kCATransitionFade   交叉淡化过渡
kCATransitionMoveIn 新视图移到旧视图上面
kCATransitionPush   新视图把旧视图推出去
kCATransitionReveal 将旧视图移开,显示下面的新视图

2.用字符串表示
pageCurl            向上翻一页
pageUnCurl          向下翻一页
rippleEffect        滴水效果
suckEffect          收缩效果，如一块布被抽走
cube                立方体效果
oglFlip             上下翻转效果
*/

- (void)MyCAnimation1 {
    
    CATransition *animation = [CATransition animation];
    //动画时间
    animation.duration = 1.0f;
    //display mode, slow at beginning and end
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //过渡效果
    animation.type = kCATransitionMoveIn;
    //过渡方向
    animation.subtype = kCATransitionFromTop;
    //添加动画
    [self.view.layer addAnimation:animation forKey:nil];
}

- (void)MyCAnimation2 {
    
    CATransition *animation = [CATransition animation];
    //动画时间
    animation.duration = 1.0f;
    //display mode, slow at beginning and end
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //在动画执行完时是否被移除
    animation.removedOnCompletion = NO;
    //过渡效果
    animation.type = @"pageCurl";
    //过渡方向
    animation.subtype = kCATransitionFromRight;
    //暂时不知,感觉与Progress一起用的,如果不加,Progress好像没有效果
    animation.fillMode = kCAFillModeForwards;
    //动画停止(在整体动画的百分比).
    animation.endProgress = 0.7;
    [self.view.layer addAnimation:animation forKey:nil];
}

- (void)MyCAnimation3 {
    
    CATransition *animation = [CATransition animation];
    //动画时间
    animation.duration = 1.0f;
    //display mode, slow at beginning and end
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //过渡效果
    animation.type = @"pageUnCurl";
    //过渡方向
    animation.subtype = kCATransitionFromRight;
    //暂时不知,感觉与Progress一起用的,如果不加,Progress好像没有效果
    animation.fillMode = kCAFillModeBackwards;
    //动画开始(在整体动画的百分比).
    animation.startProgress = 0.3;
    [self.view.layer addAnimation:animation forKey:nil];
}







#pragma mark 移动动画
-(void)translatonAnimation:(CGPoint)location{
    //1.创建动画并指定动画属性
    CABasicAnimation *basicAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
    
    //2.设置动画属性初始值和结束值
    //    basicAnimation.fromValue=[NSNumber numberWithInteger:50];//可以不设置，默认为图层初始状态
    basicAnimation.toValue=[NSValue valueWithCGPoint:location];
    
    //设置其他动画属性
    basicAnimation.duration=1.0;//动画时间5秒
    //basicAnimation.repeatCount=HUGE_VALF;//设置重复次数,HUGE_VALF可看做无穷大，起到循环动画的效果
    //    basicAnimation.removedOnCompletion=NO;//运行一次是否移除动画
    basicAnimation.delegate=self;
    //存储当前位置在动画结束后使用
    [basicAnimation setValue:[NSValue valueWithCGPoint:location] forKey:@"KCBasicAnimationLocation"];
    
    //3.添加动画到图层，注意key相当于给动画进行命名，以后获得该动画时可以使用此名称获取
    [_layer addAnimation:basicAnimation forKey:@"KCBasicAnimation_Translation"];
}

#pragma mark 点击事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=touches.anyObject;
    CGPoint location= [touch locationInView:self.view];
    //创建并开始动画
    [self translatonAnimation:location];
}

#pragma mark - 动画代理方法
#pragma mark 动画开始
-(void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"animation(%@) start.\r_layer.frame=%@",anim,NSStringFromCGRect(_layer.frame));
    NSLog(@"%@",[_layer animationForKey:@"KCBasicAnimation_Translation"]);//通过前面的设置的key获得动画
}

#pragma mark 动画结束
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//    NSLog(@"animation(%@) stop.\r_layer.frame=%@",anim,NSStringFromCGRect(_layer.frame));
//    _layer.position=[[anim valueForKey:@"KCBasicAnimationLocation"] CGPointValue];
    
    NSLog(@"animation(%@) stop.\r_layer.frame=%@",anim,NSStringFromCGRect(_layer.frame));
    //开启事务
    [CATransaction begin];
    //禁用隐式动画
    [CATransaction setDisableActions:YES];
    
    _layer.position=[[anim valueForKey:@"KCBasicAnimationLocation"] CGPointValue];
    
    //提交事务
    [CATransaction commit];
}
/*

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景
    self.view.layer.contents=(id)[UIImage imageNamed:@"bg.png"].CGImage;
    
    //创建图像显示图层
    _layer=[[CALayer alloc]init];
    _layer.bounds=CGRectMake(0, 0, 87, 32);
    _layer.position=CGPointMake(160, 284);
    [self.view.layer addSublayer:_layer];
    
    //由于鱼的图片在循环中会不断创建，而10张鱼的照片相对都很小
    //与其在循环中不断创建UIImage不如直接将10张图片缓存起来
    _images=[NSMutableArray array];
    for (int i=0; i<10; ++i) {
        NSString *imageName=[NSString stringWithFormat:@"fish%i.png",i];
        UIImage *image=[UIImage imageNamed:imageName];
        [_images addObject:image];
    }
    
    
    //定义时钟对象
    CADisplayLink *displayLink=[CADisplayLink displayLinkWithTarget:self selector:@selector(step)];
    //添加时钟对象到主运行循环
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

#pragma mark 每次屏幕刷新就会执行一次此方法(每秒接近60次)
-(void)step{
    //定义一个变量记录执行次数
    static int s=0;
    //每秒执行6次
    if (++s==0) {
        UIImage *image=_images[_index];
        _layer.contents=(id)image.CGImage;//更新图片
        _index=(_index+1)%IMAGE_COUNT;
    }
}
 */

//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [UIView animateKeyframesWithDuration:5.0 delay:0 options: UIViewAnimationOptionCurveLinear| UIViewAnimationOptionCurveLinear animations:^{
//        //第二个关键帧（准确的说第一个关键帧是开始位置）:从0秒开始持续50%的时间，也就是5.0*0.5=2.5秒
//        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
//            _imageView.center=CGPointMake(80.0, 220.0);
//        }];
//        //第三个关键帧，从0.5*5.0秒开始，持续5.0*0.25=1.25秒
//        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.25 animations:^{
//            _imageView.center=CGPointMake(45.0, 300.0);
//        }];
//        //第四个关键帧：从0.75*5.0秒开始，持所需5.0*0.25=1.25秒
//        [UIView addKeyframeWithRelativeStartTime:0.75 relativeDuration:0.25 animations:^{
//            _imageView.center=CGPointMake(55.0, 400.0);
//        }];
//        
//    } completion:^(BOOL finished) {
//        NSLog(@"Animation end.");
//    }];
//}


@end

// 转场动画
/*
 
 转场动画就是从一个场景以动画的形式过渡到另一个场景。转场动画的使用一般分为以下几个步骤：
 
 1.创建转场动画
 
 2.设置转场类型、子类型（可选）及其他属性
 
 3.设置转场后的新视图并添加动画到图层
 
 #import "KCMainViewController.h"
 #define IMAGE_COUNT 5
 
 @interface KCMainViewController (){
 UIImageView *_imageView;
 int _currentIndex;
 }
 
 @end
 
 @implementation KCMainViewController
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 
 //定义图片控件
 _imageView=[[UIImageView alloc]init];
 _imageView.frame=[UIScreen mainScreen].applicationFrame;
 _imageView.contentMode=UIViewContentModeScaleAspectFit;
 _imageView.image=[UIImage imageNamed:@"0.jpg"];//默认图片
 [self.view addSubview:_imageView];
 //添加手势
 UISwipeGestureRecognizer *leftSwipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe:)];
 leftSwipeGesture.direction=UISwipeGestureRecognizerDirectionLeft;
 [self.view addGestureRecognizer:leftSwipeGesture];
 
 UISwipeGestureRecognizer *rightSwipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe:)];
 rightSwipeGesture.direction=UISwipeGestureRecognizerDirectionRight;
 [self.view addGestureRecognizer:rightSwipeGesture];
 }
 
 #pragma mark 向左滑动浏览下一张图片
 -(void)leftSwipe:(UISwipeGestureRecognizer *)gesture{
 [self transitionAnimation:YES];
 }
 
 #pragma mark 向右滑动浏览上一张图片
 -(void)rightSwipe:(UISwipeGestureRecognizer *)gesture{
 [self transitionAnimation:NO];
 }
 
 
 #pragma mark 转场动画
 -(void)transitionAnimation:(BOOL)isNext{
 //1.创建转场动画对象
 CATransition *transition=[[CATransition alloc]init];
 
 //2.设置动画类型,注意对于苹果官方没公开的动画类型只能使用字符串，并没有对应的常量定义
 transition.type=@"cube";
 
 //设置子类型
 if (isNext) {
 transition.subtype=kCATransitionFromRight;
 }else{
 transition.subtype=kCATransitionFromLeft;
 }
 //设置动画时常
 transition.duration=1.0f;
 
 //3.设置转场后的新视图添加转场动画
 _imageView.image=[self getImage:isNext];
 [_imageView.layer addAnimation:transition forKey:@"KCTransitionAnimation"];
 }
 
 #pragma mark 取得当前图片
 -(UIImage *)getImage:(BOOL)isNext{
 if (isNext) {
 _currentIndex=(_currentIndex+1)%IMAGE_COUNT;
 }else{
 _currentIndex=(_currentIndex-1+IMAGE_COUNT)%IMAGE_COUNT;
 }
 NSString *imageName=[NSString stringWithFormat:@"%i.jpg",_currentIndex];
 return [UIImage imageNamed:imageName];
 }
 @end
 
 */
