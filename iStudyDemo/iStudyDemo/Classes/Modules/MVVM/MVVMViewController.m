//
//  MVVMViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "DSActivityView.h"
#import "LEDProvincesDomain.h"
#import "MVVMViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "UIKitMacros.h"
#import "masonry.h"
#import "LEDProvince.h"

@interface MVVMViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) LEDMVVMViewModel* viewModel;

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* listData;

@end

@implementation MVVMViewController

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
}
- (void)bindViewModel
{
    /*
    @weakify(self);
    RAC(self, title) = [RACObserve(self, viewModel.title)
                        map:^id(NSString* value) {
                            return [value length] ? value : @"我的现金券";
                        }];
    RAC(self, navigationItem.rightBarButtonItem) = [RACObserve(self, viewModel.helpInfoTitle)
                                                    map:^id(NSString* value) {
                                                        @strongify(self);
                                                        value = [value length] ? value : @"使用帮助";
                                                        return [UIBarButtonItem spk_barButtonItemWithTitle:value
                                                                                                    target:self
                                                                                                    action:@selector(helpInfoButtonClick:)];
                                                    }];
    RAC(self.tableView, tableFooterDataSource) = RACObserve(self, viewModel.fetchedResultsController);
    RAC(self.tableView, listDataSource) = RACObserve(self, viewModel.fetchedResultsController);
    RAC(self.tableView, enableLoadMore) = RACObserve(self, viewModel.hasMoreList);
    RAC(self.emptyPromptView, hyperlinkDesc) = RACObserve(self, viewModel.descForCashTicketsObtainInstructions);
    [RACObserve(self.viewModel, hasCashTicketsData) subscribeNext:^(NSNumber *hasCashTicketsData) {
        @strongify(self);
        if ([hasCashTicketsData boolValue]) {
            [self showTableView];
        } else {
            [self showEmptyPromptView];
        }
    }];
    self.tableView.loadMoreCommand = self.viewModel.loadMoreCommand;
    [self.viewModel.loadCommand.errors subscribeNext:^(SAKError *error) {
        @strongify(self);
        [self showNetworkPromptView];
        [error mtw_errorProcess];
    }];
    [self.viewModel.loadMoreCommand.errors subscribeNext:^(SAKError *error) {
        [error mtw_errorProcess];
    }];
     */
    
    @weakify(self);
    [RACObserve(self.viewModel, provinces) subscribeNext:^(LEDProvincesDomain *provinces) {
        @strongify(self);
        if (provinces && [provinces.provinces count] > 0) {
            [self.listData removeAllObjects];
            [provinces.provinces enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                LEDProvince *province = (LEDProvince *)obj;
                if (province && [province isKindOfClass:[LEDProvince class]]) {
                    [self.listData addObject:province.name];
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

@end
