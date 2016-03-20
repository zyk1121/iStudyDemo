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
}

//- (UITabBarController *)setupTabbarController
//{
//     UITabBarController *tabVC = (UITabBarController *)[[QQTabbarViewController alloc] init];
//    
//
//    
// 
//    return tabVC;
//}



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
    if (indexPath.row == 0) {
        //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
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
