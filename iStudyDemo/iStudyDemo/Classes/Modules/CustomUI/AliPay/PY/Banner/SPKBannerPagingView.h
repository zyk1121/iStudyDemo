//
//  KBViewController.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/23.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPKBannerPagingView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *banners;

- (void)setTarget:(id)target andTapAction:(SEL)tapAction;

- (void)startTimer;

- (void)stopTimer;

@end
