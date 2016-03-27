//
//  NSTimerTestViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/27.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "NSTimerTestViewController.h"
#import "UIKitMacros.h"
#import "LDKTimer.h"





@interface NSTimer (EOCBlocksSupport)

+ (NSTimer *)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)())block
                                        repeats:(BOOL)repeats;

@end

@implementation NSTimer (EOCBlocksSupport)

+ (NSTimer *)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)())block
                                        repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(eoc_blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)eoc_blockInvoke:(NSTimer*)timer {
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end


@interface NSTimerTestViewController ()

@property (nonatomic, strong) NSTimer *timer;
//@property (nonatomic, strong) LDKTimer *ldktimer;

@end

@implementation NSTimerTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2, 200, 40)];
    button.tag = 1;
    [button setTitle:@"开始定时" forState:UIControlStateNormal];
    [button setTitle:@"开始定时" forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2 + 50, 200, 40)];
    button2.tag = 2;
    [button2 setTitle:@"关闭定时" forState:UIControlStateNormal];
    [button2 setTitle:@"关闭定时" forState:UIControlStateHighlighted];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button2 addTarget:self action:@selector(button2Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
//    [NSTimer eoc_scheduledTimerWithTimeInterval:1 block:^{
//        NSLog(@"dddd");
//    } repeats:YES];
}

- (NSTimer *)timer
{
    if (_timer == nil) {
        // self 循环引用
//        __weak id weakSelf = self;// 不可行
        /*
         NSTimer 被 Runloop 强引用了，如果要释放就要调用 invalidate 方法。
         但是我想在 DemoViewController 的 dealloc 里调用 invalidate 方法，但是 self 被 NSTimer 强引用了。
         所以我还是要释放 NSTimer 先，然而不调用 invalidate 方法就不能释放它。
         然而你不进入到 dealloc 方法里我又不能调用 invalidate 方法。
         */
//        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerrun) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];

        
        
        _timer = [LDKTimer  scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerrun) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        
        

        
//        __weak id weakSelf = self;
//        _timer = [NSTimer eoc_scheduledTimerWithTimeInterval:1 block:^{
//            
//            id strongSelf = weakSelf;
//            NSLog(@"dddd");
//        } repeats:YES];
    }
    return _timer;
}


- (void)button1Click:(UIButton *)button
{
    [self.timer fire];
}

- (void)button2Click:(UIButton *)button
{
    [self.timer invalidate];
    self.timer = nil;

}


- (void)timerrun
{
    NSLog(@"timer");
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

/*
 二、CADisplayLink
 
 1. 创建方法
 self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
 [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
 
 2. 停止方法
 [self.displayLink invalidate];
 self.displayLink = nil;
 **当把CADisplayLink对象add到runloop中后，selector就能被周期性调用，类似于重复的NSTimer被启动了；执行invalidate操作时，CADisplayLink对象就会从runloop中移除，selector调用也随即停止，类似于NSTimer的invalidate方法。**
 
 3. 特性
 屏幕刷新时调用
 CADisplayLink是一个能让我们以和屏幕刷新率同步的频率将特定的内容画到屏幕上的定时器类。CADisplayLink以特定模式注册到runloop后，每当屏幕显示内容刷新结束的时候，runloop就会向CADisplayLink指定的target发送一次指定的selector消息， CADisplayLink类对应的selector就会被调用一次。所以通常情况下，按照iOS设备屏幕的刷新率60次/秒
 */

//
/*
 使用GCD 方式解决代码
 
 – (void) doSomethingRepeatedly
 {
 // Do it once
 NSLog(@”doing something …”);
 
 // Repeat it in 2.0 seconds
 __weak typeof(self) weakSelf = self;
 double delayInSeconds = 2.0;
 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
 [weakSelf doSomethingRepeatedly];
 });
 }
 */

@end
