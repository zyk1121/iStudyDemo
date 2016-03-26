//
//  KBViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/23.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "SPKBannerView.h"
#import "SPKBanner.h"
//#import "UIButton+WebCache.h"

@interface SPKBannerView ()

@property (nonatomic, strong) UIButton *bannerButton;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL tapAction;

@end

@implementation SPKBannerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _bannerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bannerButton.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [_bannerButton addTarget:self action:@selector(didTapBanner) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_bannerButton];
    }
    
    return self;
}

- (void)setBanner:(SPKBanner *)banner
{
    _banner = banner;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setImage:_banner.image];
    [self.bannerButton addSubview:imageView];
    [self setNeedsDisplay];
}

- (void)setTarget:(id)target andTapAction:(SEL)tapAction
{
    self.target = target;
    self.tapAction = tapAction;
}

- (void)didTapBanner
{
    if (!self.banner) {
        return;
    }
    
    if (self.target && [self.target respondsToSelector:self.tapAction]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.tapAction withObject:self.banner];
#pragma clang diagnostic pop
    }
}

@end
