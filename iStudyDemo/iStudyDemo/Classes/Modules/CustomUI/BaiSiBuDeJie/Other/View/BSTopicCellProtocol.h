//
//  BSTopicCellProtocol.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/3.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSTopic.h"

typedef enum {
    BSTopicEventTypeMoreButtonNone,
    BSTopicEventTypeMoreButtonClick,
} BSTopicEventType;

@protocol BSTopicCellDelegate <NSObject>

@optional
// 事件的传递
- (void)preformActionForType:(BSTopicEventType)type andTopicData:(BSTopic *)topic;

@end
