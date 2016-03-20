//
//  QQLeftViewController.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/20.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHCZMainView,QQTabbarViewController;
@interface QQSideBarViewController : UIViewController

@property (nonatomic, strong) SHCZMainView *leftView;
@property (nonatomic, strong) QQTabbarViewController *tabVC;

- (void)maskViewClicked;
- (void)addPanGesture;
- (void)removePanGesture;
@end
