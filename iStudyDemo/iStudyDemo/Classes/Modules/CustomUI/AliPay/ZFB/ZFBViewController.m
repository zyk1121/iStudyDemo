//
//  ZFBViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/23.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "ZFBViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "ZFBTestViewController.h"
#import "ZFBTableViewCell.h"

@interface ZFBViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZFBTableViewCell *zfbCell1;
@property (nonatomic, strong) ZFBTableViewCell *zfbCell2;
@property (nonatomic, strong) NSMutableArray *cellData;


@end

@implementation ZFBViewController
{
    UIImageView *navBarHairlineImageView;// 去除黑线第二种方法
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor lightGrayColor];
//    self.view.backgroundColor = [UIColor colorWithRed:28/255.0 green:182/255.0 blue:165/255.0 alpha:1];
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    _view1.backgroundColor = [UIColor colorWithRed:37/255.0 green:192/255.0 blue:180/255.0 alpha:1];
    [self.view addSubview:_view1];
    
    UIButton *button1 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(40, 20, 40, 40)];
        [button setBackgroundImage:[UIImage imageNamed:@"10000004"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [_view1 addSubview:button1];
    
    UIButton *button2 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(140, 20, 40, 40)];
        [button setBackgroundImage:[UIImage imageNamed:@"10000006"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [_view1 addSubview:button2];
    
    
    UIButton *button3 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(240, 20, 40, 40)];
        [button setBackgroundImage:[UIImage imageNamed:@"10000004"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [_view1 addSubview:button3];
    
    
    _cellData = [[NSMutableArray alloc] init];
    [self setupUI];

}

- (void)buttonClick
{
    ZFBTestViewController *vc = [[ZFBTestViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
//    self.view.backgroundColor = [UIColor colorWithRed:37/255.0 green:192/255.0 blue:180/255.0 alpha:1];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    navBarHairlineImageView = [self findHairlineImageViewUnder:navigationBar];
    // white.png图片自己下载个纯白色的色块，或者自己ps做一个
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    // 28 182 165
//    [navigationBar setShadowImage:[UIImage new]];
    // UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    /*去除黑线第一种方法  ，但是有一个缺陷-删除了translucency(半透明)
    // white.png图片自己下载个纯白色的色块，或者自己ps做一个
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"white.png"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
     */
    
    
    navBarHairlineImageView.hidden = YES;
}


- (void)viewWillDisappear:(BOOL)animated
{
    navBarHairlineImageView.hidden = NO;
}


#pragma mark - tableview

- (void)setupUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, SCREEN_HEIGHT - 49-80-64)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    // 中间再加一个banner广告view即可
    _zfbCell1 = [[ZFBTableViewCell alloc] initWithIcons:nil];
    _zfbCell2 = [[ZFBTableViewCell alloc] initWithIcons:nil];
    _zfbCell1.vc = self;
    _zfbCell2.vc =  self;
    [_cellData addObject:_zfbCell1];
    [_cellData addObject:_zfbCell2];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _cellData.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *reuseIdetify = @"tableViewCellIdetify";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
//    if (!cell) {
//        cell = [[ZFBTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.showsReorderControl = YES;
//    }
    
//    cell.textLabel.backgroundColor = [UIColor clearColor];
    UITableViewCell *cell = _cellData[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ZFBTableViewCell 是基类，另外两种，一种是collectionCell，一种是bannerCell（即可完成像支付宝一样的功能）
    ZFBTableViewCell *cell = _cellData[indexPath.row];
    return cell.cellHeight;
}

@end
