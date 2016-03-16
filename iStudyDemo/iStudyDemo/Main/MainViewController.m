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
    
    // 1.opengl
    [_listData addObject:@"OpenGL学习"];
    OpenGLMainViewController *glViewController = [[OpenGLMainViewController alloc] init];
    [_listViewControllers addObject:glViewController];
    
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
