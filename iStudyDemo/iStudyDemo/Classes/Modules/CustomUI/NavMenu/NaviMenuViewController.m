//
//  NaviMenuViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/20.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "NaviMenuViewController.h"

@implementation NaviMenuViewController

// 当页面都是tableview 的时候使用：YBNavMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layout];
}

- (void)layout
{
    [self layout:@[@"menu1", @"menu2", @"menu3"] fromOriginY:0];
}

#pragma mark - 代理方法
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag) {
        case 0:
            return 10;
            break;
        case 1:
            return 20;
            break;
        case 2:
            return 30;
            break;
        default:
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = @"section header";
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSString *str = nil;
    switch (tableView.tag) {
        case 0:
            str = [NSString stringWithFormat:@"这个tableView的tag为0-----%zi", indexPath.row];
            break;
        case 1:
            str = [NSString stringWithFormat:@"这个tableView的tag为1-----%zi", indexPath.row];
            break;
        case 2:
            str = [NSString stringWithFormat:@"这个tableView的tag为2-----%zi", indexPath.row];
            break;
        default:
            break;
    }
    
    cell.textLabel.text = str;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case 0:
            return 84;
            break;
        case 1:
            return 64;
            break;
        case 2:
            return 44;
            break;
        default:
            break;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [super scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)navMenuScrollView:(NavMenuScrollView *)navMenuScrollView didClickButtonIndex:(NSInteger)index
{
    [super navMenuScrollView:navMenuScrollView didClickButtonIndex:index];
}

@end
