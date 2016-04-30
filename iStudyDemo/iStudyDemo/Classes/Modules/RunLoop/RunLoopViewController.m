//
//  RunLoopViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "RunLoopViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "LDKTimer.h"
#import "LEDEventHandler.h"
#import "LEDListener.h"

// http://www.cocoachina.com/ios/20150601/11970.html


//http://www.jianshu.com/p/613916eea37f

@interface RunLoopViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* listData;


@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSString *name;

@end

@implementation RunLoopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self setupData];
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - masonry

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - private method

- (void)setupUI
{
    _tableView = ({
        UITableView* tableview = [[UITableView alloc] init];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        tableview;
    });
    [self.view addSubview:_tableView];
}

- (void)setupData
{
    
    _listData = [[NSMutableArray alloc] init];
    [_listData addObject:@"RunLoop概念"];
    [_listData addObject:@"RunLoop常用mode"];
    [_listData addObject:@"子线程RunLoop定时器"];
    [_listData addObject:@"子线程通知&KVO"];
    
    [_listData addObject:@"EventHandler异步事件队列"];
    
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self actionWithRow:indexPath.row];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* reuseIdetify = @"tableViewCellIdetify";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showsReorderControl = YES;
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [self.listData objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 50;
}

#pragma mark - private method

- (void)actionWithRow:(NSUInteger)row
{
    NSString *methodName = [NSString stringWithFormat:@"test%ld",row];
    SEL sel = NSSelectorFromString(methodName);
    [self performSelector:sel withObject:nil afterDelay:0];
}

#pragma mark -
- (void)test0
{
    NSLog(@"一般来讲，一个线程一次只能执行一个任务，执行完成后线程就会退出。如果我们需要一个机制，让线程能随时处理事件但并不退出，通常的代码逻辑是这样的：function loop() {\
              initialize();\
              do {\
                  var message = get_next_message();\
                  process_message(message);\
              } while (message != quit);\
          }\
          这种模型通常被称作 Event Loop。 Event Loop 在很多系统和框架里都有实现，比如 Node.js 的事件处理，比如 Windows 程序的消息循环，再比如 OSX/iOS 里的 RunLoop。实现这种模型的关键点在于：如何管理事件/消息，如何让线程在没有处理消息时休眠以避免资源占用、在有消息到来时立刻被唤醒。\
          所以，RunLoop 实际上就是一个对象，这个对象管理了其需要处理的事件和消息，并提供了一个入口函数来执行上面 Event Loop 的逻辑。线程执行了这个函数后，就会一直处于这个函数内部 接受消息->等待->处理的循环中，直到这个循环结束（比如传入 quit 的消息），函数返回。");
    /*
     OSX/iOS 系统中，提供了两个这样的对象：NSRunLoop 和 CFRunLoopRef。
     
     CFRunLoopRef 是在 CoreFoundation 框架内的，它提供了纯 C 函数的 API，所有这些 API 都是线程安全的。
     
     NSRunLoop 是基于 CFRunLoopRef 的封装，提供了面向对象的 API，但是这些 API 不是线程安全的。
     
     CFRunLoopRef 的代码是开源的，你可以在这里 http://opensource.apple.com/tarballs/CF/CF-855.17.tar.gz 下载到整个 CoreFoundation 的源码。为了方便跟踪和查看，你可以新建一个 Xcode 工程，把这堆源码拖进去看。
     */
    /*
     一个 RunLoop 包含若干个 Mode，每个 Mode 又包含若干个 Source/Timer/Observer。每次调用 RunLoop 的主函数时，只能指定其中一个 Mode，这个Mode被称作 CurrentMode。如果需要切换 Mode，只能退出 Loop，再重新指定一个 Mode 进入。这样做主要是为了分隔开不同组的 Source/Timer/Observer，让其互不影响。
     
     CFRunLoopSourceRef 是事件产生的地方。Source有两个版本：Source0 和 Source1。
     
     Source0 只包含了一个回调（函数指针），它并不能主动触发事件。使用时，你需要先调用 CFRunLoopSourceSignal(source)，将这个 Source 标记为待处理，然后手动调用 CFRunLoopWakeUp(runloop) 来唤醒 RunLoop，让其处理这个事件。
     Source1 包含了一个 mach_port 和一个回调（函数指针），被用于通过内核和其他线程相互发送消息。这种 Source 能主动唤醒 RunLoop 的线程，其原理在下面会讲到。
     CFRunLoopTimerRef 是基于时间的触发器，它和 NSTimer 是toll-free bridged 的，可以混用。其包含一个时间长度和一个回调（函数指针）。当其加入到 RunLoop 时，RunLoop会注册对应的时间点，当时间点到时，RunLoop会被唤醒以执行那个回调。
     
     CFRunLoopObserverRef 是观察者，每个 Observer 都包含了一个回调（函数指针），当 RunLoop 的状态发生变化时，观察者就能通过回调接受到这个变化。可以观测的时间点有以下几个：
     
     可以看到，系统默认注册了5个Mode:
     
     1. kCFRunLoopDefaultMode: App的默认 Mode，通常主线程是在这个 Mode 下运行的。
     
     2. UITrackingRunLoopMode: 界面跟踪 Mode，用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他 Mode 影响。
     
     3. UIInitializationRunLoopMode: 在刚启动 App 时第进入的第一个 Mode，启动完成后就不再使用。
     
     4: GSEventReceiveRunLoopMode: 接受系统事件的内部 Mode，通常用不到。
     
     5: kCFRunLoopCommonModes: 这是一个占位的 Mode，没有实际作用。
     
     你可以在这里看到更多的苹果内部的 Mode，但那些 Mode 在开发中就很难遇到了。
     
     当 RunLoop 进行回调时，一般都是通过一个很长的函数调用出去 (call out), 当你在你的代码中下断点调试时，通常能在调用栈上看到这些函数。下面是这几个函数的整理版本，如果你在调用栈中看到这些长函数名，在这里查找一下就能定位到具体的调用地点了：
     

     
     常用的mode:
     
     1. kCFRunLoopDefaultMode: App的默认 Mode，通常主线程是在这个 Mode 下运行的。
     
     2. UITrackingRunLoopMode: 界面跟踪 Mode，用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他 Mode 影响。
     */
}

- (void)test1
{
    /*
     
     常用的mode:
     
     1. kCFRunLoopDefaultMode: App的默认 Mode，通常主线程是在这个 Mode 下运行的。
     
     2. UITrackingRunLoopMode: 界面跟踪 Mode，用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他 Mode 影响。
     
     
     应用场景举例：主线程的 RunLoop 里有两个预置的 Mode：kCFRunLoopDefaultMode 和 UITrackingRunLoopMode。这两个 Mode 都已经被标记为"Common"属性。DefaultMode 是 App 平时所处的状态，TrackingRunLoopMode 是追踪 ScrollView 滑动时的状态。当你创建一个 Timer 并加到 DefaultMode 时，Timer 会得到重复回调，但此时滑动一个TableView时，RunLoop 会将 mode 切换为 TrackingRunLoopMode，这时 Timer 就不会被回调，并且也不会影响到滑动操作。
     
     有时你需要一个 Timer，在两个 Mode 中都能得到回调，一种办法就是将这个 Timer 分别加入这两个 Mode。还有一种方式，就是将 Timer 加入到顶层的 RunLoop 的 "commonModeItems" 中。"commonModeItems" 被 RunLoop 自动更新到所有具有"Common"属性的 Mode 里去。
     */
    
    if (_timer) {
        [_timer invalidate];
        return;
    }
    _timer = [LDKTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerrun) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
    
//    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:kCFRunLoopCommonModes];// 和上一种方式一样
    
    /*
     有时你需要一个 Timer，在两个 Mode 中都能得到回调，一种办法就是将这个 Timer 分别加入这两个 Mode。还有一种方式，就是将 Timer 加入到顶层的 RunLoop 的 "commonModeItems" 中。"commonModeItems" 被 RunLoop 自动更新到所有具有"Common"属性的 Mode 里去。
     */
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)timerrun
{
    NSLog(@"timer");
}

- (void)test2
{
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(newThread) object:nil];
    [thread start];
    
    // NSNotificationCenter
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tttt) name:@"12345" object:nil];
    // KVO
    [self addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"%@",[NSThread currentThread]);
}

- (void)tttt
{
    NSLog(@"%@",[NSThread currentThread]);
}

- (void)newThread
{
      NSLog(@"%@",[NSThread currentThread]);
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"12345" object:nil];
    self.name = @"123";
    
    @autoreleasepool
  {
      // 循环引用
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(addTime) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] run];
}
}
- (void)addTime
{
    NSLog(@"runloop timer");
}

- (void)test3
{
    /*
     - (void)test2
     {
     NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(newThread) object:nil];
     [thread start];
     
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tttt) name:@"12345" object:nil];
     }
     
     - (void)tttt
     {
     NSLog(@"%@",[NSThread currentThread]);
     }
     
     - (void)newThread
     {
     NSLog(@"%@",[NSThread currentThread]);
     [[NSNotificationCenter defaultCenter] postNotificationName:@"12345" object:nil];
     
     @autoreleasepool
     {
     // 循环引用
     //    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(addTime) userInfo:nil repeats:YES];
     //    [[NSRunLoop currentRunLoop] run];
     }
     }

     */
}


/*
 一直想写一篇关于runloop学习有所得的文章，总是没有很好的例子。正巧自己的上线App Store的小游戏《跑酷好基友》（）中有一个很好的实际使用例子。游戏中有一个计时功能。在1.0版本中，使用了简单的在主线程中调用：
 
 1 + (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;
 的方法。但是当每0.01秒进行一次repeat操作时，NSTimer是不准的，严重滞后，而改成0.1秒repeat操作，则这种滞后要好一些。
 
 导致误差的原因是我在使用“scheduledTimerWithTimeInterval”方法时，NSTimer实例是被加到当前runloop中的，模式是NSDefaultRunLoopMode。而“当前runloop”就是应用程序的main runloop，此main runloop负责了所有的主线程事件，这其中包括了UI界面的各种事件。当主线程中进行复杂的运算，或者进行UI界面操作时，由于在main runloop中NSTimer是同步交付的被“阻塞”，而模式也有可能会改变。因此，就会导致NSTimer计时出现延误。
 
 解决这种误差的方法，一种是在子线程中进行NSTimer的操作，再在主线程中修改UI界面显示操作结果；另一种是仍然在主线程中进行NSTimer操作，但是将NSTimer实例加到main runloop的特定mode（模式）中。避免被复杂运算操作或者UI界面刷新所干扰。
 
 方法一：
 
 在开始计时的地方：
 
 1 if (self.timer) {
 2         [self.timer invalidate];
 3         self.timer = nil;
 4     }
 5     self.timer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(addTime) userInfo:nil repeats:YES];
 6     [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
 [NSRunLoop currentRunLoop]获取的就是“main runloop”，使用NSRunLoopCommonModes模式，将NSTimer加入其中。
 
 （借鉴了博文：）
 
 
 
 方法二：
 
 开辟子线程：（使用子线程的runloop）
 
 1 NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(newThread) object:nil];
 2     [thread start];
 1 - (void)newThread
 2 {
 3     @autoreleasepool
 4     {
 5         [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(addTime) userInfo:nil repeats:YES];
 6         [[NSRunLoop currentRunLoop] run];
 7     }
 8 }
 在子线程中将NSTimer以默认方式加到该线程的runloop中，启动子线程。
 
 
 
 方法三：
 
 使用GCD，同样也是多线程方式：
 
 声明全局成员变量
 
 1 dispatch_source_t _timers;
 1     uint64_t interval = 0.01 * NSEC_PER_SEC;
 2     dispatch_queue_t queue = dispatch_queue_create("my queue", 0);
 3     _timers = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
 4     dispatch_source_set_timer(_timers, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
 5     __weak ViewController *blockSelf = self;
 6     dispatch_source_set_event_handler(_timers, ^()
 7     {
 8         NSLog(@"Timer %@", [NSThread currentThread]);
 9         [blockSelf addTime];
 10     });
 11     dispatch_resume(_timers);
 然后在主线程中修改UI界面：
 
 1 dispatch_async(dispatch_get_main_queue(), ^{
 2         self.label.text = [NSString stringWithFormat:@"%.2f", self.timeCount/100];
 3     });
 游戏源代码可见：
 
 
 
 总结：
 
 runloop是一个看似很神秘的东西，其实一点也不神秘。每个线程都有一个实际已经存在的runloop。比如我们的主线程，在主函数的UIApplication中：
 
 1 UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]))
 系统就为我们将主线程的main runloop隐式的启动了。runloop顾名思义就是一个“循环”，他不停地运行，从程序开始到程序退出。正是由于这个“循环”在不断地监听各种事件，程序才有能力检测到用户的各种触摸交互、网络返回的数据才会被检测到、定时器才会在预定的时间触发操作……
 
 runloop只接受两种任务：输入源和定时源。本文中说的就是定时源。默认状态下，子线程的runloop中没有加入我们自己的源，那么我们在子线程中使用自己的定时器时，就需要自己加到runloop中，并启动该子线程的runloop，这样才能正确的运行定时器。
 

 */


- (void)test4
{
    NSLog(@"EventHandler异步事件队列测试开始^^^^^^^^^^^^????????########:");
    LEDListener *listener1 = [[LEDListener alloc] init];
    [[LEDEventHandler sharedEventHandler] addEventListener:listener1];
    LEDListener *listener2 = [[LEDListener alloc] init];
    [[LEDEventHandler sharedEventHandler] addEventListener:listener2];
    [[LEDEventHandler sharedEventHandler] addEventToQueue:1 message:@"123"];
    [[LEDEventHandler sharedEventHandler] addEventToQueue:2 message:@"456"];
    [[LEDEventHandler sharedEventHandler] addEventToQueue:3 message:@"789"];
    
//    [[LEDEventHandler sharedEventHandler] removeAllEventListener];
    
}

@end
