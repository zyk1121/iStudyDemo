//
//  MainViewController.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/6.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "MainViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "OpenGLViewController.h"
#import "MapSDKDemoViewController.h"
#import "HTTPTestViewController.h"
#import "DataStorageViewController.h"
#import "JSPatchViewController.h"
#import "QuartzCoreViewController.h"
#import "DeviceInfoViewController.h"
#import "ThirdPartViewController.h"
#import "OpenGLMainViewController.h"
#import "CustomUIViewController.h"
#import "TouchIDViewController.h"
#import "MediaViewController.h"
#import "SystemFunctionViewController.h"
#import "WebJSViewController.h"
#import "PortalViewController.h"
#import "EncryptDecryptViewController.h"
#import "CustomControlViewController.h"
#import "ThreadViewController.h"
#import "MVVMViewController.h"
#import "UnitTestStubMockViewController.h"
#import "RunLoopViewController.h"
#import "RunTimeViewController.h"
#import "SwiftViewController.h"
#import "RACViewController.h"
#import "ReactNativeViewController.h"
#import "PushNotificationViewController.h"

// http://www.cocoachina.com/ios/20150825/13195.html

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *listViewControllers;

@end

@implementation MainViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"iStudyDemo";
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"返回";
    // returnButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = returnButtonItem;
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
    _listViewControllers = [[NSMutableArray alloc] init];
    
    // 1.Thread
    [_listData addObject:@"多线程"];
    ThreadViewController *threadController = [[ThreadViewController alloc] init];
    [_listViewControllers addObject:threadController];
    
    // 2.map SDK
    [_listData addObject:@"地图SDK & 定位"];
    MapSDKDemoViewController *mapSDKViewController = [[MapSDKDemoViewController alloc] init];
    [_listViewControllers addObject:mapSDKViewController];
    
    // 3.HTTP 网络
    [_listData addObject:@"HTTP 网络"];
    HTTPTestViewController *httpTestViewController = [[HTTPTestViewController alloc] init];
    [_listViewControllers addObject:httpTestViewController];

    // 4.数据存取
    [_listData addObject:@"数据存取"];
    DataStorageViewController *dataStorageViewController = [[DataStorageViewController alloc] init];
    [_listViewControllers addObject:dataStorageViewController];
    
    // 5.JSPatch
    [_listData addObject:@"JSPatch"];
    JSPatchViewController *jsPatchViewController = [[JSPatchViewController alloc] init];
    [_listViewControllers addObject:jsPatchViewController];
    
    // 6.QuartzCore
    [_listData addObject:@"QuartzCore"];
    QuartzCoreViewController *quartzCoreViewController = [[QuartzCoreViewController alloc] init];
    [_listViewControllers addObject:quartzCoreViewController];
    
    // 7.设备信息
    [_listData addObject:@"设备信息"];
    DeviceInfoViewController *deviceinfoViewController = [[DeviceInfoViewController alloc] init];
    [_listViewControllers addObject:deviceinfoViewController];
    // 8.第三方
    [_listData addObject:@"第三方"];
    ThirdPartViewController *thirdpartViewController = [[ThirdPartViewController alloc] init];
    [_listViewControllers addObject:thirdpartViewController];
    // 9.经典界面设计
    [_listData addObject:@"经典界面设计"];
    CustomUIViewController *customUIViewController = [[CustomUIViewController alloc] init];
    [_listViewControllers addObject:customUIViewController];
    // 10.touchID
    [_listData addObject:@"TouchID"];
    TouchIDViewController *touchidController = [[TouchIDViewController alloc] init];
    [_listViewControllers addObject:touchidController];
    // 11.multiMedia
    [_listData addObject:@"多媒体"];
    MediaViewController *mediaController = [[MediaViewController alloc] init];
    [_listViewControllers addObject:mediaController];
    // 12.System
    [_listData addObject:@"系统服务"];
    SystemFunctionViewController *systemController = [[SystemFunctionViewController alloc] init];
    [_listViewControllers addObject:systemController];
    // 13.Portal
    [_listData addObject:@"Portal"];
    PortalViewController *portalController = [[PortalViewController alloc] init];
    [_listViewControllers addObject:portalController];
    // 14.Web&JS
    [_listData addObject:@"WebJS"];
    WebJSViewController *webJSController = [[WebJSViewController alloc] init];
    [_listViewControllers addObject:webJSController];
    // 15.EncryptDecrypt
    [_listData addObject:@"加密解密(iOS)"];
    EncryptDecryptViewController *edController = [[EncryptDecryptViewController alloc] init];
    [_listViewControllers addObject:edController];
    // 16.CustomControl
    [_listData addObject:@"自定义控件"];
    CustomControlViewController *customControlController = [[CustomControlViewController alloc] init];
    [_listViewControllers addObject:customControlController];
    // 16.1.推送&埋点
    [_listData addObject:@"推送&埋点"];
    PushNotificationViewController *pushViewController = [[PushNotificationViewController alloc] init];
    [_listViewControllers addObject:pushViewController];
    // 17.RAC
    [_listData addObject:@"RAC"];
    RACViewController *racController = [[RACViewController alloc] init];
    [_listViewControllers addObject:racController];
    // 17.MVVM
    [_listData addObject:@"MVVM"];
    MVVMViewController *mvvmController = [[MVVMViewController alloc] init];
    [_listViewControllers addObject:mvvmController];
    // 18.UntiTestStubMok
    [_listData addObject:@"UnitTestStubMock"];
    UnitTestStubMockViewController *unitController = [[UnitTestStubMockViewController alloc] init];
    [_listViewControllers addObject:unitController];
    // 19.RunLoop
    [_listData addObject:@"RunLoop"];
    RunLoopViewController *runloopController = [[RunLoopViewController alloc] init];
    [_listViewControllers addObject:runloopController];
    // 20.RunLoop
    [_listData addObject:@"RunTime"];
    RunTimeViewController *runtimeController = [[RunTimeViewController alloc] init];
    [_listViewControllers addObject:runtimeController];
    
    // 0.opengl
    [_listData addObject:@"OpenGL"];
    OpenGLMainViewController *glViewController = [[OpenGLMainViewController alloc] init];
    [_listViewControllers addObject:glViewController];
    
    // 21.Swift
    [_listData addObject:@"Swift"];
    SwiftViewController *swiftViewController = [[SwiftViewController alloc] init];
    [_listViewControllers addObject:swiftViewController];
    
    // 22.ReactNative
    [_listData addObject:@"ReactNative"];
    ReactNativeViewController *reactnativeViewController = [[ReactNativeViewController alloc] init];
    [_listViewControllers addObject:reactnativeViewController];
    
    
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
    
    UIViewController *vc = [self.listViewControllers objectAtIndex:indexPath.row];
    vc.title = [self.listData objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
    
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
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
