//
//  BSTopicToolBarView.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/3.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSTopicToolBarView.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "SDImageCache.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "UIButton+WebCache.h"

@interface BSTopicToolBarView()

@property (nonatomic, strong) UIButton *dingButton;
@property (nonatomic, strong) UIButton *caiButton;
@property (nonatomic, strong) UIButton *postButton;
@property (nonatomic, strong) UIButton *commentButton;

@end

@implementation BSTopicToolBarView


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
    _dingButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1;
        
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0); // 设置对应的边距image跟title的边距属性
        
        [button setImage:[UIImage imageNamed:@"mainCellDing"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"mainCellDingClick"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"mainCellDingClick"] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        button.titleLabel.font  = [UIFont systemFontOfSize:12];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        button;
    });
    
    _caiButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 2;
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0); // 设置对应的边距image跟title的边距属性
        [button setImage:[UIImage imageNamed:@"mainCellCai"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"mainCellCaiClick"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"mainCellCaiClick"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        button.titleLabel.font  = [UIFont systemFontOfSize:12];
        [self addSubview:button];
        button;
    });
    
    
    _postButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 3;
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0); // 设置对应的边距image跟title的边距属性
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        button.titleLabel.font  = [UIFont systemFontOfSize:12];
        [button setImage:[UIImage imageNamed:@"mainCellShare"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"mainCellShareClick"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"mainCellShareClick"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        button;
    });
    
    
    _commentButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 4;
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0); // 设置对应的边距image跟title的边距属性
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        button.titleLabel.font  = [UIFont systemFontOfSize:12];
        [button setImage:[UIImage imageNamed:@"mainCellComment"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"mainCellCommentClick"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"mainCellCommentClick"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
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
//    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_dataSource.profile_image]
//                          placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
//    self.nameLabel.text = _dataSource.name;
//    self.timeLabel.text = _dataSource.created_at;
    [self.dingButton setTitle:[NSString stringWithFormat:@"%zd", _dataSource.ding] forState:UIControlStateNormal];
    [self.dingButton setTitle:[NSString stringWithFormat:@"%zd", _dataSource.ding] forState:UIControlStateSelected];
    [self.dingButton setTitle:[NSString stringWithFormat:@"%zd", _dataSource.ding] forState:UIControlStateHighlighted];
    
    [self.caiButton setTitle:[NSString stringWithFormat:@"%zd", _dataSource.cai] forState:UIControlStateNormal];
    [self.caiButton setTitle:[NSString stringWithFormat:@"%zd", _dataSource.cai] forState:UIControlStateSelected];
    [self.caiButton setTitle:[NSString stringWithFormat:@"%zd", _dataSource.cai] forState:UIControlStateHighlighted];
    
    [self.postButton setTitle:@"分享" forState:UIControlStateNormal];
    [self.postButton setTitle:@"分享" forState:UIControlStateSelected];
    [self.postButton setTitle:@"分享" forState:UIControlStateHighlighted];
    
    [self.commentButton setTitle:[NSString stringWithFormat:@"%zd", _dataSource.comment] forState:UIControlStateNormal];
    [self.commentButton setTitle:[NSString stringWithFormat:@"%zd", _dataSource.comment] forState:UIControlStateSelected];
    [self.commentButton setTitle:[NSString stringWithFormat:@"%zd", _dataSource.comment] forState:UIControlStateHighlighted];
    
    _dataSource.cellHeight += 35;
    [self updateConstraintsIfNeeded];
}

#pragma mark - autolayout

- (void)updateConstraints
{
    CGFloat buttonW = SCREEN_WIDTH / 4;
    CGFloat buttonH = 33;
    [self.dingButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.width.equalTo(@(buttonW));
        make.top.equalTo(self).offset(1);
        make.height.equalTo(@(buttonH));
        make.bottom.equalTo(self).offset(-1);
    }];
    
    [self.caiButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dingButton.mas_right).offset(0);
        make.top.height.width.equalTo(self.dingButton);
    }];
    
    [self.postButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.caiButton.mas_right).offset(0);
        make.top.height.width.equalTo(self.dingButton);
    }];
    
    [self.commentButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.postButton.mas_right).offset(0);
        make.top.height.width.equalTo(self.dingButton);
    }];
    
    [super updateConstraints];
}

#pragma mark - event

- (void)buttonClicked:(UIButton *)button
{
//    if (button.selected) {
//        return;
//    }
//    button.selected = YES;
    if ([self.delegate respondsToSelector:@selector(toolButtonClicked:)]) {
        [self.delegate toolButtonClicked:(BSTopicToolBarButtonType)button.tag];
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
