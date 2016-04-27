//
//  HTMLCSSViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "HTMLCSSViewController.h"

#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "LEDWebViewController.h"


@interface HTMLCSSViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;

@end

@implementation HTMLCSSViewController

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
    
    [_listData addObject:@"HTML"];
    [_listData addObject:@"CSS"];

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
    switch (indexPath.row) {
        case 0:
            [self test0];
            break;
        case 1:
            [self test1];
            break;
        default:
            break;
    }
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

- (void)test0
{
    // HTML
    NSURL *urlPath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"htmltest" ofType:@"html"]];
    LEDWebViewController *vc = [[LEDWebViewController alloc] initWithURL:urlPath];
    [self.navigationController pushViewController:vc animated:YES];
//    NSURL *urlPath = [NSURL fileURLWithPath:@"/Users/zhangyuanke/Desktop/Projects/iOS/iStudyDemo/iStudyDemo/iStudyDemo/Classes/Modules/HTML_CSS/html/htmltest.html"];
//    LEDWebViewController *vc = [[LEDWebViewController alloc] initWithURL:urlPath];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)test1
{
    // CSS
    NSURL *urlPath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"htmlcss" ofType:@"html"]];
    LEDWebViewController *vc = [[LEDWebViewController alloc] initWithURL:urlPath];
    [self.navigationController pushViewController:vc animated:YES];
    //    NSURL *urlPath = [NSURL fileURLWithPath:@"/Users/zhangyuanke/Desktop/Projects/iOS/iStudyDemo/iStudyDemo/iStudyDemo/Classes/Modules/HTML_CSS/html/htmlcss.html"];
    //    LEDWebViewController *vc = [[LEDWebViewController alloc] initWithURL:urlPath];
    //    [self.navigationController pushViewController:vc animated:YES];
}

@end

