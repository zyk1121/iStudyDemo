//
//  BSTopicTopCommentView.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/3.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSTopicTopCommentView.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "SDImageCache.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "UIButton+WebCache.h"


@interface BSTopicTopCommentView ()

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *commentLabel;

@end

@implementation BSTopicTopCommentView

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    
    _topLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor darkGrayColor];
        label.textColor = [UIColor whiteColor];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:13];
        [self addSubview:label];
        label;
    });
    
    _commentLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        label;
    });
    
    [self updateConstraintsIfNeeded];
}

#pragma mark - setter method

- (void)setDataSource:(BSTopic *)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
    }
    // 跟新ui数
    
    if (_dataSource.topComment) {
        self.hidden = NO;
        self.topLabel.text = @"最热评论";
        self.commentLabel.text = [NSString stringWithFormat:@"%@:%@",_dataSource.topComment.user.username,_dataSource.topComment.content];
    } else {
        self.hidden = YES;
    }
    
    [self updateConstraintsIfNeeded];
}

#pragma mark - autolayout

- (void)updateConstraints
{
    [self.topLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(CommonMargin);
        make.top.equalTo(self);
        make.height.equalTo(@20);
    }];
    
    [self.commentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).offset(CommonMargin);
        make.top.equalTo(self.topLabel.mas_bottom);
        make.bottom.equalTo(self);
    }];
    
    NSLog(@"%lf",self.height);
    
    [super updateConstraints];
}

@end
