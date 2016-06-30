//
//  BSMeFootView.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/6/30.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSMeFootView.h"
#import "AFNetworking.h"

@implementation BSMeFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self sendRequest];
    }
    return self;
}

- (void)sendRequest
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"square";
    params[@"c"] = @"topic";
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
