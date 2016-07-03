//
//  BSTopicHeaderView.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/3.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSTopic.h"

@protocol BSTopicHeaderViewDelegate <NSObject>

@optional
- (void)moreButtonClicked;

@end

@interface BSTopicHeaderView : UIView

@property (nonatomic, weak) id<BSTopicHeaderViewDelegate> delegate;
@property (nonatomic, strong) BSTopic *dataSource;

@end
