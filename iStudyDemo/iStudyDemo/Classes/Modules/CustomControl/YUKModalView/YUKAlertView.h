//
//  YUKAlertView.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/8/7.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YUKAlertViewDelegate <NSObject>

@optional
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)YUKAlertViewClickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface YUKAlertView : UIView

+ (void)showWithTitle:(nullable NSString *)title
              message:(nullable NSString *)message
             delegate:(nullable id)delegate
         buttonTitles:(nullable NSArray *)buttonTitles;

@end
