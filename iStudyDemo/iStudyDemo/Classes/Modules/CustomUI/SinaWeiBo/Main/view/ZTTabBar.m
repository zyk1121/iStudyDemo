//
//  ZTTabBar.m
//  SinaWeibo
//
//  Created by user on 15/10/16.
//  Copyright © 2015年 ZT. All rights reserved.
//

#import "ZTTabBar.h"
#import "UIView+Extension.h"

@interface ZTTabBar ()

@property (nonatomic, weak) UIButton *plusBtn;

@end

@implementation ZTTabBar

@dynamic delegate;


// 之前的方法
/*
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        
        plusBtn.size = plusBtn.currentBackgroundImage.size;
        [plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
    }
    return self;
}
*/



/*
 // tabbar 去除上黑色边框，在WeiboMainViewController  中调用
 [self.tabBar setBackgroundImage:[[UIImage alloc] init]];
 [self.tabBar setShadowImage:[[UIImage alloc] init]];
 
 // tabbar 添加背景颜色
 UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
 backView.backgroundColor = [UIColor grayColor];
 [self.tabBar insertSubview:backView atIndex:0];
 self.tabBar.opaque = YES;
 
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor clearColor];
        
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];

        // 修改中间按钮的值，使其适应超出tabbar的范围，如果需要其相应还需要 重写- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
        plusBtn.size = CGSizeMake(100, 200);//plusBtn.currentBackgroundImage.size;
        [plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;

    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    /**
     *  当point在+按钮的frame内的话，返回YES
     */
    if (CGRectContainsPoint(self.plusBtn.frame, point)) {
        return YES;
    }
    
    if (point.y >= 0) {
        return YES;
    }
    return NO;
}


/**
 *  加号按钮点击
 */
- (void)plusBtnClick
{
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.delegate tabBarDidClickPlusButton:self];
    }
}

/**
 *  想要重新排布系统控件subview的布局，推荐重写layoutSubviews，在调用父类布局后重新排布。
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
   // self.frame  =CGRectMake(self.frame.origin.x, self.frame.origin.y - 50, self.frame.size.width, 100);
    // 可以修改frame的值
    
    // 1.设置加号按钮的位置
    self.plusBtn.centerX = self.width*0.5;
    self.plusBtn.centerY = self.height*0.5;
    
//    CGRect fff = self.plusBtn.frame;
    
    // 2.设置其他tabbarButton的frame
    CGFloat tabBarButtonW = self.width / 5;
    CGFloat tabBarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置x
            child.x = tabBarButtonIndex * tabBarButtonW;
            // 设置宽度
            child.width = tabBarButtonW;
            // 增加索引
            tabBarButtonIndex++;
            if (tabBarButtonIndex == 2) {
                tabBarButtonIndex++;
            }
        }
    }
}

@end
