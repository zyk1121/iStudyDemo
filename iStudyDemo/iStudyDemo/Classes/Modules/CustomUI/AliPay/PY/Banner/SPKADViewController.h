//
//  KBViewController.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/23.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPKBanner;
@interface SPKADViewController : UIViewController

@property (nonatomic, copy) NSArray *bannerArray;

@property (nonatomic, copy) void (^didClickBannerBlock)(SPKBanner *banner);
@property (nonatomic, copy) void (^bannerImgLoadingFinishedBlock)(BOOL haveImage);

@end
