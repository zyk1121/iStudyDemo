//
//  WeiChatViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/21.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "WeiChatViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "WeixinView.h"

@implementation WeiChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
 
    
    //创建CGContextRef
    UIGraphicsBeginImageContext(self.view.bounds.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    
    //绘制Path
    CGRect rect = CGRectInset(self.view.bounds, 64, 64);
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetHeight(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetHeight(rect) * 2 / 3);
    CGPathCloseSubpath(path);
    
    //绘制渐变
    [self drawLinearGradient:gc path:path startColor:[UIColor greenColor].CGColor endColor:[UIColor redColor].CGColor];
    
    //注意释放CGMutablePathRef
    CGPathRelease(path);
    
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [self.view addSubview:imgView];
    
    
    
    
    /* 绘制线*/
    
    /*
     
    //创建CGContextRef
    UIGraphicsBeginImageContext(self.view.bounds.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    
    //绘制Path
    CGRect rect = CGRectInset(self.view.bounds, 64, 64);
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect)+200);
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect)+1, CGRectGetMinY(rect)+200);
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect)+1, CGRectGetMinY(rect));
    CGPathCloseSubpath(path);
    
    //绘制渐变
    [self drawLinearGradient:gc path:path startColor:[UIColor greenColor].CGColor endColor:[UIColor redColor].CGColor];
    
    //注意释放CGMutablePathRef
    CGPathRelease(path);
    
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [self.view addSubview:imgView];
     */
}


- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}
//
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskAllButUpsideDown;
//}
//
//-(BOOL)shouldAutorotate
//{
//    return YES;
//}


// http://www.2cto.com/kf/201603/491900.html
// 上面的链接有一些不错的学习的东西，有空可以看看

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // device  orientation不支持的不会进入该方法
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            NSLog(@"现在是竖屏");
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            NSLog(@"现在是倒立竖屏");
            break;
        case UIInterfaceOrientationLandscapeLeft:
            NSLog(@"现在是横屏向左");
            break;
        case UIInterfaceOrientationLandscapeRight:
            NSLog(@"现在是横屏向右");
            break;
            
        default:
            break;
    }
//    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
//        NSLog(@"现在是竖屏");
////        [btn setFrame:CGRectMake(213, 442, 340, 46)];
//    }
//    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
//        NSLog(@"现在是横屏");
////        [btn setFrame:CGRectMake(280, 322, 460, 35)];
//    }
}



// [[UIApplicationsharedApplication]setIdleTimerDisabled:YES];


/*
 
 屏幕旋转在ios6.0之前都是由这个方法来控制的- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation，所带参数是个枚举类型，有
 typedef NS_ENUM(NSInteger, UIInterfaceOrientation) {
 左边这部分是应用程序的旋转，可以赋值控制，等号右边这部分是设备旋转，只可读，不能赋值控制
 UIInterfaceOrientationPortrait           = UIDeviceOrientationPortrait,//Home键在最下方
 UIInterfaceOrientationPortraitUpsideDown = UIDeviceOrientationPortraitUpsideDown,//Home键在最上方,颠倒过来
 UIInterfaceOrientationLandscapeLeft//状态栏向左 = UIDeviceOrientationLandscapeRight,//Home键在最左方
 UIInterfaceOrientationLandscapeRight     = UIDeviceOrientationLandscapeLeft//Home键在最右方
 };
 
 ios6.0，苹果提高了两个新的API，上面这个方法摒弃了，由
 // New Autorotation support.
 - (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0);
 - (NSUInteger)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0);
 来控制旋转，并且需要在info.plist文件里面进行设置需要控制的方向。
 它不在像以前那样在每个控制器里面进行设置，控制旋转，而是在根视图里进行控制，一般情况，根视图包括导航控制器或者是分栏控制器，所以这里得分两种情况了，如果没有nav或者tab管理作为根视图，那么就在当前控制器里进行管理，如果有nav或者tab作为根控制器，那么就得注意了。
 
 
 
 *******************
 
 
 如果根视图是nav导航控制器的话，那么一般需要新建一个UINavgationCtorller子类或者给导航控制器添加一个类目，在里面实现以上两个方法。但是有种情况啊，如果在你导航控制器里面，随着压栈深入，可能里面的视图控制器有的需要改变屏幕旋转方向的，这样的话你就得在每个控制器里进行单独控制了，你可以重写以上两个方法分别进行控制，在类目或者nav的子控制器你可以这样做
 -(BOOL)shouldAutorotate
 {
 //    return [[self.viewControllers lastObject] shouldAutorotate];
 return self.topViewController.shouldAutorotate;
 }
 
 -(NSUInteger)supportedInterfaceOrientations
 {
 //return [[self.viewControllers lastObject] supportedInterfaceOrientations];
 //    return self.topViewController.supportedInterfaceOrientations;
 if([[self topViewController] isKindOfClass:[QFSignC class]])
 return UIInterfaceOrientationMaskLandscapeRight;
 else
 return UIInterfaceOrientationMaskPortrait;
 
 }调用self.topViewCtorller，得到当前的视图控制器，然后在视图控制器里分别重写以上两个方法进行设置。
 
 */



@end
