//
//  YUKToastView.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/8/7.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>

// 不适合做toast
typedef NS_ENUM(NSUInteger, YUKToastViewPosition) {
    YUKToastViewPositionBottom,
    YUKToastViewPositionCenter,
    YUKToastViewPositionTop,
};

@interface YUKToastView : UIView

+ (void)showMessage:(NSString*)message;
+ (void)showMessage:(NSString*)message duration:(float)duration;
+ (void)showMessage:(NSString*)message duration:(float)duration position:(YUKToastViewPosition)position;

@end
