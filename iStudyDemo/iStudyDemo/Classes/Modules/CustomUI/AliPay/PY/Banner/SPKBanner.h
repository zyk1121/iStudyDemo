//
//  KBViewController.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/23.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SPKBanner : NSObject

@property (nonatomic, strong) NSURL *imgURL;
@property (nonatomic, strong) NSURL *linkURL;
@property (nonatomic, strong) UIImage *image;

// 外部如果没有image的话可以传入nil
- (instancetype)initWithImageURL:(NSURL *)imgURL
                         linkURL:(NSURL *)linkURL
                        andImage:(UIImage *)image;

@end
