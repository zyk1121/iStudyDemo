//
//  ZFBCollectionViewCell.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/24.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFBCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, copy) NSString *title;

- (void)setupUI;

@end
