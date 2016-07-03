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
#import "DACircularProgressView.h"
#import "DALabeledCircularProgressView.h"

@interface BSTopicPictureView ()

@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) UIImageView *gifImageView;
@property (nonatomic, strong) UIButton *seeBigPictureButton;

@property (nonatomic, strong) DALabeledCircularProgressView *progressView;

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
    
    _progressView = ({
        DALabeledCircularProgressView *view = [[DALabeledCircularProgressView alloc] init];
        [self addSubview:view];
        view.progressLabel.textColor = [UIColor redColor];
        view;
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
    
//    self.pictureImageView.image = nil;
//    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:_dataSource.large_image]
//                             placeholderImage:nil];
//    self.progressView.progress = 0.5;
//    self.progressView.progress = 0;
    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:_dataSource.large_image]
                             placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                                 sleep(0.3);
                                 self.progressView.hidden = NO;
                                 self.progressView.progress = 1.0 *receivedSize / expectedSize;
//                                 self.progressView.progressLabel.text = [NSString stringWithFormat:@"%lf%%",100.0 *receivedSize / expectedSize];
                             } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 self.progressView.hidden = YES;
                             }];
    
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
    
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@80);
        make.center.equalTo(self);
    }];
    
    [super updateConstraints];
}

#pragma mark - 

- (void)seeBigPictureButtonClicked
{

}

@end
