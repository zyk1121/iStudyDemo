//
//  BSEAllTableViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/2.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSEAllTableViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "BSETitleButton.h"
#import "UIView+Extension.h"
#import "BSTopic.h"
#import "BSRequest.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "BSMeSequare.h"
#import "UIButton+WebCache.h"
#import "BSTopic.h"
#import "MJExtension.h"
#import "BSTopicCell.h"

@interface BSEAllTableViewController ()

@end

@implementation BSEAllTableViewController

- (BSTopicType)type
{
    return BSTopicTypeAll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end