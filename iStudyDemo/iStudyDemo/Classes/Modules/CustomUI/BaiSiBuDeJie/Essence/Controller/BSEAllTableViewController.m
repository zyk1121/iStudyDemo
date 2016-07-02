//
//  BSEAllTableViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/2.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSEAllTableViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "BSETitleButton.h"
#import "UIView+Extension.h"
#import "BSTopic.h"
#import "BSRequest.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "BSMeSequare.h"
#import "UIButton+WebCache.h"
#import "BSTopic.h"
#import "MJExtension.h"

static NSString *commonReuseIdentifier = @"commonReuseIdentifier";

@interface BSEAllTableViewController ()

@property (nonatomic, strong) NSMutableArray *topicData;
@property (nonatomic, copy) NSString *maxtime;

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation BSEAllTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupUI];
    [self setupRefresh];
}

- (void)setupRefresh
{
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self refreshData];
//    }];
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    refreshHeader.automaticallyChangeAlpha = YES;
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header= refreshHeader;
    [self.tableView.mj_header beginRefreshing];
    
    
    // footview
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
}

- (void)initData
{
    // register cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:commonReuseIdentifier];
    
    // 内边距
    self.tableView.contentInset = UIEdgeInsetsMake(64 + 44, 0, 49, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    _manager = [AFHTTPSessionManager manager];
    _topicData = [[NSMutableArray alloc] init];
    
}

- (void)refreshData
{
    // 取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // do request
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"list" forKey:@"a"];
    [params setObject:@"data" forKey:@"c"];
    [params setObject:@"0" forKey:@"page"];
    //    [params setObject:@"1" forKey:@"type"];
    [SVProgressHUD showWithStatus:@"加载中..."];
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        if (responseObject) {
            NSArray *tempArray = responseObject[@"list"];
            self.topicData = [BSTopic mj_objectArrayWithKeyValuesArray:tempArray];
            self.maxtime = responseObject[@"info"][@"maxtime"];
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        self.topicData = nil;
        [self.tableView reloadData];
    }];

//    [BSRequest doRequestWithParams:params success:^(NSArray *response) {
//        [SVProgressHUD dismiss];
//        [self.tableView.mj_header endRefreshing];
//        if (response) {
//            self.topicData = response;
//            [self.tableView reloadData];
//        }
//    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
//        [self.tableView.mj_header endRefreshing];
//        self.topicData = nil;
//        [self.tableView reloadData];
//    }];
}

- (void)loadMoreData
{
    // 取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // do request
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"list" forKey:@"a"];
    [params setObject:@"data" forKey:@"c"];
    [params setObject:self.maxtime forKey:@"maxtime"];
    //    [params setObject:@"1" forKey:@"type"];
    [SVProgressHUD showWithStatus:@"加载中..."];
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_footer endRefreshing];
        if (responseObject) {
            NSArray *tempArray = responseObject[@"list"];
//            self.topicData = [BSTopic mj_objectArrayWithKeyValuesArray:tempArray];
            [self.topicData addObjectsFromArray:[BSTopic mj_objectArrayWithKeyValuesArray:tempArray]];
            self.maxtime = responseObject[@"info"][@"maxtime"];
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_footer endRefreshing];
        self.topicData = nil;
        [self.tableView reloadData];
    }];

}

- (void)setupUI
{

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.topicData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commonReuseIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commonReuseIdentifier];
    }
    // Configure the cell...
    BSTopic *topic = self.topicData[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",topic.name];
    
    return cell;
}

@end
