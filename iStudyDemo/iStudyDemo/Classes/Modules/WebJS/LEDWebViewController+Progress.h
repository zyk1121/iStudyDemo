//
//  LEDWebViewController+Progress.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//
//

#import "LEDWebViewController.h"

@interface LEDWebViewController (Progress)

+ (BOOL)progressEnabled;

+ (void)enableProgress:(BOOL)isEnabled;

@end


@interface LEDWebViewControllerProgressProxy : NSObject

- (instancetype)initWithLEDWebViewController: (LEDWebViewController *)viewController;

@end

