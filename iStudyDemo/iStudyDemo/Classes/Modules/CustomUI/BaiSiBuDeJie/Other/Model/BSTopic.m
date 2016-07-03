//
//  BSTopic.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/2.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSTopic.h"
#import "MJExtension.h"
#import "UIKitMacros.h"

@implementation BSTopic

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"top_cmt":[BSComment class],
             @"themes":[BSTheme class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"topComment":@"top_cmt[0]",
             @"small_image":@"image0",
             @"large_image":@"image1",
             @"middle_image":@"image2"};
}

#pragma mark - getter
- (NSString *)created_at
{
    /*
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    // NSString -> NSDate
    NSDate *createdAtDate = [fmt dateFromString:_created_at];
    
    // 比较【发帖时间】和【手机当前时间】的差值
    NSDateComponents *cmps = [createdAtDate intervalToNow];
    
    if (createdAtDate.isThisYear) {
        if (createdAtDate.isToday) { // 今天
            if (cmps.hour >= 1) { // 时间差距 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1分钟 =< 时间差距 <= 59分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else {
                return @"刚刚";
            }
        } else if (createdAtDate.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:createdAtDate];
        } else { // 今年的其他时间
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:createdAtDate];
        }
    } else { // 非今年
        return _created_at;
    }
     */
    return _created_at;
}

- (CGFloat)cellHeight
{
    if (_cellHeight == 0) {
//        _cellHeight = 44 + 35;
        
        // cell的高度
        _cellHeight = 44 + CommonMargin;
        
        // 计算文字的高度
        CGFloat textW = SCREEN_WIDTH - 2 * CommonMargin;
        CGFloat textH = [self.text boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
        _cellHeight += textH + CommonMargin;
        
        // 中间内容的高度
        if (self.type != BSTopicTypeWord) {
            CGFloat contentW = textW;
            // 图片的高度 * 内容的宽度 / 图片的宽度
            CGFloat contentH = self.height * contentW / self.width;
            if (contentH >= SCREEN_HEIGHT) { // 一旦图片的显示高度超过一个屏幕，就让图片高度为200
                contentH = 200;
                self.bigPicture = YES;
            }
            
            CGFloat contentX = CommonMargin;
            CGFloat contentY = _cellHeight;
            self.contentFrame = CGRectMake(contentX, contentY, contentW, contentH);
            
            _cellHeight += contentH + CommonMargin;
        }
        
        // 最热评论
        if (self.topComment) {
            NSString *username = self.topComment.user.username;
            NSString *content = self.topComment.content;
            NSString *cmtText = [NSString stringWithFormat:@"%@ : %@", username, content];
            // 评论内容的高度
            CGFloat cmtTextH = [cmtText boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
            
            _cellHeight += 20 + cmtTextH + CommonMargin;
        }
        
        // 工具条的高度
        _cellHeight += 35;
    }
    
    return _cellHeight;
}


@end
