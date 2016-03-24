//
//  CustomUIViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/16.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "CustomUIViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "QQMainViewController.h"
#import "QQContractViewController.h"
#import "QQDynamicViewController.h"
#import "UIImage+IPLImageKit.h"
#import "UIView+SHCZExt.h"
#import "QQTabbarViewController.h"
#import <UIKit/UIKit.h>
#import "QQSideBarViewController.h"
#import "NaviMenuViewController.h"
#import "SinaWeiboViewController.h"
#import "QQChatViewController.h"
#import "WeiChatViewController.h"
#import "AliPayViewController.h"

@interface CustomUIViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *listViewControllers;
@end

@implementation CustomUIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
//    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
////    returnButtonItem.title = @"返回";
//    returnButtonItem.title = @"";
//    self.navigationItem.backBarButtonItem = returnButtonItem;
//    self.navigationItem.hidesBackButton = YES;
    
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
    
    // 1.仿QQ界面
    [_listData addObject:@"仿QQ界面"];
    // QQMainViewController *qqMainViewController = [[QQMainViewController alloc] init];
//    UITabBarController *tabVC = [self setupTabbarController];
    QQSideBarViewController *sideBarVC = [[QQSideBarViewController alloc] init];
    [_listViewControllers addObject:sideBarVC];
    
    // 2.导航菜单学习
    [_listData addObject:@"导航菜单学习"];
    NaviMenuViewController *navmenuVC = [[NaviMenuViewController alloc] init];
    [_listViewControllers addObject:navmenuVC];
    
    // 3.仿新浪微博
    [_listData addObject:@"仿新浪微博"];
    SinaWeiboViewController *sinaVC = [[SinaWeiboViewController alloc] init];
    [_listViewControllers addObject:sinaVC];
    
    // 4.QQ聊天界面
    [_listData addObject:@"QQ聊天界面"];
    QQChatViewController *qqChatVC = [[QQChatViewController alloc] init];
    [_listViewControllers addObject:qqChatVC];
    
    // 5.仿微信
    [_listData addObject:@"仿微信"];
     WeiChatViewController *weiChatVC = [[WeiChatViewController alloc] init];
    [_listViewControllers addObject:weiChatVC];
    
    
    // 6.仿支付宝
    [_listData addObject:@"仿支付宝"];
    AliPayViewController *alipayVC = [[AliPayViewController alloc] init];
    [_listViewControllers addObject:alipayVC];
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
    if (indexPath.row == 0  || indexPath.row == 5) {
//        QQSideBarViewController *sideBarVC = [[QQSideBarViewController alloc] init];
        [self.navigationController presentViewController:vc animated:YES completion:^{
            
        }];
    } else {
        [self.navigationController pushViewController:vc animated:YES];
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
    //    cell.detailTextLabel.text = [self.listData objectForKey:[self.listData allKeys][indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

@end
