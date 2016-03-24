//
//  ZFBCollectionViewCell.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/24.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "ZFBCollectionViewCell.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"

@interface ZFBCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *imageBGview;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;

@end

@implementation ZFBCollectionViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
            [self setupUI];
        
    }
    return self;
}

- (void)setupUI
{
    CGFloat w = SCREEN_WIDTH;
    CGFloat sizeW,sizeH;
    if (w >= 320) {
        sizeW = w  / 4.0;
        sizeH = sizeW;
    } else {
        sizeW = w  / 3.0;
        sizeH = sizeW;
    }
    _cellSize = CGSizeMake(sizeW, sizeH);
//    self.backgroundColor = [UIColor redColor];

    _imageBGview = [[UIView alloc] init];
    [self addSubview:self.imageBGview];
    _imageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView;
    });
    [self.imageBGview addSubview:_imageView];
    
    _label = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label;
    });
    [self addSubview:_label];
    
    _line1 = [[UIView alloc] init];
    _line1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_line1];
    _line2 = [[UIView alloc] init];
    _line2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_line2];
    
     [self setNeedsUpdateConstraints];
}

- (void)setIconImage:(UIImage *)iconImage
{
    _iconImage = iconImage;
    self.imageView.image  =_iconImage;
    [self setNeedsUpdateConstraints];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.label.text = title;
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    //
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-10);
    }];
    //
    [self.imageBGview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.label.mas_top);
    }];
    
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imageBGview);
        make.width.height.equalTo(@30);
    }];
    
    [self.line1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@0.5);
    }];
    
    [self.line2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    [super updateConstraints];
}

@end
