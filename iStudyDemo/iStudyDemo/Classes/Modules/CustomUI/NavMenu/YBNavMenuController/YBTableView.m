//
//  YBTableView.m
//  Wanyingjinrong
//
//  Created by Jason on 15/11/4.
//  Copyright © 2015年 www.jizhan.com. All rights reserved.
//

#import "YBTableView.h"

@implementation YBTableView

+ (instancetype)tableWithFrame:(CGRect)frame delegate:(id<UITableViewDataSource,UITableViewDelegate>)delegate tag:(NSInteger)tag registerNibNames:(NSArray<NSString *> *)registerNibNames style:(UITableViewStyle)style
{
    YBTableView *tableView = [[YBTableView alloc] initWithFrame:frame style:style];
    tableView.delegate = delegate;
    tableView.dataSource = delegate;
    tableView.tag = tag;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    for (NSString *nibName in registerNibNames) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
    }
    return tableView;
}

@end
