//
//  SwiftBasicPartViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/17.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "SwiftMemoryManagerViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"

#import "iStudyDemo-swift.h"

@interface SwiftMemoryManagerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *listViewControllers;

@end

@implementation SwiftMemoryManagerViewController

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
    
    // 循环引用
    [_listData addObject:@"强循环引用"];
    [_listData addObject:@"弱引用weak"];
    [_listData addObject:@"无主引用unowned"];
    [_listData addObject:@"闭包中的强循环引用"];
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

//
- (void)OC_test0
{
    SwiftMemoryManager *mem = [[SwiftMemoryManager alloc] init];
    [mem test1];
}
- (void)OC_test1
{
    SwiftMemoryManager *mem = [[SwiftMemoryManager alloc] init];
    [mem test2];
}
- (void)OC_test2
{
    SwiftMemoryManager *mem = [[SwiftMemoryManager alloc] init];
    [mem test3];
}
- (void)OC_test3
{
    SwiftMemoryManager *mem = [[SwiftMemoryManager alloc] init];
    [mem test4];
}

@end

