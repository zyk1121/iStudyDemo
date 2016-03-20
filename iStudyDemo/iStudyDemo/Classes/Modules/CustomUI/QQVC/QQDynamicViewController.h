//
//  QQDynamicViewController.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/17.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>


@class QQTabbarViewController;
@interface QQDynamicViewController : UITableViewController

@property (nonatomic,weak) QQTabbarViewController *tabbarVC;

@end
