//
//  NavMenu.h
//  FansellDemo
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 www.jizhan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NavMenuScrollView;

@protocol NavMenuScrollViewDelegate <UIScrollViewDelegate>

- (void)navMenuScrollView:(NavMenuScrollView *)navMenuScrollView didClickButtonIndex:(NSInteger)index;

@end

@interface NavMenuScrollView : UIScrollView

@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, assign) NSInteger currentSelectIndex;
@property (nonatomic, strong) UIButton *currentSelectButton;
@property (nonatomic, assign) id<NavMenuScrollViewDelegate>delegate2;
@property (nonatomic, copy) NSArray *items;

@property (nonatomic, strong) NSMutableArray *frames;

@property (nonatomic, assign) BOOL isBtnClicked;

+ (instancetype)navMenuScrollViewWithFrame:(CGRect)frame items:(NSArray *)items;

- (void)setCurrentSelectIndex:(NSInteger)currentSelectIndex markViewAnimate:(BOOL)markViewAnimate;

@end
