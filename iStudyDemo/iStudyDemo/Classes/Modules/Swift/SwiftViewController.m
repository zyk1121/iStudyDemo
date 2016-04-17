//
//  SwiftViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "SwiftViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "SwiftBasicViewController.h"
#import "SwiftBasicPartViewController.h"
#import "SwiftClassViewController.h"
#import "SwfitExtensionProtocolViewController.h"
#import "SwiftFoundationViewController.h"
#import "SwiftMemoryManagerViewController.h"
#import "SwiftFunctionClosureViewController.h"
#import "SwiftUIViewController.h"
#import "SwiftProjectViewController.h"
#import "SwiftThirdPartViewController.h"

// http://blog.csdn.net/huangchentao/article/details/35278663
// http://blog.csdn.net/mengxiangone/article/details/40712369

@interface SwiftViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *listViewControllers;

@end

@implementation SwiftViewController

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
    
    // 1.Swift-OC基础
    [_listData addObject:@"Swift-OC基础(互相调用)"];
    SwiftBasicViewController *swiftBasicViewController = [[SwiftBasicViewController alloc] init];
    [_listViewControllers addObject:swiftBasicViewController];
    // 2.Swift基础
    [_listData addObject:@"Swift基础"];
    SwiftBasicPartViewController *swiftBasicPartViewController = [[SwiftBasicPartViewController alloc] init];
    [_listViewControllers addObject:swiftBasicPartViewController];
    // 3.Swift函数闭包
    [_listData addObject:@"Swift函数闭包"];
    SwiftFunctionClosureViewController *swiftFunctionClosureViewController = [[SwiftFunctionClosureViewController alloc] init];
    [_listViewControllers addObject:swiftFunctionClosureViewController];
    // 4.Swift面向对象
    [_listData addObject:@"Swift面向对象"];
    SwiftClassViewController *swiftClassViewController = [[SwiftClassViewController alloc] init];
    [_listViewControllers addObject:swiftClassViewController];
    // 5.Swift扩展和协议
    [_listData addObject:@"Swift扩展和协议"];
    SwfitExtensionProtocolViewController *swiftExtensionProtocolViewController = [[SwfitExtensionProtocolViewController alloc] init];
    [_listViewControllers addObject:swiftExtensionProtocolViewController];
    // 6.Swift内存管理
    [_listData addObject:@"Swift内存管理"];
    SwiftMemoryManagerViewController *swiftmemoryViewController = [[SwiftMemoryManagerViewController alloc] init];
    [_listViewControllers addObject:swiftmemoryViewController];
    // 7.Swift Foundation框架
    [_listData addObject:@"Swift Foundation框架"];
    SwiftFoundationViewController *swiftFoundationViewController = [[SwiftFoundationViewController alloc] init];
    [_listViewControllers addObject:swiftFoundationViewController];
    // 8.Swift 简单UI
    [_listData addObject:@"Swift 简单UI"];
    SwiftUIViewController *swiftuiViewController = [[SwiftUIViewController alloc] init];
    [_listViewControllers addObject:swiftuiViewController];
    // 9.Swift第三方框架
    [_listData addObject:@"Swift第三方框架"];
    SwiftThirdPartViewController *swiftthirdpartViewController = [[SwiftThirdPartViewController alloc] init];
    [_listViewControllers addObject:swiftthirdpartViewController];
    // 10.Swift项目实战
    [_listData addObject:@"Swift项目实战"];
    SwiftProjectViewController *swiftprojectViewController = [[SwiftProjectViewController alloc] init];
    [_listViewControllers addObject:swiftprojectViewController];
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
