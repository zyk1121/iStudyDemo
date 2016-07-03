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
    //
}

#pragma mark - autolayout

- (void)updateConstraints
{
    [self.topHeader mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}

@end
