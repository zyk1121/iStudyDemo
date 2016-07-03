//
//  BSTopicVideoView.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/3.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSTopicVideoView.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "SDImageCache.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "UIButton+WebCache.h"


@interface BSTopicVideoView ()

@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) UIButton *middleButton;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;

@end

@implementation BSTopicVideoView

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
    _pictureImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];

        [self addSubview:imageView];
        imageView;
    });
    
    _middleButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"playButton"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"playButton"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateHighlighted];
        
        //        [button setTitle:@"点击看大图" forState:UIControlStateNormal];
        //        [button setTitle:@"点击看大图" forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
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
    
    self.pictureImageView.image = nil;
    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:_dataSource.large_image]
                             placeholderImage:nil];
    
    
    [self updateConstraintsIfNeeded];
}

#pragma mark - autolayout

- (void)updateConstraints
{
    [self.pictureImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.middleButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [super updateConstraints];
}

#pragma mark - 
- (void)buttonClicked
{
    
}

@end
