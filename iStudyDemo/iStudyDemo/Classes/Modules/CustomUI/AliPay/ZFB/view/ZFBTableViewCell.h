//
//  ZFBTableViewCell.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/24.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFBTableViewCell : UITableViewCell

@property (nonatomic, assign) CGFloat cellHeight;
- (instancetype)initWithIcons:(NSArray *)icons;

@property (nonatomic,weak) UIViewController *vc;

@end
