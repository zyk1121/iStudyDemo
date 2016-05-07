//
//  DesignPatternsViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/5/3.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "DesignPatternsViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "LEDWebViewController.h"
#import "DPPrincipleViewController.h"
#import "DPStructuralViewController.h"
#import "DPCreationalViewController.h"
#import "DPBehavioralViewController.h"
#import "DPUMLViewController.h"

// http://m.blog.csdn.net/article/details?id=9159589
// http://www.runoob.com/design-pattern/abstract-factory-pattern.html

@interface DesignPatternsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;

@end

@implementation DesignPatternsViewController

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
    
    [_listData addObject:@"设计模式六大原则"];
    [_listData addObject:@"创建型模式(Creational Patterns)"];
    [_listData addObject:@"结构型模式(Structual Patterns)"];
    [_listData addObject:@"行为型模式(Behavioral Patterns)"];
    [_listData addObject:@"UML类图示例"];
    
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
    NSString *methodName = [NSString stringWithFormat:@"test%ld",indexPath.row];
    [self performSelector:NSSelectorFromString(methodName) withObject:nil afterDelay:0];
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

- (void)test0
{
    DPPrincipleViewController *vc = [[DPPrincipleViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)test1
{
    DPCreationalViewController *vc = [[DPCreationalViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)test2
{
    DPStructuralViewController *vc = [[DPStructuralViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)test3
{
    DPBehavioralViewController *vc = [[DPBehavioralViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)test4
{
    DPUMLViewController *vc = [[DPUMLViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
