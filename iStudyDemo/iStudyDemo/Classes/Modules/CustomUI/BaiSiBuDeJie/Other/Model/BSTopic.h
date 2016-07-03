//
//  BSTopic.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/2.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LEDDomainObject.h"
#import "BSComment.h"
#import "BSUser.h"
#import "BSTag.h"
#import "BSTheme.h"


typedef enum {
    /** 全部 */
    BSTopicTypeAll = 1,
    
    /** 图片 */
    BSTopicTypePicture = 10,
    
    /** 段子(文字) */
    BSTopicTypeWord = 29,
    
    /** 声音 */
    BSTopicTypeAudio = 31,
    
    /** 视频 */
    BSTopicTypeVideo = 41
} BSTopicType;

@interface BSTopic : NSObject

/** id */
@property (nonatomic, copy) NSString *ID; // id
// 用户 -- 发帖者
/** 用户的名字 */
@property (nonatomic, copy) NSString *name;
/** 用户的头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 帖子的文字内容 */
@property (nonatomic, copy) NSString *text;
/** 帖子审核通过的时间 */
@property (nonatomic, copy) NSString *created_at;
/** 顶数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发\分享数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论数量 */
@property (nonatomic, assign) NSInteger comment;
/** 类型 */
@property (nonatomic, assign) BSTopicType type;
/** 图片的宽度 */
@property (nonatomic, assign) CGFloat width;
/** 图片的高度 */
@property (nonatomic, assign) CGFloat height;

/** 主题 */
@property (nonatomic, copy) NSArray<BSTheme *>* themes;

/** 小图 */
@property (nonatomic, copy) NSString *small_image; // image0
/** 大图 */
@property (nonatomic, copy) NSString *large_image; // image1
/** 中图 */
@property (nonatomic, copy) NSString *middle_image; // image2

/** 是否为动态图 */
@property (nonatomic, assign) BOOL is_gif;

/** 视频的时长 */
@property (nonatomic, assign) NSInteger videotime;
/** 音频的时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 播放数量 */
@property (nonatomic, assign) NSInteger playcount;

/** 最热评论 */
//@property (nonatomic, strong) NSArray<BSComment *> *topComment;
@property (nonatomic, strong) BSComment *topComment;



/***** 额外增加的属性 ******/
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 中间内容的frame */
@property (nonatomic, assign) CGRect contentFrame;
/** 是否大图片 */
@property (nonatomic, assign, getter=isBigPicture) BOOL bigPicture;

@end
