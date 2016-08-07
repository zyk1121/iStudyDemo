//
//  YUKModalViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/8/7.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "YUKModalViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "YUKModalView.h"
#import "YUKToastView.h"
#import "YUKAlertView.h"

// 可以考虑封装UItableview 和  UICollectionView ，视图弹窗，modal 等

@interface YUKModalViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *listViewControllers;
@end

@implementation YUKModalViewController

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
    _listViewControllers = [[NSMutableArray alloc] init];
    
    // 1.ModalView
    [_listData addObject:@"ModalView弹窗"];
    [_listData addObject:@"Toast(不适合)"];
    [_listData addObject:@"AlertView"];
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
//    UIViewController *vc = [self.listViewControllers objectAtIndex:indexPath.row];
//    vc.title = [self.listData objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
    
    [self procssWithRow:indexPath.row];
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

- (void)procssWithRow:(NSUInteger)row
{
    NSString *methodName = [NSString stringWithFormat:@"test%ld",row];
    [self performSelector:NSSelectorFromString(methodName) withObject:nil afterDelay:0];
}

- (void)test0
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 100, SCREEN_HEIGHT / 2 - 100, 200, 200)];
    view.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    view.layer.cornerRadius = 10;
    [YUKModalView showWithCustomView:view delegate:nil type:YUKModalViewTypeCustom];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 100, SCREEN_HEIGHT / 2 - 100, 200, 200)];
//    view2.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    view2.layer.cornerRadius = 10;
    view2.backgroundColor = [UIColor redColor];
    [YUKModalView showWithCustomView:view2 delegate:nil type:YUKModalViewTypeCustom forced:YES];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [YUKModalView dismiss];
    });
    
}

- (void)test1
{
    [YUKToastView showMessage:@"123456" duration:1 position:YUKToastViewPositionBottom];
}

- (void)test2
{
//    [YUKAlertView showWithTitle:@"title" message:@"message" delegate:nil buttonTitles:nil];
    YUKAlertView *alertView = [[YUKAlertView alloc] initWithTitle:@"titletitletitletitletitletitletitletitletitletitle" message:@"message" delegate:nil buttonTitles:nil];
    [alertView show];
    
}

@end
