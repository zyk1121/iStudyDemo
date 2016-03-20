//
//  QQContractViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/17.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "QQContractViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "UIView+SHCZExt.h"
#import "QQSideBarViewController.h"
#import "QQSettingViewController.h"
#import "QQTabbarViewController.h"

@interface QQContractViewController ()<UIActionSheetDelegate>

@end

@implementation QQContractViewController

- (void)viewDidLoad {
    self.title = @"联系人";
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupData];
    [self setupUI];
    [self.view updateConstraintsIfNeeded];
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
    UIBarButtonItem *addButton=[[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonClicked)];
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
}

- (void)setupData
{
    
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

#pragma mark - event
- (void)addButtonClicked
{
    /*
     在开发过程中，发现有时候UIActionSheet的最后一项点击失效，点最后一项的上半区域时有效，这是在特定情况下才会发生，这个场景就是试用了UITabBar的时候才有。解决办法：
     在showView时这样使用，[actionSheet showInView:[UIApplication sharedApplication].keyWindow];或者[sheet showInView:[AppDelegate sharedDelegate].tabBarController.view];这样就不会发生遮挡现象了。
     */
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"title,nil时不显示"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"确定"
                                  otherButtonTitles:@"第一项", @"第二项",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"您点击了第%ld个按钮",buttonIndex);
}

- (void)doClickBackAction:(UIButton *)button
{
    [self.tabbarVC.sidebarVC maskViewClicked];
}

@end
