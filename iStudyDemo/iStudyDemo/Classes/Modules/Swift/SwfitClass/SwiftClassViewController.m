//
//  SwiftBasicPartViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/17.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "SwiftClassViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"

#import "iStudyDemo-swift.h"

@interface SwiftClassViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *listViewControllers;

@end

@implementation SwiftClassViewController

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
    
    // 1.枚举
    [_listData addObject:@"枚举enum"];
    [_listData addObject:@"结构体和类定义struct－class"];
    [_listData addObject:@"可选类型与可选链"];
    [_listData addObject:@"属性和下标"];
    [_listData addObject:@"方法"];
    [_listData addObject:@"构造与析构"];
    [_listData addObject:@"继承"];
    
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

// 枚举
- (void)OC_test0
{
    SwiftClassClass *testSwift = [[SwiftClassClass alloc] init];
    [testSwift test1];
}

// 结构体和类定义
- (void)OC_test1
{
    SwiftClassClass *testSwift = [[SwiftClassClass alloc] init];
    [testSwift test2];
}

// 可选类型与可选链
- (void)OC_test2
{
    SwiftClassClass *testSwift = [[SwiftClassClass alloc] init];
    [testSwift test3];
}

// 属性和下标
- (void)OC_test3
{
    SwiftClassClass *testSwift = [[SwiftClassClass alloc] init];
    [testSwift test4];
}

// 方法
- (void)OC_test4
{
    SwiftClassClass *testSwift = [[SwiftClassClass alloc] init];
    [testSwift test5];
}

// 构造与析构
- (void)OC_test5
{
    SwiftClassClass *testSwift = [[SwiftClassClass alloc] init];
    [testSwift test6];
}

// 继承
- (void)OC_test6
{
    SwiftClassClass *testSwift = [[SwiftClassClass alloc] init];
    [testSwift test7];
}

@end

