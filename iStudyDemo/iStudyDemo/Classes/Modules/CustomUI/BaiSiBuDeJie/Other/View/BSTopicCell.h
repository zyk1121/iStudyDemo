//
//  BSTopicCell.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/3.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSTopic.h"
#import "BSTopicHeaderView.h"
#import "BSTopicToolBarView.h"

//@protocol BSTopicCellDatasource <NSObject>
//
//@optional
//- (BSTopic *)getCellData;
//
//@end

@interface BSTopicCell : UITableViewCell

//@property (nonatomic, weak) id<BSTopicCellDatasource> datasource;

@property (nonatomic, strong) BSTopicHeaderView *topHeader;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) BSTopicToolBarView *bottomToolBar;

@property (nonatomic, strong) BSTopic *dataSource;

@end
