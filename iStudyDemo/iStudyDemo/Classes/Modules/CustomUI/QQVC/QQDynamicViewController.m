//
//  QQDynamicViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/17.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "QQDynamicViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "UIView+SHCZExt.h"
#import "QQSideBarViewController.h"
#import "QQSettingViewController.h"
#import "QQTabbarViewController.h"

@implementation QQDynamicViewController

- (void)viewDidLoad {
    self.title = @"动态";
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupData];
    [self setupUI];
    [self.view updateConstraintsIfNeeded];
}


- (void)viewDidAppear:(BOOL)animated
{
    //    [self setHidesBottomBarWhenPushed:YES];
    [self.tabbarVC.sidebarVC addPanGesture];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.tabbarVC.sidebarVC removePanGesture];
    //    [self setHidesBottomBarWhenPushed:NO];
}

#pragma mark - masonry

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
}

#pragma mark - private method

- (void)setupUI
{
    self.navigationController.navigationBar.backgroundColor = [UIColor lightGrayColor];
    // titleview
    //    分段控件
    //    UISegmentedControl *segmentC = [[UISegmentedControl alloc]initWithItems:@[@"消息",@"电话"]];
    //    segmentC.w = 120;
    //    segmentC.selectedSegmentIndex = 0;
    //    [segmentC addTarget:self action:@selector(segmentCClicked:) forControlEvents:UIControlEventValueChanged];
    //
    //    self.navigationItem.titleView = segmentC;
    // right buttonitem
    //    UIButton *cancelBtn=[UIButton buttonWithType:UIBarButtonSystemItemCancel];
    ////    [searchBtn setImage:[UIImage imageNamed:@"sample.png"] forState:UIControlStateNormal];
    ////    UIButton *timeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    ////    [timeBtn  setImage:[UIImage imageNamed:@"sample.png"] forState:UIControlStateNormal];
    //    UIButton *moreBtn=[UIButton buttonWithType:UIBarButtonSystemItemDone];
    ////    [moreBtn setImage:[UIImage imageNamed:@"sample.png"] forState:UIControlStateNormal];
    
    //
    //    UIBarButtonItem *bardoneBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(bardoneBtnClicked)];
    //    UIBarButtonItem *barcancelBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(barcancelBtnClicked)];
    UIBarButtonItem *addButton=[[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonClicked)];
    NSArray *rightBtns=[NSArray arrayWithObjects:addButton, nil];
    self.navigationItem.rightBarButtonItems=rightBtns;
    
    // left buttom item
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    leftView.layer.cornerRadius = 20;
    leftView.image = [UIImage imageNamed:@"hcw.png"];
    //    [backButton setBackgroundImage:[UIImage imageNamed:@"hcw.png"] forState:UIControlStateNormal];
    //    [backButton setBackgroundImage:[UIImage imageNamed:@"hcw.png"] forState:UIControlStateHighlighted];
    backButton.layer.cornerRadius = 20;
    [backButton addSubview:leftView];
    [backButton addTarget:self action:@selector(doClickBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    //  搜索框
    UISearchBar *sB=[[UISearchBar alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,84)];
    [sB setPlaceholder:@"搜索电影/音乐/商品..."];
    
    [self.tableView addSubview:sB];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setupData
{
    
}

#pragma mark - event
- (void)addButtonClicked
{
    
}

- (void)doClickBackAction:(UIButton *)button
{
    [self.tabbarVC.sidebarVC maskViewClicked];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 16;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        return [UITableViewCell new];
    }
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.imageView.image=[UIImage imageNamed:@"kov"];
    cell.textLabel.text=@"空间";
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 84;
    }
    return 44;
}

@end
