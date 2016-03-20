//
//  YBTableView.h
//  Wanyingjinrong
//
//  Created by Jason on 15/11/4.
//  Copyright © 2015年 www.jizhan.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YBTableView : UITableView

/**
 *  纪录是否已经刷新过
 */
@property (nonatomic, assign) BOOL isRefresh;

+ (instancetype)tableWithFrame:(CGRect)frame delegate:(id<UITableViewDataSource, UITableViewDelegate>)delegate tag:(NSInteger)tag registerNibNames:(NSArray<NSString *> *)registerNibNames style:(UITableViewStyle)style;

@end
