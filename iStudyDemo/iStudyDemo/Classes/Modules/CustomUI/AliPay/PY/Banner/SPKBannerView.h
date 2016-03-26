//
//  KBViewController.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/23.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPKBanner;

@interface SPKBannerView : UIView

@property (nonatomic, strong) SPKBanner *banner;

- (void)setTarget:(id)target andTapAction:(SEL)tapAction;

@end
