//
//  KBViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/23.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "SPKBannerPageControl.h"
#import "UIViewAdditions.h"

@interface SPKBannerPageControl()

@property (nonatomic, strong) UIImage *activeImage;
@property (nonatomic, strong) UIImage *inactiveImage;

@end

@implementation SPKBannerPageControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        _activeImage = [UIImage imageNamed:@"icon_pagecontrol_active.png"];
        _inactiveImage = [UIImage imageNamed:@"icon_pagecontrol_inactive.png"];

        self.pageIndicatorTintColor = [UIColor clearColor];
        self.currentPageIndicatorTintColor = [UIColor clearColor];
    }
    return self;
}

- (void)updateDots
{
    for (int i = 0; i < [self.subviews count]; i++) {
        UIView *dot = [self.subviews objectAtIndex:i];
        [dot removeAllSubviews];
        
        if (i == self.currentPage) {
            [dot addSubview:[[UIImageView alloc] initWithImage:self.activeImage]];
        } else {
            [dot addSubview:[[UIImageView alloc] initWithImage:self.inactiveImage]];
        }
    }
}

- (void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

@end
