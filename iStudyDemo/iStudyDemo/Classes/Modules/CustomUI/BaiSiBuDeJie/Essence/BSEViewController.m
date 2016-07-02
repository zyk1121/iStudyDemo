//
//  BSEViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/6/25.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSEViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "BSETitleButton.h"
#import "UIView+Extension.h"
#import "BSEAllTableViewController.h"
#import "BSEVideoTableViewController.h"
#import "BSEAudioTableViewController.h"
#import "BSEPictureTableViewController.h"
#import "BSEWordTableViewController.h"


@interface BSEViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *headView;
@property (nonatomic, weak) BSETitleButton *currentSelectedButton;
@property (nonatomic, weak) UIView *indictorView;

@end

@implementation BSEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"百思不得姐";
    [self setupUI];
}

- (void)setupUI
{
    [self setupNaviBar];
    [self setupChildsVC];
    [self setupScrollView];
    [self setupTitleView];
//    [self setupChildsVC];
    
    [self addChildVCView];
    
}

- (void)setupChildsVC
{
    BSEAllTableViewController *all = [[BSEAllTableViewController alloc] init];
    [self addChildViewController:all];
    BSEVideoTableViewController *video = [[BSEVideoTableViewController alloc] init];
    [self addChildViewController:video];
    BSEAudioTableViewController *audio = [[BSEAudioTableViewController alloc] init];
    [self addChildViewController:audio];
    BSEPictureTableViewController *picture = [[BSEPictureTableViewController alloc] init];
    [self addChildViewController:picture];
    BSEWordTableViewController *word = [[BSEWordTableViewController alloc] init];
    [self addChildViewController:word];
}

- (void)setupNaviBar
{
    // 导航栏右边按钮
    UIBarButtonItem *bardoneBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(bardoneBtnClicked)];
    UIBarButtonItem *barcancelBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(barcancelBtnClicked)];
    NSArray *rightBtns=[NSArray arrayWithObjects:barcancelBtn, nil];
    self.navigationItem.rightBarButtonItems=rightBtns;
    
    
    // 导航栏左边按钮
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBarButton setImage:[UIImage imageNamed:@"MainTagSubIcon"] forState:UIControlStateNormal];
    [leftBarButton setImage:[UIImage imageNamed:@"MainTagSubIconClick"] forState:UIControlStateHighlighted];
    UIImage *image = [leftBarButton imageForState:UIControlStateNormal];
    leftBarButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [leftBarButton sizeToFit];
    [leftBarButton addTarget:self action:@selector(leftBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
}

- (void)setupScrollView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    _scrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_scrollView];
    
    NSUInteger count = self.childViewControllers.count;
    for (int i = 0; i < count; i++) {
//        UITableView *childView = (UITableView *)self.childViewControllers[i].view;
//        childView.x = i * childView.width;
//        childView.y = 0;
//        childView.height = _scrollView.height;
////        childView.backgroundColor = [UIColor redColor];
//        [_scrollView addSubview:childView];
//        
//        // 内边距
//        childView.contentInset = UIEdgeInsetsMake(64 + 44, 0, 49, 0);
//        childView.scrollIndicatorInsets = childView.contentInset;
    }
    
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.contentSize = CGSizeMake(count * _scrollView.width, 0);
}

// 标签栏
- (void)setupTitleView
{
    _headView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
    _headView.backgroundColor = [UIColor whiteColor];
    _headView.alpha = 0.7;
    [self.view addSubview:_headView];
    
    NSArray *titles = @[@"全部",@"视频",@"声音",@"图片",@"段子"];
    NSUInteger count = titles.count;
//    CGFloat titleButtonW = 100;
    CGFloat titleButtonW = SCREEN_WIDTH * 1.0 / count;
    CGFloat titleButtonH = 44;
    for (int i = 0; i < count; i++) {
        //
        BSETitleButton *button = [BSETitleButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(titlClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        [_headView addSubview:button];
        if (i == 0) {
            button.selected = YES;
            self.currentSelectedButton = button;
        }
    }
    
    _headView.contentSize = CGSizeMake(titleButtonW * count, 0);
    _headView.showsVerticalScrollIndicator = NO;
    _headView.showsHorizontalScrollIndicator = NO;
    // 按钮选中的颜色
    BSETitleButton *button = [_headView.subviews lastObject];
    // 底部的指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [button titleColorForState:UIControlStateSelected];
    indicatorView.height = 1;
    indicatorView.y = _headView.height - 1;
    [_headView addSubview:indicatorView];
    _indictorView = indicatorView;
    
    // 默认选中最前面的按钮
    [self titlClicked:self.currentSelectedButton];
}


#pragma mark - navibar right button clicked
- (void)bardoneBtnClicked
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)barcancelBtnClicked
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)leftBarButtonClicked
{
    
}

#pragma mark - title clicked

- (void)titlClicked:(BSETitleButton *)button
{
//    [self.currentSelectedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    self.currentSelectedButton = button;
    self.currentSelectedButton.selected = NO;
    button.selected = YES;
    self.currentSelectedButton = button;
    
    [UIView animateWithDuration:0.3 animations:^{
        // 计算文字宽度
        CGSize size = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];
//        self.indictorView.width = button.titleLabel.width;
        self.indictorView.width = size.width;
        self.indictorView.y = self.headView.height - 1;
        self.indictorView.centerX = button.centerX;
    }];
    
    // 滚动
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = button.tag * self.scrollView.width;
    //        self.scrollView.contentOffset = offset;
    [self.scrollView setContentOffset:offset animated:YES];// 如果现在的offst不变，不会产生动画，不会调用scrollViewDidEndScrollingAnimation
}


- (void)addChildVCView
{
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
    // 取出
    UITableView *childView = (UITableView *)self.childViewControllers[index].view;
    
    // 添加过不再添加
    if (childView.superview) {
        return;
    }
    
//    childView.x = index * childView.width;
//    childView.y = 0;
//    
//    childView.x = self.scrollView.contentOffset.x;
//    childView.y = self.scrollView.contentOffset.y;
//    childView.height = _scrollView.height;
//    childView.width = _scrollView.width;
    
//    childView.x = self.scrollView.bounds.origin.x;
//    childView.y = self.scrollView.bounds.origin.y;
//    childView.height = self.scrollView.bounds.size.height;
//    childView.width = self.scrollView.bounds.size.width;
    childView.frame = self.scrollView.bounds;// 执行多次没有关系，不会影响性能
    //        childView.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:childView];// 执行多次没有关系，不会影响性能
}

#pragma mark - _scrollView dele

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // [self.scrollView setContentOffset:offset animated:YES];会调用
//    NSLog(@"1");
    [self addChildVCView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 手动拖动才会调用
//    NSLog(@"2");/
    //  点击对应的按钮
    NSUInteger index = scrollView.contentOffset.x / self.scrollView.width;
    BSETitleButton *button = [self.headView.subviews objectAtIndex:index];
    [self titlClicked:button];
    // 后面不会调用scrollViewDidEndScrollingAnimation
        [self addChildVCView];
}


@end
