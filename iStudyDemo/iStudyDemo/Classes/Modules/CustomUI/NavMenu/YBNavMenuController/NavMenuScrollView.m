//
//  NavMenu.m
//  FansellDemo
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 www.jizhan.com. All rights reserved.
//

#import "NavMenuScrollView.h"
#import "UIView+Extension.h"

#define KColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface NavMenuScrollView ()

@property (nonatomic, strong) NSMutableArray *btns;

@end

@implementation NavMenuScrollView

- (NSMutableArray *)btns
{
    if (_btns == nil) {
        _btns = [NSMutableArray arrayWithCapacity:0];
    }
    return _btns;
}

- (NSMutableArray *)frames
{
    if (_frames == nil) {
        _frames = [NSMutableArray arrayWithCapacity:0];
    }
    return _frames;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    [items enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:obj forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        btn.tag = idx;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:KColorFromRGB(0xcb521b) forState:UIControlStateSelected];
        [btn setTintColor:[UIColor clearColor]];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.btns addObject:btn];
        if (idx == 0) {
            self.currentSelectButton = btn;
            self.currentSelectIndex = idx;
        }
    }];
    
//    [self setNeedsUpdateConstraints];
}

- (void)setCurrentSelectIndex:(NSInteger)currentSelectIndex markViewAnimate:(BOOL)markViewAnimate
{
    if (currentSelectIndex>=self.items.count) return;
    _currentSelectIndex = currentSelectIndex;
    self.currentSelectButton = self.btns[currentSelectIndex];
    if (markViewAnimate) {
        self.animationView.x = self.currentSelectButton.x;
        self.animationView.width = self.currentSelectButton.width;
    }
    
    for (UIButton *btn in self.btns) {
        btn.selected = NO;
    }
    
    self.currentSelectButton.selected = YES;
}

- (void)setCurrentSelectIndex:(NSInteger)currentSelectIndex
{
//    _currentSelectIndex = currentSelectIndex;
//    self.currentSelectButton = self.btns[currentSelectIndex];
//    self.animationView.x = self.currentSelectButton.x;
//    self.animationView.width = self.currentSelectButton.width;
//    
//    for (UIButton *btn in self.btns) {
//        btn.selected = NO;
//    }
//    
//    self.currentSelectButton.selected = YES;
    [self setCurrentSelectIndex:currentSelectIndex markViewAnimate:NO];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces = NO;
//        self.contentOffset = CGPointMake(0, 0);
//        self.contentSize = CGSizeMake(frame.size.width, frame.size.height);
        self.animationView = [[UIView alloc] init];
        self.animationView.backgroundColor = KColorFromRGB(0xcb521b);
        [self addSubview:self.animationView];
    }
    return self;
}

+ (instancetype)navMenuScrollViewWithFrame:(CGRect)frame items:(NSArray *)items
{
    NavMenuScrollView *navMenuSV = [[NavMenuScrollView alloc] initWithFrame:frame];
//    [navMenuSV addSubview:[UIButton buttonWithType:UIButtonTypeContactAdd]];
    navMenuSV.items = items;
    return navMenuSV;
}

- (void)click:(UIButton *)btn
{
    self.isBtnClicked = YES;
    self.currentSelectIndex = btn.tag;
    self.currentSelectButton = btn;
    [UIView animateWithDuration:.2 animations:^{
        self.animationView.x = btn.x;
        self.animationView.width = btn.width;
    }];
    if (self.delegate2&&[self.delegate2 respondsToSelector:@selector(navMenuScrollView:didClickButtonIndex:)]) {
        [self.delegate2 navMenuScrollView:self didClickButtonIndex:btn.tag];
    }
}

- (void)layoutSubviews
{
    CGFloat w = self.width / self.items.count;
    [self.btns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        obj.x = idx * w;
        obj.width = w;
        obj.height = self.height;
        [self.frames addObject:[NSValue valueWithCGRect:obj.frame]];
    }];
    // 可以修改这个地方适应很多item时的情景， 自定义
    self.contentSize = CGSizeMake(self.width, self.height);
    
    CGRect currentRect = [self.frames[self.currentSelectIndex] CGRectValue];
    self.animationView.x = currentRect.origin.x;
    self.animationView.y = self.height - 1;
    self.animationView.width = currentRect.size.width;
    self.animationView.height = 1;
}

@end
