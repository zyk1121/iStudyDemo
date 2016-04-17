//
//  SwiftBasicPartViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/17.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "SwiftBasicPartViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"

#import "iStudyDemo-swift.h"

@interface SwiftBasicPartViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *listViewControllers;

@end

@implementation SwiftBasicPartViewController

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
    
    // 1.OC 语法
    [_listData addObject:@"标志符，关键字,常量和变量,注释和表达式"];
    // 2.OC 基本运算符
    [_listData addObject:@"基本运算符"];
    // 3.基本数据类型
    [_listData addObject:@"基本数据类型"];
    // 4.字符和字符串
    [_listData addObject:@"字符和字符串"];
    // 5.控制语句
    [_listData addObject:@"控制语句"];
    // 6.集合
    [_listData addObject:@"集合"];
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
    [self testForRow:indexPath.row];
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

#pragma mark - private method

- (void)testForRow:(NSUInteger)row
{
    NSString *methodName = [NSString stringWithFormat:@"OC_test%ld",row];
    [self performSelector:NSSelectorFromString(methodName)];
}

// 基本语法
- (void)OC_test0
{
    SwiftBasicPart *basicPart = [[SwiftBasicPart alloc] init];
    [basicPart test0];
}
- (void)OC_test1
{
    SwiftBasicPart *basicPart = [[SwiftBasicPart alloc] init];
    [basicPart test1];
}
- (void)OC_test2
{
    SwiftBasicPart *basicPart = [[SwiftBasicPart alloc] init];
    [basicPart test2];
}
//
- (void)OC_test3
{
    SwiftBasicPart *basicPart = [[SwiftBasicPart alloc] init];
    [basicPart test0];
}
- (void)OC_test4
{
    SwiftBasicPart *basicPart = [[SwiftBasicPart alloc] init];
    [basicPart test1];
}
- (void)OC_test5
{
    SwiftBasicPart *basicPart = [[SwiftBasicPart alloc] init];
    [basicPart test2];
}

@end

