//
//  BSEPictureTableViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/2.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSEPictureTableViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "BSETitleButton.h"
#import "UIView+Extension.h"

static NSString *commonReuseIdentifier = @"commonReuseIdentifier";

@interface BSEPictureTableViewController ()

@end

@implementation BSEPictureTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupUI];
}

- (void)initData
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:commonReuseIdentifier];
    self.tableView.contentInset = UIEdgeInsetsMake(64 + 44, 0, 49, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}

- (void)setupUI
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commonReuseIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commonReuseIdentifier];
    }
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    
    return cell;
}

@end