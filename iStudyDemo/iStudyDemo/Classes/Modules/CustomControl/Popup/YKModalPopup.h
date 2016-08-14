//
//  YKModalPopup.h
//  YKModalPopup
//
//  Created by zhangyuanke on 16/8/14.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol YKModalPopupDelegate <NSObject>

@optional
- (void)modalPopupBackgroundBeTouched;

@end

@interface YKModalPopup : NSObject

+ (instancetype)sharedInstance;

+ (void)showWithCustomView:(UIView *)customView delegate:(id<YKModalPopupDelegate>)delegate;
+ (void)showWithCustomView:(UIView *)customView delegate:(id<YKModalPopupDelegate>)delegate forced:(BOOL)forced;

+ (void)dismiss;

@end
