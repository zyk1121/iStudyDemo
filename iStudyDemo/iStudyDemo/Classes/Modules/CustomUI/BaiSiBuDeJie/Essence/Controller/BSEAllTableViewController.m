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

static NSString *commonReuseIdentifier = @"commonReuseIdentifier";

@interface BSEAllTableViewController ()

@property (nonatomic, strong) NSArray *topicData;

@end

@implementation BSEAllTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupUI];
}

- (void)initData
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:commonReuseIdentifier];
    // 内边距
    self.tableView.contentInset = UIEdgeInsetsMake(64 + 44, 0, 49, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    // do request
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"list" forKey:@"a"];
    [params setObject:@"data" forKey:@"c"];
    [params setObject:@"0" forKey:@"page"];
//    [params setObject:@"1" forKey:@"type"];
    [SVProgressHUD showWithStatus:@"加载中..."];
    [BSRequest doRequestWithParams:params success:^(NSArray *response) {
        [SVProgressHUD dismiss];
        if (response) {
            self.topicData = response;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        self.topicData = nil;
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
