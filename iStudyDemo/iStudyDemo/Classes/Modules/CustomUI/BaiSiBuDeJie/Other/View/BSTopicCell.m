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
#import "BSTopicPictureView.h"
#import "BSTopicAudioView.h"
#import "BSTopicVideoView.h"

@interface BSTopicCell ()

@property (nonatomic, weak) BSTopicPictureView *pictureView;
@property (nonatomic, weak) BSTopicAudioView *audioView;
@property (nonatomic, weak) BSTopicVideoView *videoView;

@end

@implementation BSTopicCell


// 懒加载

- (BSTopicPictureView *)pictureView
{
    if (_pictureView == nil) {
        BSTopicPictureView *view = [[BSTopicPictureView alloc] init];
        _pictureView= view;
        [self addSubview:_pictureView];
    }
    return _pictureView;
}

- (BSTopicAudioView *)audioView
{
    if (_audioView == nil) {
        BSTopicAudioView *view = [[BSTopicAudioView alloc] init];
        _audioView= view;
        [self addSubview:_audioView];
    }
    return _audioView;
}

- (BSTopicVideoView *)videoView
{
    if (_videoView == nil) {
        BSTopicVideoView *view = [[BSTopicVideoView alloc] init];
        _videoView= view;
        [self addSubview:_videoView];
    }
    return _videoView;
}

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
    
    // 添加中间控件
    if (dataSource.type == BSTopicTypeVideo) {
        // 视频
        self.videoView.hidden = NO;
        self.pictureView.hidden = YES;
        self.audioView.hidden = YES;
        
        self.videoView.dataSource = dataSource;
        self.videoView.frame = dataSource.contentFrame;
    } else if(dataSource.type == BSTopicTypeAudio) {
        // 音频
        self.videoView.hidden = YES;
        self.pictureView.hidden = YES;
        self.audioView.hidden = NO;
        
         self.audioView.dataSource = dataSource;
        self.audioView.frame = dataSource.contentFrame;
    } else if(dataSource.type == BSTopicTypePicture) {
        // 图片
        self.videoView.hidden = YES;
        self.pictureView.hidden = NO;
        self.audioView.hidden = YES;
        
         self.pictureView.dataSource = dataSource;
        self.pictureView.frame = dataSource.contentFrame;
    } else if(dataSource.type == BSTopicTypeWord) {
        // 文本
        self.videoView.hidden = YES;
        self.pictureView.hidden = YES;
        self.audioView.hidden = YES;
    } else {
    
    }
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
