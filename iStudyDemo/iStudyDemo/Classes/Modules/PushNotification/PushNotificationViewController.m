//
//  PushNotificationViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/31.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "PushNotificationViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "AppDelegate.h"

@interface PushNotificationViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;

@end

@implementation PushNotificationViewController

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
    
    [_listData addObject:@"本地推送"];
    // http://blog.csdn.net/showhilllee/article/details/8631734
    [_listData addObject:@"远程推送"];  // http://blog.csdn.net/shenjie12345678/article/details/41120637
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
    switch (indexPath.row) {
        case 0:
            [self testLocalNotification];
            break;
        case 1:
            [self testRemoteNotification];
            break;
        default:
            break;
    }
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

#pragma mark - notification

- (void)testLocalNotification
{
    static NSInteger timeValue = 0;
    // 本地推送通知
    [AppDelegate registerLocalNotification:timeValue];
    timeValue = 5;
}

- (void)testRemoteNotification
{
    // http://blog.csdn.net/showhilllee/article/details/8631734
    // 远程推送
    /*
     4、要注意顺序问题，一定要按照这个顺序来：
     生成钥匙串请求 -->配置下载开发证书-->  配置App ID ，配置、下载SSL证书-->Provisioning证书
     */
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:@"请参考appdelegate中的代码，实现了页面的直接跳转. 要注意顺序问题，一定要按照这个顺序来：\n                              生成钥匙串请求 -->配置下载开发证书-->  配置App ID ，配置、下载SSL证书-->Provisioning证书 URL1:http://blog.csdn.net/showhilllee/article/details/8631734   URL2:http://blog.csdn.net/shenjie12345678/article/details/41120637" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
    
}


@end
