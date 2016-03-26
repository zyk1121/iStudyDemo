//
//  QQChatViewController.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/20.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QQChatViewController : UIViewController
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic)  UITextField *messageField;
@property (strong, nonatomic)  UIButton *speakBtn;
- (void)voiceBtnClick:(UIButton *)sender;
@end
