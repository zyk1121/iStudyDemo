//
//  BSTheme.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/3.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSTheme : NSObject

/*
 "theme_id": "55",
 "theme_type": "1",
 "theme_name": "微视频"
 */
/** 用户名 */
@property (nonatomic, copy) NSString *theme_id;
/** 性别 */
@property (nonatomic, copy) NSString *theme_type;
/** 头像 */
@property (nonatomic, copy) NSString *theme_name;

@end
