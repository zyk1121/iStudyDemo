//
//  APPShareDataViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/6/15.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "APPShareDataViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"

// http://www.jianshu.com/p/169e31cacf42

@interface APPShareDataViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *listViewControllers;

@end

@implementation APPShareDataViewController

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
    _listViewControllers = [[NSMutableArray alloc] init];
    
    // 1.APP Groups
    [_listData addObject:@"APP Groups"];
    [_listData addObject:@"西蒙教程－三角形"];
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
            [self appGroups];
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
    return 40;
}

#pragma mark - private method

- (void)appGroups
{
    // 需要去https://developer.apple.com/account/ios/identifier/applicationGroup创建app group
    // group.com.ishowchina
    // 那么我们的app的前缀也必须是com.ishowchina
    /*
     App Groups
     iOS8之后苹果加入了App Groups功能，应用程序之间可以通过同一个group来共享资源，app group可以通过NSUserDefaults进行小量数据的共享，如果需要共享较大的文件可以通过NSFileCoordinator、NSFilePresenter等方式。
     开启app groups，需要添加一个group name，app之间通过这个group共享数据：
     
     文／树下的老男孩（简书作者）
     原文链接：http://www.jianshu.com/p/169e31cacf42
     著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。*/
 
    // 写入数据
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc]
                                  initWithSuiteName:@"group.com.ishowchina"];
    [myDefaults setObject:@"shared data for ishowchina" forKey:@"mykey"];
    
    // 读取数据
//    NSUserDefaults *myDefaults2 = [[NSUserDefaults alloc]
//                                  initWithSuiteName:@"group.com.ishowchina"];
//    NSString *content = [myDefaults2 objectForKey:@"mykey"];
//    NSLog(@"%@",content);
}

@end
