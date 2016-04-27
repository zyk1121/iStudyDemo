//
//  JavaScriptViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "JavaScriptViewController.h"

#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"

@interface JavaScriptViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;

@end

@implementation JavaScriptViewController

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
    
    [_listData addObject:@"JavaScript基础"];
    [_listData addObject:@"JS HTML DOM"];
    [_listData addObject:@"JavaScript对象"];
    [_listData addObject:@"JS Window"];
    [_listData addObject:@"JS 库"];
    [_listData addObject:@"JavaScript高级"];
    
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
            [self test0];
            break;
        case 1:
            [self test1];
            break;
        case 2:
            [self test2];
            break;
        case 3:
            [self test3];
            break;
        case 4:
            [self test4];
            break;
        case 5:
            [self test5];
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
    //    cell.detailTextLabel.text = [self.listData objectForKey:[self.listData allKeys][indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - private method

/*
 
 [_listData addObject:@"JavaScript基础"];
 [_listData addObject:@"JS HTML DOM"];
 [_listData addObject:@"JavaScript对象"];
 [_listData addObject:@"JS Window"];
 [_listData addObject:@"JS 库"];
 [_listData addObject:@"JavaScript高级"];
 
 */
- (void)test0
{
    //
}
- (void)test1
{
    //
}
- (void)test2
{
    //
}
- (void)test3
{
    //
}
- (void)test4
{
    //
}
- (void)test5
{
    //
}

@end
