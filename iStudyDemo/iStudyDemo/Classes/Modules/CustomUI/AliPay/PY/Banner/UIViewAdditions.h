//
//  UIViewAdditions.h
//  MTFramework
//
//  Created by 李 帅 on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (Geometry)
/**
 * view.top
 */
@property (nonatomic, assign) CGFloat top;
/**
 * view.bottom
 */
@property (nonatomic, assign) CGFloat bottom;
/**
 * view.left
 */
@property (nonatomic, assign) CGFloat left;
/**
 * view.right
 */
@property (nonatomic, assign) CGFloat right;
/**
 * view.width
 */
@property (nonatomic, assign) CGFloat width;
/**
 * view.height
 */
@property (nonatomic, assign) CGFloat height;
/**
 * view.center.x
 */
@property (nonatomic, assign) CGFloat centerX;
/**
 * view.center.y
 */
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGPoint origin;

@end



@interface UIView (ViewHiarachy)

/**
 * 获取当前view最近的uiviewcontroller。
 */
@property (nonatomic, readonly) UIViewController *viewController;
/**
 * 移除所有子视图。
 */
- (void)removeAllSubviews;

@end



@interface UIView (Gesture)

/**
 * 在当前视图上添加点击事件。
 */


@end

@interface UIView (firstResponder)

- (UIView *)findViewThatIsFirstResponder;
- (NSArray *)descendantViews;

- (UIViewController *)findFirstViewControllerOfClass:(Class)specViewControllerClass;
- (UIView *)findNearestSuperViewWithClass:(Class)superViewClass;

@end

@interface UIView (autoLayout)

- (void)testAmbiguity;

@end

@interface UIView (HitTestExtensions)

@property (nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

@end
