//
//  BSTopicHeaderView.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/3.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "SDImageCache.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "UIButton+WebCache.h"
#import "BSTopicHeaderView.h"


@interface BSTopicHeaderView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *moreButton;

@end

@implementation BSTopicHeaderView


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
    _iconImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.cornerRadius = 18;
        [self addSubview:imageView];
        imageView;
    });
    
    _nameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:13];
        [self addSubview:label];
        label;
    });
    
    _timeLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:10];
        [self addSubview:label];
        label;
    });
    
    _moreButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"cellmorebtnnormal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"cellmorebtnclick"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        button;
    });
    [self updateConstraintsIfNeeded];
}

#pragma mark - setter method

- (void)setDataSource:(BSTopic *)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
    }
    // 跟新ui数据
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_dataSource.profile_image]
              placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.nameLabel.text = _dataSource.name;
    self.timeLabel.text = _dataSource.created_at;
    
//    _dataSource.cellHeight += 44;
    [self updateConstraintsIfNeeded];
}

#pragma mark - autolayout

- (void)updateConstraints
{
    [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.width.height.equalTo(@36);
        make.centerY.equalTo(self);
    }];
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.top.equalTo(self).offset(5);
    }];
    
    [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.bottom.equalTo(self).offset(-5);
    }];
    
    [self.moreButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
    }];
    
    [super updateConstraints];
}

#pragma mark - event

- (void)moreButtonClicked
{
    if ([self.delegate respondsToSelector:@selector(moreButtonClicked)]) {
        [self.delegate moreButtonClicked];
    }
//    UIAlertController *alertController = [[UIAlertController alloc] init];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:nil];
//    
//    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除"style:UIAlertActionStyleDestructive handler:nil];
//    
//    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"保存"style:UIAlertActionStyleDefault handler:nil];
//    
//    [alertController addAction:cancelAction];
//    [alertController addAction:deleteAction];
//    [alertController addAction:archiveAction];
    
    /*
 [self.window.rootViewController presentViewController:vc animated:YES completion:^{
     
 }];
     */
}

@end
