//
//  DeviceInfoViewController.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/14.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (SAKAnalytics)
- (NSString *)saka_platformString;
- (NSString *)saka_macAddress;
@end

@interface DeviceInfoViewController : UIViewController

@end
