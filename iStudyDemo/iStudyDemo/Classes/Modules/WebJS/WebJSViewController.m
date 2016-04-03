//
//  WebJSViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "WebJSViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "LEDWebViewController.h"
#import "LEDPortal.h"

@interface WebJSViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;

@end

@implementation WebJSViewController

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
    
    [_listData addObject:@"LEDWebViewController"];
    [_listData addObject:@"LED Portal WebView"];
    [_listData addObject:@"i版本调起native页面"];
    [_listData addObject:@"i版本调起i版页面"];
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
            [self testLEDWebViewController];
            break;
        case 1:
            [self testLEDPortalWebViewController];
            break;
        case 2:
            [self testiToNative];
            break;
        case 3:
            [self testiToi];
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
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - private

- (void)testLEDWebViewController
{
    // 直接打开web页面
    LEDWebViewController *ledVC = [[LEDWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [self.navigationController pushViewController:ledVC animated:YES];
}

- (void)testLEDPortalWebViewController
{
    // 用portal打开web页面
 // @"leador://www.ishowchina.com/web"
    [LEDPortal transferFromViewController:self toURL:[NSURL URLWithString:@"leador://www.ishowchina.com/web?url=http://www.baidu.com"] completion:^(UIViewController * _Nullable viewController, NSError * _Nullable error) {
        
    }];
//    [LEDPortal transferFromViewController:self toURL:[NSURL URLWithString:@"leador://www.ishowchina.com/web?url=ipuny://portal/launch"] completion:^(UIViewController * _Nullable viewController, NSError * _Nullable error) {
//        
//    }];
}

- (void)testiToNative
{
    // i版调起native
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"webtest" ofType:@"html"];
    NSURL *url  = [NSURL fileURLWithPath:filePath];
    LEDWebViewController *ledVC = [[LEDWebViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:ledVC animated:YES];
}

- (void)testiToi
{
        // // i版调起i版本
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"helloweb" ofType:@"html"];
    NSURL *url  = [NSURL fileURLWithPath:filePath];
    LEDWebViewController *ledVC = [[LEDWebViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:ledVC animated:YES];
}

@end
