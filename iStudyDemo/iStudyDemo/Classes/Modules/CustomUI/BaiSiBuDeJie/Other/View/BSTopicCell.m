//
//  BSTopicCell.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/3.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSTopicCell.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"

@interface BSTopicCell ()

@end

@implementation BSTopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setupUI];
}


+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

#pragma mark - life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    // 取消选中状态
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _topHeader = ({
        BSTopicHeaderView *view = [[BSTopicHeaderView alloc] init];
        [self addSubview:view];
        view;
    });
    
    _bottomToolBar = ({
        BSTopicToolBarView *view = [[BSTopicToolBarView alloc] init];
        [self addSubview:view];
        view;
    });
    
    _contentLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor blackColor];
        [self addSubview:label];
        label;
    });
    
    _topCommentView = ({
        BSTopicTopCommentView *view = [[BSTopicTopCommentView alloc] init];
        [self addSubview:view];
        view;
    });
    
    [self updateConstraints];
}

#pragma mark - setter method

- (void)setDataSource:(BSTopic *)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
    }
    // 跟新ui数据
    self.topHeader.dataSource = dataSource;
    self.topHeader.delegate = self;
    //
    self.contentLabel.text = dataSource.text;
    //
    self.bottomToolBar.dataSource  =dataSource;
    self.bottomToolBar.delegate  =self;
    //
    self.topCommentView.dataSource = dataSource;
}

#pragma mark - autolayout

- (void)updateConstraints
{
    [self.topHeader mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
    }];
    
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).offset(CommonMargin);
        make.top.equalTo(self.topHeader.mas_bottom).offset(CommonMargin);
    }];
//    
//    self.bottomToolBar.backgroundColor = [UIColor redColor];
//    self.topCommentView.backgroundColor = [UIColor redColor];
    [self.bottomToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
    
    [self.topCommentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.bottomToolBar.mas_top).offset(-CommonMargin);
    }];
    [super updateConstraints];
}

#pragma mark - BSTopicHeaderViewDelegate

- (void)moreButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(preformActionForType:andTopicData:)]) {
        [self.delegate preformActionForType:BSTopicEventTypeMoreButtonClick andTopicData:self.dataSource];
    }
}

#pragma mark - BSTopicToolBarViewDelegate

- (void)toolButtonClicked:(BSTopicToolBarButtonType)buttonType
{
    NSLog(@"ddddd:%d",buttonType);
}

@end
