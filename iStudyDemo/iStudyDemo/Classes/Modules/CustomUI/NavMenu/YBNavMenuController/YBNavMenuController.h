//
//  YBNavMenuController.h
//  Wanyingjinrong
//
//  Created by Jason on 15/11/13.
//  Copyright © 2015年 www.jizhan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavMenuScrollView.h"
#import "YBTableView.h"
#import "YBDefine.h"

@interface YBNavMenuController : UIViewController<UITableViewDataSource, UITableViewDelegate, NavMenuScrollViewDelegate>

@property (nonatomic, copy) NSArray<YBTableView *> *tableArr;

/** 记录是点击还是滑动*/
@property (nonatomic, assign) BOOL isClick;

/**当前tableView的tag*/
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UIScrollView *tableScrollView;
@property (nonatomic, strong) NavMenuScrollView *menuScorllView;

- (void)layout:(NSArray<NSString *> *)items fromOriginY:(CGFloat)originY;
/**
 *  注册cell
 *
 *  @param nibNames cell的nib名称
 *  @param index    tableView的索引
 */
- (void)registerNibNames:(NSArray *)nibNames forIndex:(NSInteger)index;

@end
