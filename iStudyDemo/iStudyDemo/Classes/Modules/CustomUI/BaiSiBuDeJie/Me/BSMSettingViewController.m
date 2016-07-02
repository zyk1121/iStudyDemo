//
//  BSMSettingViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/2.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSMSettingViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "SDImageCache.h"
#import "SVProgressHUD.h"

@interface BSMSettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger cacheSize;
@property (nonatomic, strong) NSArray *datas;

@end

@implementation BSMSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置";
    [self setupData];
    [self setupUI];
    [self.view setNeedsUpdateConstraints];
}

- (void)setupData
{
    _datas = @[@"清空缓存",@"推荐",@"当前版本",@"评分",@"关于"];
    [self getFolderSize];
}

- (void)getFolderSize
{
    _cacheSize = 0;
    // 获得文件夹路径大小
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *dirPath = [cachePath stringByAppendingPathComponent:@"default"];
//    NSLog(@"%@",dirPath);
//     NSLog(@"%@",dirPath);
    NSFileManager *fmr = [NSFileManager defaultManager];
    NSArray *arr = [fmr contentsOfDirectoryAtPath:dirPath error:nil];// 子路径
    NSArray *arr2 = [fmr subpathsAtPath:dirPath];// 子路径以及所有文件
    [arr2 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *path = (NSString *)obj;
        NSString *fullPath = [dirPath stringByAppendingPathComponent:path];
        NSDictionary *attrs = [fmr attributesOfItemAtPath:dirPath error:nil];
        _cacheSize += [attrs[NSFileSize] longLongValue];
    }];
//    [self clearDiskOnCompletion:dirPath];
    
}


- (void)clearDiskOnCompletion:(NSString *)diskCachePath
{
    [SVProgressHUD showWithStatus:@"清空缓存" maskType:SVProgressHUDMaskTypeBlack];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSFileManager defaultManager] removeItemAtPath:diskCachePath error:nil];
        [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:NULL];
        // 执行后续处理，completion回调
        [NSThread sleepForTimeInterval:1];
        [SVProgressHUD dismiss];
        [self getFolderSize];
        [self.tableView reloadData];
    });
}

- (void)setupUI
{
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView;
    });
    
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - tableview delegate & datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *reuseIdetify = @"tableViewCellIdetify";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.showsReorderControl = YES;
        }
        
        if (self.cacheSize > 1000 * 1000) {
            cell.textLabel.text = [NSString stringWithFormat:@"清除缓存(%.1lfMB)", self.cacheSize / (1000.0 * 1000.0)];
        } else if (self.cacheSize > 1000 ) {
            cell.textLabel.text = [NSString stringWithFormat:@"清除缓存(%.1lfKB)", self.cacheSize / (1000.0)];
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"清除缓存(%ldB)", self.cacheSize];
        }
        
        cell.imageView.image = nil;// 防止循环利用
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    static NSString *reuseIdetify2 = @"tableViewCellIdetifyddddd";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify2];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify2];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showsReorderControl = YES;
    }
    cell.textLabel.text = self.datas[indexPath.row];
    
    cell.imageView.image = nil;// 防止循环利用
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        // 获得文件夹路径大小
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
        NSString *dirPath = [cachePath stringByAppendingPathComponent:@"default"];
        [self clearDiskOnCompletion:dirPath];
        [tableView reloadData];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"清空缓存" message:@"参考 SDImageCache， 写的很好" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
}

@end
