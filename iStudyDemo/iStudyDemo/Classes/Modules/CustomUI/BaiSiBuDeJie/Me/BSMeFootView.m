//
//  BSMeFootView.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/6/30.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSMeFootView.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "BSMeSequare.h"
#import "UIView+Extension.h"
#import "UIButton+WebCache.h"
#import "UIKitMacros.h"
#import "BSMeButton.h"
#import "LEDPortal.h"
#import "LEDWebViewController.h"

@interface BSMeFootView ()
{
    NSMutableArray *_sequares;
}

@end

@implementation BSMeFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _sequares = [[NSMutableArray alloc] init];
        [self sendRequest];
    }
    return self;
}

- (void)sendRequest
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"square";
    params[@"c"] = @"topic";
    self.width  = SCREEN_WIDTH;
    self.height = 0;
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"%@", responseObject);
        [self createSquare:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)createSquare:(NSDictionary *)responseObject
{
    [_sequares removeAllObjects];
    NSArray *array = [responseObject objectForKey:@"square_list"];
    if (array.count == 0) {
        return;
    }
//    NSMutableArray *sequares = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dict = (NSDictionary *)obj;
        BSMeSequare *seq = [BSMeSequare domainWithJSONDictionary:dict];
        if ([seq.name length]) {
            [_sequares addObject:seq];
        }
        
    }];
    
    NSUInteger count = _sequares.count;
    int maxColsCount = 4;
    CGFloat buttonW = self.width / maxColsCount;
    CGFloat buttonH = buttonW;
    for (int i = 0; i < count; i++) {
    
        BSMeSequare *sequare = _sequares[i];
        
        BSMeButton *button = [BSMeButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        [self addSubview:button];
        button.tag = i;
        
        button.x = (i % maxColsCount) *buttonW;
        button.y = (i / maxColsCount) *buttonH;
        button.width = buttonW - 1;
        button.height = buttonH - 1;
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
//        button.backgroundColor = [UIColor redColor];
        [button setTitle:sequare.name forState:UIControlStateNormal];
        [button sd_setImageWithURL:[NSURL URLWithString:sequare.icon]
                          forState:UIControlStateNormal
                  placeholderImage:[UIImage imageNamed:@"setup-head-default"]];
    }
    self.height = self.subviews.lastObject.y + self.subviews.lastObject.height;
    
    // 重设tableFootView
    UITableView *tableView = (UITableView *)self.superview;
    tableView.tableFooterView = self;
}

#pragma mark - event

- (void)buttonClicked:(BSMeButton *)button
{
    BSMeSequare *sequare = _sequares[button.tag];
    NSString *url = @"http://www.baidu.com";
    if ([sequare.linkURL length] && [sequare.linkURL containsString:@"http"]) {
        url = sequare.linkURL;
    }
    LEDWebViewController *webView = [[LEDWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    [self.vc.navigationController pushViewController:webView animated:YES];
}

@end
