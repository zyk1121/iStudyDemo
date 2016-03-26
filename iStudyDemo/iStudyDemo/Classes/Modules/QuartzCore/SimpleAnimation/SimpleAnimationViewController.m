//
//  SimpleAnimationViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "SimpleAnimationViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"

// http://www.cnblogs.com/wendingding/p/3751519.html
/*
 
 iOS开发UI篇—iOS开发中三种简单的动画设置
 
 【在ios开发中，动画是廉价的】
 
 一、首尾式动画
 
 代码示例：
 
 复制代码
 // beginAnimations表示此后的代码要“参与到”动画中
 
 [UIView beginAnimations:nil context:nil];
 //设置动画时长
 [UIView setAnimationDuration:2.0];
 
 self.headImageView.bounds = rect;
 
 // commitAnimations,将beginAnimation之后的所有动画提交并生成动画
 [UIView commitAnimations];
 复制代码
 说明：如果只是修改控件的属性，使用首尾式动画还是比较方便的，但是如果需要在动画完成后做后续处理，就不是那么方便了
 
 二、block代码块动画
 
 代码示例：
 
 //简单的动画效果
 [UIView animateWithDuration:2.0 animations:^{
 showlab.alpha=0;
 } completion:^(BOOL finished) {
 [showlab removeFromSuperview];
 }];
 说明：
 
 （1）在实际的开发中更常用的时block代码块来处理动画操作。
 
 （2）块动画相对来说比较灵活，尤为重要的是能够将动画相关的代码编写在一起，便于代码的阅读和理解.
 
 三、序列帧动画（以一个简单的TOM猫动画示例）
 
 
 NSMutableArray  *arrayM=[NSMutableArray array];
 for (int i=0; i<40; i++) {
 [arrayM addObject:[UIImage imageNamed:[NSString stringWithFormat:@"eat_%02d.jpg",i]]];
 }
 //设置动画数组
 [self.tom setAnimationImages:arrayM];
 //设置动画播放次数
 [self.tom setAnimationRepeatCount:1];
 //设置动画播放时间
 [self.tom setAnimationDuration:40*0.075];
 //开始动画
 [self.tom startAnimating];
 
 */



/*
 #pragma mark 移动动画
 -(void)translatonAnimation:(CGPoint)location{
 //1.创建动画并指定动画属性
 CABasicAnimation *basicAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
 
 //2.设置动画属性初始值和结束值
 //    basicAnimation.fromValue=[NSNumber numberWithInteger:50];//可以不设置，默认为图层初始状态
 basicAnimation.toValue=[NSValue valueWithCGPoint:location];
 
 //设置其他动画属性
 basicAnimation.duration=5.0;//动画时间5秒
 //basicAnimation.repeatCount=HUGE_VALF;//设置重复次数,HUGE_VALF可看做无穷大，起到循环动画的效果
 //    basicAnimation.removedOnCompletion=NO;//运行一次是否移除动画
 
 
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
 
 */
// UIView的，翻转、旋转，偏移，翻页，缩放，取反的动画效果
@interface SimpleAnimationViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIButton *button4;
@property (nonatomic, strong) UIButton *button5;
@property (nonatomic, strong) UIButton *button6;

@end

@implementation SimpleAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupData];
    [self setupUI];
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - masonry

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    [self.button3 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imageView.mas_top).offset(-60);
        make.centerX.equalTo(self.view);
    }];
    [self.button2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.button3.mas_top).offset(-10);
        make.centerX.equalTo(self.view);
    }];
    [self.button1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.button2.mas_top).offset(-10);
        make.centerX.equalTo(self.view);
    }];
    
    [self.button4 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(60);
        make.centerX.equalTo(self.view);
    }];
    [self.button5 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.button4.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    [self.button6 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.button5.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
}

#pragma mark - private method

- (void)setupData
{
    
}

- (void)setupUI
{
    // initwithframe 都可以去掉
    _imageView = ({
        UIImage *image = [UIImage imageNamed:@"10000004.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT / 2, image.size.width, image.size.height)];
        imageView.image = image;
        imageView;
    });
    [self.view addSubview:_imageView];
    
    _button1 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, 60, 40)];
        button.tag = 1;
        [button setTitle:@"翻转" forState:UIControlStateNormal];
        [button setTitle:@"翻转" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    _button2 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(60, 64, 60, 40)];
        button.tag = 2;
        [button setTitle:@"旋转" forState:UIControlStateNormal];
        [button setTitle:@"旋转" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    _button3 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(120, 64, 60, 40)];
        button.tag = 3;
        [button setTitle:@"偏移" forState:UIControlStateNormal];
        [button setTitle:@"偏移" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    _button4 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(180, 64, 60, 40)];
        button.tag = 4;
        [button setTitle:@"翻页" forState:UIControlStateNormal];
        [button setTitle:@"翻页" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    _button5 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(240, 64, 60, 40)];
        button.tag = 5;
        [button setTitle:@"缩放" forState:UIControlStateNormal];
        [button setTitle:@"缩放" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    _button6 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(300, 64, 60, 40)];
        button.tag = 6;
        [button setTitle:@"取反" forState:UIControlStateNormal];
        [button setTitle:@"取反" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });

}

//
#pragma mark - event

- (void)buttonClick:(UIButton *)button
{
    switch (button.tag) {
        case 1:
            // 翻转
            [self fanzhuan];
            break;
        case 2:
            // 旋转
            [self xuanzhuan];
            break;
        case 3:
            // 偏移
            [self pianyi];
            break;
        case 4:
            // 翻页
            [self fanye];
            break;
        case 5:
            // 缩放
            [self suofang];
            break;
        case 6:
            // 取反
            [self qufan];
            break;
            
        default:
            break;
    }
}

#pragma mark - private method

/*
masonry 动画
 
 [view.superview layoutIfNeeded];
 而已
 
 [view mas_makeConstraints:^(MASConstraintMaker *make) {
 
 make.top.mas_equalTo(400);
 
 make.left.mas_equalTo(100);
 
 make.size.mas_equalTo(CGSizeMake(100, 100));
 
 }];
 
 [view.superview layoutIfNeeded];//如果其约束还没有生成的时候需要动画的话，就请先强制刷新后才写动画，否则所有没生成的约束会直接跑动画
 
 [UIView animateWithDuration:3 animations:^{
 
 [view mas_updateConstraints:^(MASConstraintMaker *make) {
 
 make.left.mas_equalTo(200);
 
 }];
 
 [view.superview layoutIfNeeded];//强制绘制
 
 }];
 */

- (void)fanzhuan
{
    [UIView beginAnimations:@"doflip" context:nil];
    // 设置时常
    [UIView setAnimationDuration:1];// 时常
    // 设置动画淡入浅出
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    // 设置代理
    [UIView setAnimationDelegate:self];
    // 设置翻转方向
    [UIView setAnimationTransition:(UIViewAnimationTransition)UIViewAnimationTransitionFlipFromLeft forView:self.imageView cache:YES];
    // 执行
    [UIView commitAnimations];
    // 更简单的是直接使用UIView
//    [UIView animateWithDuration:1.0 animations:^{
//        self.imageView.alpha = 0;
//    }];
}
- (void)xuanzhuan
{
    CGAffineTransform transform;
    transform = CGAffineTransformRotate(self.imageView.transform, 3.14/4);
    //动画开始
    [UIView beginAnimations:@"rotate" context:nil ];
    //动画时常
    [UIView setAnimationDuration:1];
    //添加代理
    [UIView setAnimationDelegate:self];
    //获取transform的值
    [self.imageView setTransform:transform];
    //关闭动画
    [UIView commitAnimations];
    
   
}
- (void)pianyi
{
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:2];
    [UIView setAnimationDelegate:self];
    //改变它的frame的x,y的值
    self.imageView.frame=CGRectMake(100,100, 120,100);
    [UIView commitAnimations];
}
- (void)fanye
{
    [UIView beginAnimations:@"curlUp" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];//指定动画曲线类型，该枚举是默认的，线性的是匀速的
    //设置动画时常
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelegate:self];
    //设置翻页的方向
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.imageView cache:YES];
    //关闭动画
    [UIView commitAnimations];
}
- (void)suofang
{
    CGAffineTransform  transform;
    transform = CGAffineTransformScale(self.imageView.transform,1.2,1.2);
    [UIView beginAnimations:@"scale" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelegate:self];
    [self.imageView setTransform:transform];
    [UIView commitAnimations];
}
- (void)qufan
{
//    CGAffineTransform transform;
//    transform=CGAffineTransformInvert(self.imageView.transform);
//    
//    [UIView beginAnimations:@"Invert" context:nil];
//    [UIView setAnimationDuration:1];//动画时常
//    [UIView setAnimationDelegate:self];
//    [self.imageView setTransform:transform];//获取改变后的view的transform
//    [UIView commitAnimations];//关闭动画
    
    [self buttonClickTest];
}

/*
 二、block动画
 
 1.简单说明
 
 + (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
 
 参数解析:
 
 duration：动画的持续时间
 
 delay：动画延迟delay秒后开始
 
 options：动画的节奏控制
 
 animations：将改变视图属性的代码放在这个block中
 
 completion：动画结束后，会自动调用这个block
 
 转场动画
 
 + (void)transitionWithView:(UIView *)view duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
 
 参数解析:
 
 duration：动画的持续时间
 
 view：需要进行转场动画的视图
 
 options：转场动画的类型
 
 animations：将改变视图属性的代码放在这个block中
 
 completion：动画结束后，会自动调用这个block
 
 
 
 + (void)transitionFromView:(UIView *)fromView toView:(UIView *)toView duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion
 
 方法调用完毕后，相当于执行了下面两句代码：
 
 // 添加toView到父视图
 
 [fromView.superview addSubview:toView];
 
 // 把fromView从父视图中移除
 
 [fromView.superview removeFromSuperview];
 
 参数解析:
 
 duration：动画的持续时间
 
 options：转场动画的类型
 
 animations：将改变视图属性的代码放在这个block中
 
 completion：动画结束后，会自动调用这个block
 */

// 核心动画

/*
 21 -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
 22 {
 23    //1.创建核心动画
 24     CABasicAnimation *anima=[CABasicAnimation animation];
 25     //平移
 26     anima.keyPath=@"position";
 27     //设置执行的动画
 28     anima.toValue=[NSValue valueWithCGPoint:CGPointMake(200, 300)];
 29
 30     //设置执行动画的时间
 31     anima.duration=2.0;
 32     //设置动画执行完毕之后不删除动画
 33     anima.removedOnCompletion=NO;
 34     //设置保存动画的最新状态
 35     anima.fillMode=kCAFillModeForwards;
 36 //    anima.fillMode=kCAFillModeBackwards;
 37
 38     //设置动画的代理
 39     anima.delegate=self;
 40
 41     //2.添加核心动画
 42     [self.customView.layer addAnimation:anima forKey:nil];
 43 }
 44
 45 -(void)animationDidStart:(CAAnimation *)anim
 46 {
 47     //打印动画块的位置
 48 //    NSLog(@"动画开始执行前的位置：%@",NSStringFromCGPoint(self.customView.center));
 49     NSLog(@"动画开始执行前的位置：%@",NSStringFromCGPoint( self.customView.layer.position));
 50 }
 51 -(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
 52 {
 53     //打印动画块的位置
 54     NSLog(@"动画执行完毕后的位置：%@",NSStringFromCGPoint( self.customView.layer.position));
 55 }
 */


- (void)test
{
    CATransition* transition = [CATransition animation];
    //只执行0.5-0.6之间的动画部分
    //    transition.startProgress = 0.5;
    //    transition.endProgress = 0.6;
    //动画持续时间
    transition.duration = 2.0;
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

- (void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"animationDidStart");
}
//动画结束调用此函数
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"animationDidStop");
    CATransition* transition = [CATransition animation];
    transition.duration = 2.0;
    transition.timingFunction = UIViewAnimationCurveEaseInOut;
    transition.type = @"pageUnCurl";
    transition.subtype = kCATransitionFromBottom;
    [self.view.layer addAnimation:transition forKey:nil];
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
}









- (void)buttonClickTest{
    
    [UIView beginAnimations:nil context:nil];
    //持续时间
    [UIView setAnimationDuration:4.0];
    //在出动画的时候减缓速度
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    //添加动画开始及结束的代理
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(begin)];
    [UIView setAnimationDidStopSelector:@selector(stopAni)];
    //动画效果
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    [UIView commitAnimations];
}

- (void)begin{
    NSLog(@"begin");
}

- (void)stopAni{
    NSLog(@"stop");
}
@end
