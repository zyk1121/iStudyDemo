//
//  YBNavMenuController.m
//  Wanyingjinrong
//
//  Created by Jason on 15/11/13.
//  Copyright © 2015年 www.jizhan.com. All rights reserved.
//

#import "YBNavMenuController.h"
#import "UIView+Extension.h"
#import "YBDefine.h"

@interface YBNavMenuController ()

@end

@implementation YBNavMenuController
- (instancetype)init
{
    self = [super init];
    if (self) {
        /*在iOS 7中，苹果引入了一个新的属性，叫做[UIViewController setEdgesForExtendedLayout:]，它的默认值为UIRectEdgeAll。当你的容器是navigation controller时，默认的布局将从navigation bar的顶部开始。这就是为什么所有的UI元素都往上漂移了44pt。有时会加上顶部tool bar的高度 20, 20+44 = 64*/
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            {
                self.edgesForExtendedLayout = UIRectEdgeNone;
            }
        }
//        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)registerNibNames:(NSArray *)nibNames forIndex:(NSInteger)index
{
    for (NSString *nibName in nibNames) {
        [self.tableArr[index] registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
    }
}

- (void)layout:(NSArray<NSString *> *)items fromOriginY:(CGFloat)originY
{
    NSInteger count = items.count;
    NavMenuScrollView *menuScorllView = [NavMenuScrollView navMenuScrollViewWithFrame:CGRectMake(0, originY, kScreenW, 44) items:items];
    menuScorllView.delegate2 = self;
    self.menuScorllView = menuScorllView;
    [self.view addSubview:menuScorllView];
    
    UIScrollView *tableScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(menuScorllView.frame), kScreenW, kScreenH-44-originY - 64)];
    tableScrollView.delegate = self;
    tableScrollView.pagingEnabled = YES;
    tableScrollView.contentSize = CGSizeMake(count * kScreenW, 0);
    tableScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:tableScrollView];
    self.tableScrollView = tableScrollView;
    
    NSMutableArray *tableArr = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        YBTableView *tableView = [YBTableView tableWithFrame:CGRectMake(i*kScreenW, 0, kScreenW, tableScrollView.height) delegate:self tag:i registerNibNames:nil style:UITableViewStylePlain];
        
        UILabel *tableTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        tableTitle.textColor =[UIColor blueColor];
        tableTitle.backgroundColor =[UIColor lightGrayColor];
        tableTitle.opaque = YES;
        tableTitle.font = [UIFont boldSystemFontOfSize:18];
        tableTitle.text = @"Header Label";
        tableView.tableHeaderView = tableTitle;
        
        UILabel *tableTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        tableTitle2.textColor =[UIColor blueColor];
        tableTitle2.backgroundColor =[UIColor lightGrayColor];
        tableTitle2.opaque = YES;
        tableTitle2.font = [UIFont boldSystemFontOfSize:18];
        tableTitle2.text = @"Footer Label";
        tableView.tableFooterView = tableTitle2;
        
        [self.tableScrollView addSubview:tableView];
        [tableArr addObject:tableView];
    }
    self.tableArr = tableArr;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[YBTableView class]]) return;
    if (self.isClick) return;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSInteger count = self.menuScorllView.items.count;
    self.menuScorllView.animationView.x = kScreenW/count/2.0 + offsetX/count - self.menuScorllView.animationView.width/2;
    
    //计算出第几页
    int page = (scrollView.contentOffset.x + kScreenW/2)/kScreenW;
    self.currentPage = page;
    self.menuScorllView.currentSelectIndex = page;
    [self.menuScorllView setCurrentSelectIndex:page markViewAnimate:NO];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.isClick = NO;
}

#pragma mark - NavMenuScrollViewDelegate
- (void)navMenuScrollView:(NavMenuScrollView *)navMenuScrollView didClickButtonIndex:(NSInteger)index
{
    self.currentPage = index;
    //计算出第几页
    int page = (self.tableScrollView.contentOffset.x + kScreenW/2)/kScreenW;
    if (index == page) return;
    self.isClick = YES;
    [self.tableScrollView setContentOffset:CGPointMake(index * kScreenW, 0) animated:YES];
}

@end
