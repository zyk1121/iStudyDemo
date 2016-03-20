//
//  UIImage+IPLImageKit.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/17.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (IPLImageKit)
// 图像缩放到指定的size
- (UIImage *)scaleToSize:(CGSize)size;
// 图像缩放到指定的比例scale
- (UIImage *)scaleToScale:(CGFloat)scale;

@end
