//
//  BSTopicPictureView.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/3.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSTopicPictureView.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "SDImageCache.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "UIButton+WebCache.h"
#import "AFNetworking.h"

@interface BSTopicPictureView ()

@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) UIImageView *gifImageView;
@property (nonatomic, strong) UIButton *seeBigPictureButton;

@end

@implementation BSTopicPictureView

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
//        imageView.backgroundColor = [UIColor redColor];
        [self addSubview:imageView];
        imageView;
    });
    _gifImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
//        imageView.backgroundColor = [UIColor redColor];
        imageView.image = [UIImage imageNamed:@"common-gif"];
        [self addSubview:imageView];
        imageView;
    });
    
    _seeBigPictureButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"see-big-picture-background"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"see-big-picture-background"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"see-big-picture"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"see-big-picture"] forState:UIControlStateHighlighted];
        
        [button setTitle:@"点击看大图" forState:UIControlStateNormal];
         [button setTitle:@"点击看大图" forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(seeBigPictureButtonClicked) forControlEvents:UIControlEventTouchUpInside];
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
    
////    self.pictureImageView.image = nil;
//    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
//    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
//        [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:_dataSource.large_image]
//                                 placeholderImage:nil];
//    } else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
//        [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:_dataSource.middle_image]
//                                 placeholderImage:nil];
//    } else {
//        self.pictureImageView.image = nil;
//    }
    
    self.pictureImageView.image = nil;
    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:_dataSource.large_image]
                             placeholderImage:nil];
    
    // gif
    if (dataSource.is_gif) {
        self.gifImageView.hidden = NO;
    } else {
        self.gifImageView.hidden = YES;
    }

    // see big
    if (dataSource.isBigPicture) {
        self.seeBigPictureButton.hidden = NO;
        self.pictureImageView.contentMode = UIViewContentModeTop;
        self.pictureImageView.clipsToBounds = YES;
    } else {
        self.seeBigPictureButton.hidden = YES;
        self.pictureImageView.contentMode = UIViewContentModeScaleToFill;
        self.pictureImageView.clipsToBounds = NO;
    }
    
    [self updateConstraintsIfNeeded];
}

#pragma mark - autolayout

- (void)updateConstraints
{
    [self.pictureImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.gifImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
    }];
    
    [self.seeBigPictureButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
    
    [super updateConstraints];
}

#pragma mark - 

- (void)seeBigPictureButtonClicked
{

}

@end
