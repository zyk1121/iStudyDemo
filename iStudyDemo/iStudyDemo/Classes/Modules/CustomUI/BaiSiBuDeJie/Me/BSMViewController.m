//
//  BSMViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/6/25.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSMViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "UIBarButtonItem+BSBDJ.h"
#import "BSMeFootView.h"

@interface BSMViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BSMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的";
    [self setupUI];
    [self.view setNeedsUpdateConstraints];
}

- (void)setupUI
{
    // 导航栏右边按钮
//    UIBarButtonItem *settingBtn = ({
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setImage:[UIImage imageNamed:@"mine-setting-icon"] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"mine-setting-icon-click"] forState:UIControlStateHighlighted];
//        UIImage *image = [button imageForState:UIControlStateNormal];
//        button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//        [button sizeToFit];
//        [button addTarget:self action:@selector(settingBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//        [[UIBarButtonItem alloc] initWithCustomView:button];
//    });
//    UIBarButtonItem *nightStyleBtn = ({
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setImage:[UIImage imageNamed:@"mine-moon-icon"] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"mine-moon-icon-click"] forState:UIControlStateHighlighted];
//        UIImage *image = [button imageForState:UIControlStateNormal];
//        button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//        [button sizeToFit];
//        [button addTarget:self action:@selector(nightStyleBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//        [[UIBarButtonItem alloc] initWithCustomView:button];
//    });
    
    UIBarButtonItem *settingBtn = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingBtnClicked)];
    
    UIBarButtonItem *nightStyleBtn = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(nightStyleBtnClicked)];
    
    NSArray *rightBtns=[NSArray arrayWithObjects:settingBtn,nightStyleBtn, nil];
    self.navigationItem.rightBarButtonItems=rightBtns;
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView;
    });
    
    BSMeFootView *footView = [[BSMeFootView alloc] init];
    footView.backgroundColor = [UIColor lightGrayColor];
    footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    self.tableView.tableFooterView = footView;
    
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - tableview delegate & datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
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
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"登录/注册";
        cell.imageView.image = [UIImage imageNamed:@"setup-head-default"];
    } else {
        cell.textLabel.text = @"离线下载";
        cell.imageView.image = nil;// 防止循环利用
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - navibar clicked

- (void)settingBtnClicked
{
    // 设置按钮点击
    UIViewController *vc = [[UIViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)nightStyleBtnClicked
{
    // 夜间模式点击
    UIViewController *vc = [[UIViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
