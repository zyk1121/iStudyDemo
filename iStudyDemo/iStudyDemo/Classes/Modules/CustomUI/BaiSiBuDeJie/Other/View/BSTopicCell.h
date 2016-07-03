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
#import "BSTopicCellProtocol.h"

//@protocol BSTopicCellDatasource <NSObject>
//
//@optional
//- (BSTopic *)getCellData;
//
//@end

@interface BSTopicCell : UITableViewCell<BSTopicHeaderViewDelegate, BSTopicToolBarViewDelegate>

//@property (nonatomic, weak) id<BSTopicCellDatasource> datasource;
@property (nonatomic, weak) id<BSTopicCellDelegate> delegate;

@property (nonatomic, strong) BSTopicHeaderView *topHeader;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) BSTopicToolBarView *bottomToolBar;

@property (nonatomic, strong) BSTopic *dataSource;

@end
