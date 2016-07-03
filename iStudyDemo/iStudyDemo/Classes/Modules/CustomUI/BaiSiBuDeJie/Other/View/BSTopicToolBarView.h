//
//  BSTopicToolBarView.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/3.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSTopic.h"

typedef enum {
    BSTopicToolBarButtonTypeNone,
    BSTopicToolBarButtonTypeDing,
    BSTopicToolBarButtonTypeCai,
    BSTopicToolBarButtonTypePost,
    BSTopicToolBarButtonTypeComment,
} BSTopicToolBarButtonType;


@protocol BSTopicToolBarViewDelegate <NSObject>

@optional
- (void)toolButtonClicked:(BSTopicToolBarButtonType)buttonType;

@end

@interface BSTopicToolBarView : UIView

@property (nonatomic, weak) id<BSTopicToolBarViewDelegate> delegate;
@property (nonatomic, strong) BSTopic *dataSource;

@end
