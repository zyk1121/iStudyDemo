//
//  MediaViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "MediaViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "AlbumViewController.h"
#import "AudioViewController.h"
#import "CustomPhotoViewController.h"
#import "CustomPlayerViewController.h"
#import "VideoViewController.h"
#import "PhotoViewController.h"
#import "CustomTakePhotoViewController.h"


@interface MediaViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *listViewControllers;

@end

@implementation MediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    // 1.相册
    [_listData addObject:@"相册"];
    AlbumViewController *albumViewController = [[AlbumViewController alloc] init];
    [_listViewControllers addObject:albumViewController];
    // 2.相机
    [_listData addObject:@"相机"];
    PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
    [_listViewControllers addObject:photoViewController];
    // 3.自定义相机
    [_listData addObject:@"自定义相机"];
    CustomPhotoViewController *customPhotoViewController = [[CustomPhotoViewController alloc] init];
    [_listViewControllers addObject:customPhotoViewController];
    // 3.AVFoundation自定义相机
    [_listData addObject:@"AVFoundation自定义相机(保存相册)"];
    CustomTakePhotoViewController *customtakePhotoViewController = [[CustomTakePhotoViewController alloc] init];
    [_listViewControllers addObject:customtakePhotoViewController];
    // 4.音频
    [_listData addObject:@"音频"];
    AudioViewController *audioViewController = [[AudioViewController alloc] init];
    [_listViewControllers addObject:audioViewController];
    // 5.视频
    [_listData addObject:@"视频"];
    VideoViewController *videoViewController = [[VideoViewController alloc] init];
    [_listViewControllers addObject:videoViewController];
    // 6.流媒体 http://blog.csdn.net/mad2man/article/details/12553873
    [_listData addObject:@"流媒体"];
    CustomPlayerViewController *customPlayerController = [[CustomPlayerViewController alloc] init];
    [_listViewControllers addObject:customPlayerController];
    
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
    UIViewController *vc = [self.listViewControllers objectAtIndex:indexPath.row];
    vc.title = [self.listData objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
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

@end
