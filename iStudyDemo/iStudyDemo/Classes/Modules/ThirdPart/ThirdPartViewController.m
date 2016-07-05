//
//  ThirdPartViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/14.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "ThirdPartViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "ThirdShareViewController.h"
#import "QRCodeViewController.h"
#import "XMPPViewController.h"
#import <PassKit/PassKit.h>

@interface ThirdPartViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *listViewControllers;

@end

@implementation ThirdPartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    // 1.第三方分享
    [_listData addObject:@"第三方分享&登录"];
    ThirdShareViewController *thirdShareViewController = [[ThirdShareViewController alloc] init];
    [_listViewControllers addObject:thirdShareViewController];
    // 2.QRCode
    [_listData addObject:@"二维码QRCode"];
    QRCodeViewController *qrcodeViewController = [[QRCodeViewController alloc] init];
    [_listViewControllers addObject:qrcodeViewController];
    // 3.XMPP
    [_listData addObject:@"XMPP"];
    XMPPViewController *xmppViewController = [[XMPPViewController alloc] init];
    [_listViewControllers addObject:xmppViewController];
    
    // 4.融云 RC SDK(及时通讯和推送)
    [_listData addObject:@"融云IM & Push通知"];
    UIViewController *rciewController = [[UIViewController alloc] init];
    rciewController.view.backgroundColor = [UIColor whiteColor];
    /*
     融云 SDK 根据 iOS App 运行的特性，主要有以下三种运行状态：
     
     1、 前台状态 如字面意思，App 前台可见时 SDK 处于前台状态。此时 App 使用融云的 socket 来收发消息.
     
     2、 后台活动状态 当 App 进入后台三分钟之内，SDK 处于后台活跃状态。此时 App 使用融云的 socket 接收消息。
     
     如果您使用 IMKit ，此时 SDK 收到消息会弹出本地通知（必须实现用户信息提供者和群组信息提供者，否则将不会有本地通知提示弹出）。
     
     如果您使用 IMLib ，此时 SDK 不会弹出本地通知，如果您需要可以自己弹出本地通知提示。
     
     3、 后台暂停状态 当 App 进入后台两分钟之后或被杀进程或被冻结，SDK 将处于后台暂停状态。此时融云的 socket 会断开，融云 Server 会通过 APNs 将消息以远程推送的形式下发到客户端。 此状态下如果有人给该用户发送消息，融云的服务器会根据 deviceToken 和推送证书将消息发送到苹果推送服务器，苹果服务器会将该消息推送到客户端。
     */
    rciewController.title = @"不需要搭建服务器";
    [_listViewControllers addObject:rciewController];
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
//    cell.detailTextLabel.text = [self.listData objectForKey:[self.listData allKeys][indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
