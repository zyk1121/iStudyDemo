//
//  QuartzCoreViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/8.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "QuartzCoreViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "SimpleAnimationViewController.h"
#import "BasicAnimationViewController.h"
#import "KeyFrameViewController.h"
#import "TransitionViewController.h"

// 动画介绍：http://blog.sina.com.cn/s/blog_8d1bc23f0102vqpa.html
/*
 在iOS中随处都可以看到绚丽的动画效果，实现这些动画的过程并不复杂，今天将带大家一窥iOS动画全貌。在这里你可以看到iOS中如何使用图层精简非交互式绘图，如何通过核心动画创建基础动画、关键帧动画、动画组、转场动画，如何通过UIView的装饰方法对这些动画操作进行简化等。在今天的文章里您可以看到动画操作在iOS中是如何简单和高效，很多原来想做但是苦于没有思路的动画在iOS中将变得越发简单：
 
 CALayer
 CALayer简介
 CALayer常用属性
 CALayer绘图
 Core Animation
 基础动画
 关键帧动画
 动画组
 转场动画
 逐帧动画
 UIView动画封装
 基础动画
 关键帧动画 
 转场动画
 
 */

@interface QuartzCoreViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *listViewControllers;

@end

@implementation QuartzCoreViewController

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
    
    // 1.简单动画
    [_listData addObject:@"简单动画"];
    SimpleAnimationViewController *simpleVC = [[SimpleAnimationViewController alloc] init];
    [_listViewControllers addObject:simpleVC];
    
    // 2.BasicAnimation
    [_listData addObject:@"BasicAnimation"];
    BasicAnimationViewController *basicVC = [[BasicAnimationViewController alloc] init];
    [_listViewControllers addObject:basicVC];
    
    // 3.Keyframe
    [_listData addObject:@"Keyframe"];
    KeyFrameViewController *keyframeVC = [[KeyFrameViewController alloc] init];
    [_listViewControllers addObject:keyframeVC];
    
    // 4.GroupAnimation
    [_listData addObject:@"GroupAnimation"];
    BasicAnimationViewController *groupVC = [[BasicAnimationViewController alloc] init];
    [_listViewControllers addObject:groupVC];
    
    // 5.Transition
    [_listData addObject:@"Transition"];
    TransitionViewController *transitionVC = [[TransitionViewController alloc] init];
    [_listViewControllers addObject:transitionVC];
    

    
    /*
     自定义view
     
     init
     {
     self.translatesAutoresizingMaskIntoConstraints = NO;
     }
     
     
     - (void)updateConstraints
     {
     [self.moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
     make.center.equalTo(self);
     }];
     
     [self.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
     make.center.equalTo(self);
     }];
     
     [super updateConstraints];
     }
     
     + (BOOL)requiresConstraintBasedLayout
     {
     return YES;
     }
     
     */
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
//    if (indexPath.row == 0  || indexPath.row == 5) {
//        //        QQSideBarViewController *sideBarVC = [[QQSideBarViewController alloc] init];
//        [self.navigationController presentViewController:vc animated:YES completion:^{
//            
//        }];
//    } else {
//        [self.navigationController pushViewController:vc animated:YES];
//    }
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
    return 50;
}


@end
