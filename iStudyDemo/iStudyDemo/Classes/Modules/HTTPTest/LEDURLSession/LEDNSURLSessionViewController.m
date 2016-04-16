//
//  LEDNSURLSessionViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/16.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDNSURLSessionViewController.h"
#import <AFNetworking.h>
#import "TestDomainObject.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "LEDProvincesDomain.h"
#import "MVVMViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "UIKitMacros.h"
#import "masonry.h"
#import "LEDProvince.h"
#import "DSActivityView.h"
#import "LEDMVVMViewModel.h"
#import "LEDDownload/LEDDownloadManager.h"
#import "LEDDownload/LEDDownloadManager2.h"

@interface LEDNSURLSessionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) LEDMVVMViewModel* viewModel;

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* listData;
@property (nonatomic, strong) NSMutableArray* listProvinceData;

@end

@implementation LEDNSURLSessionViewController

#pragma mark - public method

- (instancetype)initWithViewModel:(LEDMVVMViewModel*)viewModel
{
    self = [super init];
    if (self) {
        _viewModel = viewModel;
    }
    return self;
}

// viewmodel 也可以内部创建
- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewModel = [[LEDMVVMViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self setupData];
    [self bindViewModel];
    //    [self executeLoadCommand];
    [self.view setNeedsUpdateConstraints];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self executeLoadCommand];
}

#pragma mark - masonry

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - private method

- (void)setupUI
{
    _tableView = ({
        UITableView* tableview = [[UITableView alloc] init];
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
    _listProvinceData = [[NSMutableArray alloc] init];
}
- (void)bindViewModel
{
    @weakify(self);
    [RACObserve(self.viewModel, provinces) subscribeNext:^(LEDProvincesDomain *provinces) {
        @strongify(self);
        if (provinces && [provinces.provinces count] > 0) {
            [self.listData removeAllObjects];
            [self.listProvinceData removeAllObjects];
            [provinces.provinces enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                LEDProvince *province = (LEDProvince *)obj;
                if (province && [province isKindOfClass:[LEDProvince class]]) {
                    [self.listData addObject:province.name];
                    [self.listProvinceData addObject:province];
                }
            }];
            [self.tableView reloadData];
        }
    }];
}

- (void)executeLoadCommand
{
    [DSBezelActivityView activityViewForView:self.tableView withLabel:@"加载中..."];
    [[self.viewModel.loadCommand execute:nil] subscribeError:^(NSError* error) {
        [DSBezelActivityView removeViewAnimated:YES];
    }
                                                   completed:^{
                                                       [DSBezelActivityView removeViewAnimated:YES];
                                                   }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LEDProvince *province = self.listProvinceData[indexPath.row];
    if (province.url && [[province.url absoluteString] length]) {
//        [[LEDDownloadManager sharedManager] addDownloadWithURL:province.url];
//        [[LEDDownloadManager sharedManager] startDownloadWithURL:province.url];
        [[LEDDownloadManager2 sharedManager] startDownloadWithURL:province.url];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:@"没有要下载的数据" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* reuseIdetify = @"tableViewCellIdetify";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showsReorderControl = YES;
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [self.listData objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 50;
}

- (void)dealloc
{
    [[LEDDownloadManager2 sharedManager] cancelAll];
}

@end
