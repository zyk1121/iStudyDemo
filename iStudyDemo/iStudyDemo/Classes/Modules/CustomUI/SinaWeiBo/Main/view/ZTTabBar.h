//
//  ZTTabBar.h
//  SinaWeibo
//
//  Created by user on 15/10/16.
//  Copyright © 2015年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

// 自定义
@class ZTTabBar;

// ZTTabBar继承自UITabBar，所以ZTTabBar的代理必须遵循UITabBar的代理协议！
@protocol ZTTabBarDelegate <UITabBarDelegate>

@optional

- (void)tabBarDidClickPlusButton:(ZTTabBar *)tabBar;

@end

@interface ZTTabBar : UITabBar

@property (nonatomic, weak) id<ZTTabBarDelegate> delegate;

@end


@interface ZTTabBar2 : UITabBar

@property (nonatomic, weak) id<ZTTabBarDelegate> delegate;

@end
