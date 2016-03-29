//
//  ThreadViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "ThreadViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import <pthread.h>
#import "NSTimerTestViewController.h"

// http://www.jianshu.com/p/0b0d9b1f1f19
/*
 Pthreads
 NSThread
 GCD
 NSOperation & NSOperationQueue
 */


@interface ThreadViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
//@property (nonatomic, strong) NSMutableArray *listViewControllers;

@end

@implementation ThreadViewController

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
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - private method

- (void)setupUI
{
    _tableView = ({
        UITableView *tableview = [[UITableView alloc] init];
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
//    _listViewControllers = [[NSMutableArray alloc] init];
    
    [_listData addObject:@"Pthreads"];
    [_listData addObject:@"NSThread"];
    [_listData addObject:@"GCD"];
    [_listData addObject:@"NSOperation & NSOperationQueue"];
    [_listData addObject:@"NSTimer"];
    
//    // 1.第三方分享
//    [_listData addObject:@"第三方分享&登录"];
////    ThirdShareViewController *thirdShareViewController = [[ThirdShareViewController alloc] init];
////    [_listViewControllers addObject:thirdShareViewController];
//    // 2.QRCode
//    [_listData addObject:@"二维码QRCode"];
////    QRCodeViewController *qrcodeViewController = [[QRCodeViewController alloc] init];
////    [_listViewControllers addObject:qrcodeViewController];
//    // 3.XMPP
//    [_listData addObject:@"XMPP"];
////    XMPPViewController *xmppViewController = [[XMPPViewController alloc] init];
//    [_listViewControllers addObject:xmppViewController];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.listData.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /* Pthreads
     NSThread
     GCD
     NSOperation & NSOperationQueue*/
    switch (indexPath.row) {
        case 0:
            [self PthredsTest];
            break;
        case 1:
            [self NSThreadTest];
            break;
        case 2:
            [self GCDTest];
            break;
        case 3:
            [self NSOperationTest];
            break;
        case 4:
            [self NSTimerTest];
            break;
        default:
            break;
    }
//    UIViewController *vc = [self.listViewControllers objectAtIndex:indexPath.row];
//    vc.title = [self.listData objectAtIndex:indexPath.row];
    
//    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdetify = @"tableViewCellIdetify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showsReorderControl = YES;
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [self.listData objectAtIndex:indexPath.row];
    //    cell.detailTextLabel.text = [self.listData objectForKey:[self.listData allKeys][indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - Pthreads


void *start(void *data) {
    NSLog(@"%@", [NSThread currentThread]);
    
    return NULL;
}

- (void)PthredsTest
{

    
    pthread_t thread;
    //创建一个线程并自动执行
    /*
     
     这段代码虽然创建了一个线程，但并没有销毁。*/
    pthread_create(&thread, NULL, start, NULL);
}

#pragma mark - NSThread

- (void)NSThreadTest
{
    
//    // 1.创建
//    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
//    
//    // 启动
//    [thread start];
//    
    // 2.创建并自动启动
    
//    [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
    // 3.使用 NSObject 的方法创建并自动启动
    
    [self performSelectorInBackground:@selector(run) withObject:nil];
    
    /*
     文／伯恩的遗产（简书作者）
     原文链接：http://www.jianshu.com/p/0b0d9b1f1f19
     著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。
     
     //取消线程
     - (void)cancel;
     
     //启动线程
     - (void)start;
     
     //判断某个线程的状态的属性
     @property (readonly, getter=isExecuting) BOOL executing;
     @property (readonly, getter=isFinished) BOOL finished;
     @property (readonly, getter=isCancelled) BOOL cancelled;
     
     //设置和获取线程名字
     -(void)setName:(NSString *)n;
     -(NSString *)name;
     
     //获取当前线程信息
     + (NSThread *)currentThread;
     
     //获取主线程信息
     + (NSThread *)mainThread;
     
     //使当前线程暂停一段时间，或者暂停到某个时刻
     + (void)sleepForTimeInterval:(NSTimeInterval)time;
     + (void)sleepUntilDate:(NSDate *)date;
     */
}

- (void)run
{
    NSLog(@"run");
//    [NSThread currentThread];
}

#pragma mark - GCD

// http://blog.csdn.net/totogo2010/article/details/8016129

/*
 a.串行队列：顺序地一个一个执行任务
 b.并行队列：同时/并行的执行多个任务
 2)执行方式
 a.同步执行：在当前线程中执行任务，等待任务完成
 b.异步执行：启动新的子线程执行任务;立即返回，执行下一个任务
 
 
 
 文／伯恩的遗产（简书作者）
 原文链接：http://www.jianshu.com/p/0b0d9b1f1f19
 著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。
 
 同步（sync） 和 异步（async） 的主要区别在于会不会阻塞当前线程，直到 Block 中的任务执行完毕！
 如果是 同步（sync） 操作，它会阻塞当前线程并等待 Block 中的任务执行完毕，然后当前线程才会继续往下运行。
 如果是 异步（async）操作，当前线程会直接往下执行，它不会阻塞当前线程。
 */

/*
 同步和异步的概念对于很多人来说是一个模糊的概念，是一种似乎只能意会不能言传的东西。其实我们的生活中存在着很多同步异步的例子。比如：你叫我去吃饭，我听到了就立刻和你去吃饭，如果我们有听到，你就会一直叫我，直到我听见和你一起去吃饭，这个过程叫同步；异步过程指你叫我去吃饭，然后你就去吃饭了，而不管我是否和你一起去吃饭。而我得到消息后可能立即就走，也可能过段时间再走。
 
 */
- (void)GCDTest
{
    
//1）使用GCD方式从网络上下载图片(耗时操作 - - >子线程),全局队列 + 异步执行
    
    // 1.获取全局队列（0，0）
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 2.创建dispatch_group_t对象
    dispatch_group_t group = dispatch_group_create();
    
    // 3.将下载任务添加到 group中（异步执行）
    dispatch_group_async(group, queue,
                         ^{
                             // 下载任务
                             [NSThread sleepForTimeInterval:5];
                             NSLog(@"第一个图片下载成功, %@", [NSThread currentThread]);
                         });
    dispatch_group_async(group, queue,
                         ^{
                             [NSThread sleepForTimeInterval:2];
                             NSLog(@"第二个图片下载成功, %@", [NSThread currentThread]);
                         });
    dispatch_group_async(group, queue,
                         ^{
                             [NSThread sleepForTimeInterval:1];
                             NSLog(@"第三个图片下载成功, %@", [NSThread currentThread]);
                         });
    
    NSLog(@"线程: %@", [NSThread currentThread]);
    
    // 4.调用dispatch_group_notify方法，通知组中所有任务完成
    dispatch_group_notify(group, queue,
                          ^{        // 合并上面三个图片下载完成
                              NSLog(@"三个图片全部下载完成");
                          });
    
    /**
     *  常用的操作
     */
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
        });
        
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });

}

#pragma mark NSOperation & NSOperationQueue

- (void)NSOperationTest
{
    /*
    //1.创建NSInvocationOperation对象
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    
    //2.开始执行
    [operation start];
    */
    

    /*
    
    //1.创建NSBlockOperation对象
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
    }];
    
    //2.开始任务
    [operation start];*/
    
    
    /*
    //1.创建NSBlockOperation对象
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
    }];
    
    //添加多个Block
    for (NSInteger i = 0; i < 5; i++) {
        [operation addExecutionBlock:^{
            NSLog(@"第%ld次：%@", i, [NSThread currentThread]);
        }];
    }
    
    //2.开始任务
    [operation start];
     
     */
    

    /*
    //1.创建一个其他队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    //2.创建NSBlockOperation对象
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
    }];
    
    //3.添加多个Block
    for (NSInteger i = 0; i < 5; i++) {
        [operation addExecutionBlock:^{
            NSLog(@"第%ld次：%@", i, [NSThread currentThread]);
        }];
    }
    
    //4.队列添加任务
    [queue addOperation:operation];
     */
    
    
    //1.任务一：下载图片
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载图片 - %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    
    //2.任务二：打水印
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"打水印   - %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    
    //3.任务三：上传图片
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"上传图片 - %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    
    //4.设置依赖
    [operation2 addDependency:operation1];      //任务二依赖任务一
    [operation3 addDependency:operation2];      //任务三依赖任务二
    
    //5.创建队列并加入任务
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[operation3, operation2, operation1] waitUntilFinished:NO];
    
    /*
    // 线程同步，互斥锁
    
    
    @synchronized(self) {
        //需要执行的代码块
    }
     
     */
}


- (void)NSTimerTest
{
    NSTimerTestViewController *vc = [[NSTimerTestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}


@end
