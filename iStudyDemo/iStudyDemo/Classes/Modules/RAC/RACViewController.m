//
//  RACViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "RACViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "UIKitMacros.h"
#import "masonry.h"
#import <extobjc.h>

// http://www.jianshu.com/p/4b99ddce3bae
// http://www.jianshu.com/p/87ef6720a096
// http://www.jianshu.com/collection/f5f30621ed6c
// http://www.jianshu.com/p/aa155560bfed?utm_campaign=maleskine&utm_content=note&utm_medium=mobile_author_hots&utm_source=recommendation
// http://www.jianshu.com/p/ff79a5ae0353

// http://www.cocoachina.com/ios/20140621/8905_4.html

// 事件，代理，KVO，通知  的统一方式
/*
FRP解释：
在命令式编程环境中，a = b + c 表示将表达式的结果赋给a，而之后改变b或c的值不会影响a。但在响应式编程中，a的值会随着b或c的更新而更新。
*/

/*
 4.ReactiveCocoa编程思想
 ReactiveCocoa结合了几种编程风格：
 
 函数式编程（Functional Programming）
 
 响应式编程（Reactive Programming）
 
 所以，你可能听说过ReactiveCocoa被描述为函数响应式编程（FRP）框架。
 
 以后使用RAC解决问题，就不需要考虑调用顺序，直接考虑结果，把每一次操作都写成一系列嵌套的方法中，使代码高聚合，方便管理。
 
 */

@interface RACViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* listData;

@property (nonatomic, copy) NSString* name;

@property (nonatomic, strong) RACCommand* loadCommand;

@end

@implementation RACViewController

- (void)viewDidLoad
{
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

    [_listData addObject:@"RAC"];
    [_listData addObject:@"RACObserve"];
    [_listData addObject:@"RACTargetAction"];
    [_listData addObject:@"RACDelegate"];
    [_listData addObject:@"RACNotification"];
    [_listData addObject:@"RACKVO"];
    [_listData addObject:@"YK_RACSignal"];
    [_listData addObject:@"YK_map"];
    [_listData addObject:@"YK_filter"];
    [_listData addObject:@"YK_take_skip_"];
    [_listData addObject:@"YK_ignore"];
    [_listData addObject:@"YK_distinctUntilChanged"];
    [_listData addObject:@"YK_delay"];
    [_listData addObject:@"YK_throttle"];
    [_listData addObject:@"YK_startwith"];
    [_listData addObject:@"YK_timeout"];
    [_listData addObject:@"YK_mapreplace"];
    [_listData addObject:@"YK_contact"];
    [_listData addObject:@"YK_merge"];
    [_listData addObject:@"YK_zip_zpiwith"];
    [_listData addObject:@"YK_combineLatest"];
    [_listData addObject:@"YK_flattenMap_flatten"];

    [_listData addObject:@"YK_RACCommand"];

    [_listData addObject:@"YK_ColdSignal"];

    [_listData addObject:@"YK_HotSignal"];

    [_listData addObject:@"YK_RACDisposable"];

    [_listData addObject:@"TestData"];
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
    NSString* methodName = _listData[indexPath.row];
    SEL sel = NSSelectorFromString(methodName);
    [self performSelector:sel];
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
    return 60;
}

#pragma mark - private method

/*
 宏：RAC 和 RACObserve:
 RAC:可以看做是某个属性的值和一些信号的联动。
 也就是说，某个属性是bool值，而信号的send的也是bool值，那么就可以使用RAC来绑定某个属性与此信号。
 RACObserve：监听属性的改变，可以看做是使用block的kvo。对某一属性重新赋值即可得到属性的改变，相当于一个信号发送了一个sendNext。
 
 常用的方式是：RAC(...,....) = RACObserve(,,,.,,,,)；
 RAC(self, name) = RACObserve(self, str);
 RACSignal *signal = RACObserve(self, str);
 [signal subscribeNext:^(id x) {
 NSLog(@"%@",x);
 }];
 可以理解成：左边的RAC订阅了右方信号的next事件，并绑定值到name上；右边的RACObserve首先监听str的kvo，当str变化的时候会发送一个sendNext事件，也可以执行map等其他的信号转换。但不是所有的property都可以被RACObserve，该property必须支持KVO，比如NSURLCache的currentDiskUsage就不能被RACObserve。
 
 RACObserve(self, data.name);当data或者name变化的时候，sendNext：；而当self释放的时候，发送complete信号。
 
 RACSignal的订阅者的dispose被调用的时机是complete或则error被发送。
 */
- (void)RAC
{
    //RAC(TARGET, [KEYPATH, [NIL_VALUE]]):用于给某个对象的某个属性绑定
    RAC(self.tableView, backgroundColor) = [RACObserve(self, name) map:^UIColor*(NSString* value) {
        if ([value length] > 3) {
            return [UIColor redColor];
            // self.name = @"12345";
        }
        else {
            return [UIColor blueColor];
            // self.name = @"12";
        }
    }];
}

- (void)RACObserve
{
    // RACObserve(self, name):监听某个对象的某个属性,返回的是信号
    [RACObserve(self.tableView, contentOffset) subscribeNext:^(id x) {

        NSLog(@"%@", x);
        // 下面的两句话都会有循环引用
        //        NSLog(@"%@",self.name);
        //        NSLog(@"%@",_name);
    }];
}

- (void)RACTargetAction
{
    //   [[self rac_willDeallocSignal] subscribeNext:^(id x) {
    //       NSLog(@"will dealloc");
    //   }];
    /*
     [[self.textFild rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x){
     NSLog(@"change");
     }];
     [[self.textFild rac_textSignal] subscribeNext:^(id x) {
     NSLog(@"%@",x);
     }];
     
     UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
     [[tap rac_gestureSignal] subscribeNext:^(id x) {
     NSLog(@"tap");
     }];
     [self.view addGestureRecognizer:tap];
     */
}

- (void)RACDelegate
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"RAC" message:@"RAC TEST" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"other", nil];
    //    [[self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(RACTuple *tuple) {
    //        NSLog(@"%@",tuple.first);
    //        NSLog(@"%@",tuple.second);
    //        NSLog(@"%@",tuple.third);
    //    }];

    [[alertView rac_buttonClickedSignal] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [alertView show];
}

- (void)RACNotification
{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"postData" object:nil] subscribeNext:^(NSNotification* notification) {
        NSLog(@"%@", notification.name);
        NSLog(@"%@", notification.object);
    }];

    /*
 可见，notification.object就是我们想要的数组，当然我们也可以传一些model。值得一提的是，RAC中的通知不需要remove observer，因为在rac_add方法中他已经写了remove。*/

    NSMutableArray* dataArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:dataArray];
}

- (void)RACKVO
{
    /*
     UIScrollView *scrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 200, 400)];
     scrolView.contentSize = CGSizeMake(200, 800);
     scrolView.backgroundColor = [UIColor greenColor];
     [self.view addSubview:scrolView];
     [RACObserve(scrolView, contentOffset) subscribeNext:^(id x) {
     NSLog(@"success");
     }];
     */
}

- (void)YK_RACSignal
{
    //创建信号
    RACSignal* signal = [RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"signal"];
        [subscriber sendCompleted];
        return nil;
    }];

    //订阅信号
    [signal subscribeNext:^(id x) {
        NSLog(@"x = %@", x);
    }
        error:^(NSError* error) {
            NSLog(@"error = %@", error);
        }
        completed:^{
            NSLog(@"completed");
        }];

    RACSignal* mapSignal = [signal map:^id(id value) {
        return @"123";
    }];
    [mapSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

- (void)YK_map
{ //创建信号
    RACSignal* signal = [RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"signal"];
        [subscriber sendCompleted];
        return nil;
    }];

    RACSignal* mapSignal = [signal map:^id(id value) {
        return @"123";
    }];
    [mapSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

- (void)YK_filter
{
    //    [[self.textFild.rac_textSignal filter:^BOOL(NSString *value) {
    //        return [value length] > 3;
    //    }] subscribeNext:^(id x) {
    //        NSLog(@"x = %@", x);
    //    }];
}

- (void)YK_take_skip_
{
    // take 获取前两个
    // skip 跳过前2个
    // repeat 一直重复
    // takeuntil 当给定的signal完成前一直取值,，假设是网络请求，则当self.rac_willDeallocSignal，完成的时候才结束当前signal
    //  http://www.cocoachina.com/ios/20140621/8905_4.html takeWhileBlock
    // takeWhileBlock 当block返回YES时获取结果
    // takeuntilBlock 对于每个next值，运行block，当block返回YES时停止取值
    // skipWhileBlock
    // skipUntilBlock
    // repeatWhileBlock

    /*
     相似的还有takeLast takeUntil takeWhileBlock skipWhileBlock skipUntilBlock repeatWhileBlock都可以根据字面意思来理解。
     */
    RACSignal* signal = [[RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"2"];
        [subscriber sendNext:@"3"];
        [subscriber sendNext:@"4"];
        [subscriber sendNext:@"5"];
        [subscriber sendCompleted];
        return nil;
    }] skipWhileBlock:^BOOL(id x) {
        //        NSLog(@"%@",x);
        return [x isEqualToString:@"3"];
    }];

    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }
        completed:^{
            NSLog(@"completed");
        }];
}

- (void)YK_ignore
{
    RACSignal* signal = [[RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"2"];
        [subscriber sendNext:@"3"];
        [subscriber sendNext:@"4"];
        [subscriber sendNext:@"5"];
        [subscriber sendCompleted];
        return nil;
    }] ignore:@"3"];

    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }
        completed:^{
            NSLog(@"completed");
        }];
}

// distinctUntilChanged 可用于网络请求
- (void)YK_distinctUntilChanged
{
    RACSignal* signal = [[RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"2"];
        [subscriber sendNext:@"2"];
        [subscriber sendNext:@"3"];
        [subscriber sendCompleted];
        return nil;
    }] distinctUntilChanged];

    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }
        completed:^{
            NSLog(@"completed");
        }];
}
/*
 [_listData addObject:@"YK_delay"];
 [_listData addObject:@"YK_throttle"];
 [_listData addObject:@"YK_startwith"];
 [_listData addObject:@"YK_timeout"];
 */

- (void)YK_delay
{
    RACSignal* siganl = [[RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {

        NSLog(@"realySendSignal");
        [subscriber sendNext:@1];
        [subscriber sendCompleted];

        return [RACDisposable disposableWithBlock:^{
            NSLog(@"discard Signal");
        }];
    }] delay:3];
    NSLog(@"SubscriSiganl");
    [siganl subscribeNext:^(id x) {

        NSLog(@"recevieSiganl=%@", x);
    }];
}

- (void)YK_throttle
{

    RACSignal* signal = [[RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"1"];
        sleep(1);
        [subscriber sendNext:@"2"];
        sleep(1);
        [subscriber sendNext:@"3"];
        sleep(1);
        [subscriber sendNext:@"4"];
        sleep(1);
        [subscriber sendNext:@"5"];
        sleep(1);
        [subscriber sendCompleted];
        return nil;
    }] throttle:0.5];

    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }
        completed:^{
            NSLog(@"completed");
        }];

    /*
     [[self.testTextField.rac_textSignal throttle:0.5]subscribeNext:^(id x){
     NSLog(@"%@", x);
     }];
     */
}

- (void)YK_timeout
{
    RACSignal* siganl = [[RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {

        // 假设某个请求的时间用了几秒
        [[RACScheduler mainThreadScheduler] afterDelay:4 schedule:^{

            [subscriber sendNext:@"one"];
            [subscriber sendCompleted];
        }];

        return [RACDisposable disposableWithBlock:^{
            //            NSLog(@"销毁信号");
        }];
        // 然后timeout就是当超过这个时间的时候就会出错
    }] timeout:3
        onScheduler:[RACScheduler mainThreadScheduler]];

    [siganl subscribeNext:^(id x) {

        NSLog(@"x==%@", x);

    }
        error:^(NSError* error) {

            // 这个地方就很容易来处理错误的时候啦
            NSLog(@"error==%@", [error description]);

        }
        completed:^{

            NSLog(@"completed");
        }];
}

- (void)YK_startwith
{
    RACSignal* siganl = [[RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {

        [subscriber sendNext:@"one"];
        [subscriber sendCompleted];

        return [RACDisposable disposableWithBlock:^{

        }];
    }] startWith:@"two"];

    [siganl subscribeNext:^(id x) {

        NSLog(@"接收信号=%@", x);
    }];
}

- (void)YK_mapreplace
{
    RACSignal* signal = [[RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"1"];

        [subscriber sendNext:@"2"];

        [subscriber sendNext:@"3"];

        [subscriber sendNext:@"4"];

        [subscriber sendNext:@"5"];

        [subscriber sendCompleted];
        return nil;
    }] mapReplace:@"3"];

    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }
        completed:^{
            NSLog(@"completed");
        }];
}

- (void)YK_contact
{
    RACSignal* Asignal = [RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"2"];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal* Bsignal = [RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"4"];
        [subscriber sendNext:@"7"];
        [subscriber sendCompleted];
        return nil;
    }];

    RACSignal* signal = [Asignal concat:Bsignal]; // 1 2 4 7

    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }
        completed:^{
            NSLog(@"completed");
        }];
}

- (void)YK_merge
{
    RACSignal* Asignal = [RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [subscriber sendNext:@"1"];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [subscriber sendNext:@"2"];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [subscriber sendCompleted];
        });

        return nil;
    }];
    RACSignal* Bsignal = [RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [subscriber sendNext:@"4"];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [subscriber sendNext:@"7"];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [subscriber sendCompleted];
        });
        return nil;
    }];

    RACSignal* signal = [Asignal merge:Bsignal]; // 1 4 2 7   1 4 2 7两遍

    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }
        completed:^{
            NSLog(@"completed");
        }];

    /* [[RACSignal combineLatest:@[signalA,signalB,signalC]] subscribeNext:^(id x){
    
    NSLog(@"x==%@",x);
}];*/
}

- (void)YK_zip_zpiwith
{
    RACSignal* Asignal = [RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"2"];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal* Bsignal = [RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"4"];
        [subscriber sendNext:@"7"];
        [subscriber sendCompleted];
        return nil;
    }];

    // RACSignal *signal = [Asignal zipWith:Bsignal];// (1,4) (2,7)
    RACSignal* signal = [RACSignal zip:@[ Asignal, Bsignal ]];

    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }
        completed:^{
            NSLog(@"completed");
        }];
}

- (void)YK_combineLatest
{
    RACSignal* Asignal = [RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"2"];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal* Bsignal = [RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"4"];
        [subscriber sendNext:@"7"];
        [subscriber sendCompleted];
        return nil;
    }];

    // RACSignal *signal = [Asignal combineLatestWith:Bsignal];// (1,4) (2,7)
    RACSignal* signal = [RACSignal combineLatest:@[ Asignal, Bsignal ]]; //(2,4) (2,7)

    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }
        completed:^{
            NSLog(@"completed");
        }];
}

- (void)YK_flattenMap_flatten
{
    // asignal为信号的信号（signal of signals）
    // bSignal = [aSignal flatten]
    /*
     dSignal = [aSignal flattenMap: ^RACStream(id value) {
     if ([value isEqual:B]) {
     return bSignal;
     }else if([value isEqual:C]) {
     return cSignal;
     }else {
     return [RACSignal empty]; dSignal} ]
     */

    // bSignal = [aSignal switchToLatest]
}

- (RACCommand*)loadCommand
{
    if (!_loadCommand) {
        @weakify(self);
        _loadCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal*(id input) {
            @strongify(self);
            return [self fetchCashTicketInfoSignal];
        }];
    }
    return _loadCommand;
}

/*
 
 - (RACSignal *)fetchCashTicketListSignalWithTradeNumber:(NSString *)tradeNumber payToken:(NSString *)payToken
 {
 @weakify(self);
 return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
 @strongify(self);
 [self fetchCreditListWithOffset:self.offset
 limit:self.limit
 tradeNumber:tradeNumber
 payToken:payToken
 finished:^(MTCCashTicketListInfo *cashTicketListInfo, SAKError *error) {
 if (error) {
 [subscriber sendError:error];
 } else {
 [subscriber sendNext:cashTicketListInfo];
 [subscriber sendCompleted];
 }
 }];
 return nil;
 }];
 }
 */

- (RACSignal*)fetchCashTicketInfoSignal
{

    RACSignal* Asignal = [RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"2"];
        [subscriber sendCompleted];
        return nil;
    }];
    return Asignal;
    return nil;
    //    if (self.status == SPKTableViewStatusLoading) {
    //        return nil;
    //    }
    //
    //    self.status = SPKTableViewStatusLoading;
    //
    //    self.model.offset = self.offset;
    //
    //    @weakify(self);
    //    return [[[[self.model fetchCashTicketListSignalWithTradeNumber:self.tradeNumber payToken:self.payToken]
    //              doNext:^(MTCCashTicketListInfo *cashTicketListInfo) {
    //                  @strongify(self);
    //
    //                  self.helpURL = cashTicketListInfo.helpURL;
    //                  self.title = cashTicketListInfo.title;
    //                  self.helpInfo = cashTicketListInfo.helpInfo;
    //
    //                  if ([cashTicketListInfo.cashTicketList count]) {
    //                      [self.cashTicketInfoArray addObjectsFromArray:cashTicketListInfo.cashTicketList];
    //                      NSMutableArray *cashTicketUIObjectArray = [NSMutableArray arrayWithCapacity:0];
    //                      [cashTicketListInfo.cashTicketList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    //                          SPKCashTicketInfo *cashTicketInfo = (SPKCashTicketInfo *)obj;
    //                          MTCCashTicketUIObject *cashTicketUIObject = [[MTCCashTicketUIObject alloc] initWithCashTicketInfo:cashTicketInfo];
    //                          [cashTicketUIObjectArray addObject:cashTicketUIObject];
    //                          if (self.cashTicketInfo && (self.cashTicketInfo.ID == cashTicketUIObject.ID)) {
    //                              cashTicketUIObject.selected = YES;
    //                              self.selectedCashTicket = cashTicketUIObject;
    //                          }
    //                      }];
    //                      [self.fetchedResultsController performChanges:^{
    //                          @strongify(self);
    //                          [self.fetchedResultsController addObjectsInLastSection:[cashTicketUIObjectArray copy]];
    //                      }];
    //                  }
    //
    //                  self.hasMoreList = cashTicketListInfo.pageInfo.total > (self.offset + kMTCDefaultCashTicketListLimit);
    //                  self.hasCashTicketsData = !![self.fetchedResultsController numberOfObjects];
    //                  self.offset = cashTicketListInfo.pageInfo.offset;
    //              }] doError:^(NSError *error) {
    //                  @strongify(self);
    //                  self.status = SPKTableViewStatusError;
    //              }] doCompleted:^{
    //                  @strongify(self);
    //                  self.status = SPKTableViewStatusNormal;
    //              }];
}

- (void)YK_RACCommand
{
    [[self.loadCommand execute:nil] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }
        error:^(NSError* error) {
            NSLog(@"error");
        }
        completed:^{
            NSLog(@"completed");
        }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [[self.loadCommand execute:nil] subscribeNext:^(id x) {
            NSLog(@"%@", x);
        }
            error:^(NSError* error) {
                NSLog(@"error");
            }
            completed:^{
                NSLog(@"completed");
            }];
    });

    /*
     // target-action
     self.button.rac_command = [[RACCommand alloc] initWithSignalBlock:
     ^RACSignal *(id input) {
     NSLog(@"按钮被点击");
     return [RACSignal empty];
     }];
     
     // Notification
     [NSNotificationCenter.defaultCenter addObserver:self
     selector:@selector(keyboardDidChangeFrameNotificationHandler:)
     name:UIKeyboardDidChangeFrameNotification object:nil];
     */
}

- (void)YK_ColdSignal
{
    // 同步订阅
    /*
    // 冷信号
    NSLog(@"start test");
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"sendnext:@1");
        [subscriber sendNext:@1];
        NSLog(@"sendnext:@2");
        [subscriber sendNext:@2];
        NSLog(@"sendCompleted");
        [subscriber sendCompleted];
        return  nil;
    }];
    NSLog(@"signal was created");
    [signal subscribeNext:^(id x) {
        NSLog(@"receive next:%@",x);
    } error:^(NSError *error) {
        NSLog(@"receive error:%@",error);
    } completed:^{
        NSLog(@"receive completed");
    }];
    NSLog(@"sub finished");
     */

    /*
     2016-04-08 23:36:45.629 iStudyDemo[10112:397094] start test
     2016-04-08 23:36:45.631 iStudyDemo[10112:397094] signal was created
     2016-04-08 23:36:45.632 iStudyDemo[10112:397094] sendnext:@1
     2016-04-08 23:36:45.632 iStudyDemo[10112:397094] receive next:1
     2016-04-08 23:36:45.632 iStudyDemo[10112:397094] sendnext:@2
     2016-04-08 23:36:45.633 iStudyDemo[10112:397094] receive next:2
     2016-04-08 23:36:45.633 iStudyDemo[10112:397094] sendCompleted
     2016-04-08 23:36:45.633 iStudyDemo[10112:397094] receive completed
     2016-04-08 23:36:45.633 iStudyDemo[10112:397094] sub finished
     */

    //  异步订阅

    /*
    NSLog(@"start test");
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendCompleted];
        return  nil;
    }];
    
    asyncAfter(1, ^{
        [signal subscribeNext:^(id x) {
            NSLog(@"receive next:%@",x);
        } error:^(NSError *error) {
            NSLog(@"receive error:%@",error);
        } completed:^{
            NSLog(@"receive completed");
        }];

    });
     */

    // 异步发送

    /*
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        asyncAfter(1, ^{
            [subscriber sendNext:@1];
        });
        asyncAfter(2, ^{
            [subscriber sendNext:@2];
            
        });
        asyncAfter(3, ^{
            [subscriber sendCompleted];
        });
        
        
        
        return  nil;
    }];
    
    
    
    [signal subscribeNext:^(id x) {
        NSLog(@"receive next:%@",x);
    } error:^(NSError *error) {
        NSLog(@"receive error:%@",error);
    } completed:^{
        NSLog(@"receive completed");
    }];

     */

    // 异步发送异步订阅
    RACSignal* signal = [RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {
        asyncAfter(1, ^{
            [subscriber sendNext:@1];
        });
        asyncAfter(2, ^{
            [subscriber sendNext:@2];

        });
        asyncAfter(3, ^{
            [subscriber sendCompleted];
        });

        return nil;
    }];

    asyncAfter(1, ^{
        [signal subscribeNext:^(id x) {
            NSLog(@"receive next:%@", x);
        }
            error:^(NSError* error) {
                NSLog(@"receive error:%@", error);
            }
            completed:^{
                NSLog(@"receive completed");
            }];
    });
}

// 热信号
- (void)YK_HotSignal
{
    RACSubject* subject = [RACSubject subject];
    asyncAfter(1, ^{
        [subject subscribeNext:^(id x) {
            NSLog(@"1 next:%@", x);
        }
            error:^(NSError* error) {
                NSLog(@"1 error:%@", error);
            }
            completed:^{
                NSLog(@"1  completed");
            }];
    });

    asyncAfter(2, ^{
        [subject sendNext:@1];
        [subject sendError:nil];
    });

    asyncAfter(3, ^{
        [subject subscribeNext:^(id x) {
            NSLog(@"3 next:%@", x);
        }
            error:^(NSError* error) {
                NSLog(@"3 error:%@", error);
            }
            completed:^{
                NSLog(@"3  completed");
            }];
    });

    asyncAfter(4, ^{
        [subject subscribeNext:^(id x) {
            NSLog(@"4 next:%@", x);
        }
            error:^(NSError* error) {
                NSLog(@"4 error:%@", error);
            }
            completed:^{
                NSLog(@"4  completed");
            }];
    });

    asyncAfter(5, ^{
        [subject sendNext:@2];
        [subject sendError:nil];
    });
}

// 定义异步操作
void asyncAfter(int delaySeconds, void (^action)(void))
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        action();
    });
}

- (void)YK_RACDisposable
{
    RACSignal* signal = [RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {
        asyncAfter(1, ^{
            [subscriber sendNext:@1];
        });
        asyncAfter(2, ^{
            [subscriber sendNext:@2];

        });
        asyncAfter(3, ^{
            [subscriber sendCompleted];
        });

        return [RACDisposable disposableWithBlock:^{

        }];
    }];

    RACDisposable* disposable = [signal subscribeNext:^(id x) {
        NSLog(@"receive next:%@", x);
    }
        error:^(NSError* error) {
            NSLog(@"receive error:%@", error);
        }
        completed:^{
            NSLog(@"receive completed");
        }];

    asyncAfter(1.5, ^{
        [disposable dispose]; // receive next:1
    });
}

- (void)TestData
{
}

#pragma mark - dealloc

/*不会有循环引用
 
 为何GCD中的block不需要用weakself？
 
 原因是：self没有对block进行引用，block在执行结束后会自动销毁，只是block对self进行了单方面引用。
 
 
 _name = @"123";
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 //        NSLog(@"%@",_name);
 NSLog(@"%@",self.name);
 });
 
 
 
 _name = @"123";
 dispatch_async(dispatch_get_main_queue(), ^{
 sleep(1);
 NSLog(@"%@",self.name);
 });
 
 
 // 后台执行：
 dispatch_async(dispatch_get_global_queue(0, 0), ^{
 // something
 self.name = @"123";
 });
 
 
 都不会有循环引用
 
 
 
 下面的如果不加：@weakify(self);， @strongify(self);可能会出问题，因为返回的话，self被释放了
 
 
 
 
 dispatch_async(dispatch_get_global_queue(0, 0), ^{
 //1.管理器

 sleep(1);
 
 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 
 //2.设置登录参数
 NSDictionary *dict = @{ @"username":@"xn", @"password":@"123" };
 
 //3.请求
 [manager POST:@"http://api.ishowchina.com/v3/search/busline/byid?city=010&busIds=1100006301,1100006701&ak=ec85d3648154874552835438ac6a02b2" parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:[responseObject description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
 [alertView show];
 
 } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
 [alertView show];
 
 }];
 
 self.name = @"123";
 
 dispatch_async(dispatch_get_main_queue(), ^{
 
 });
 });

 
 
 */
- (void)dealloc
{
    NSLog(@"dealloc");
}

@end
