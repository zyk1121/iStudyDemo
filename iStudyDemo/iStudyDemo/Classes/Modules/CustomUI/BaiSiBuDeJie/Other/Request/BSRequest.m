//
//  BSRequest.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/2.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSRequest.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "BSMeSequare.h"
#import "UIView+Extension.h"
#import "UIButton+WebCache.h"
#import "UIKitMacros.h"
#import "BSMeButton.h"
#import "LEDPortal.h"
#import "BSTopic.h"
#import "MJExtension.h"

@implementation BSRequest

+ (void)doRequestWithParams:(NSDictionary *)params
                    success:(void (^)(NSArray *response))success
                    failure:(void (^)(NSError *error))failure
{
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            success([self convertFromResponseToData:responseObject]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (NSArray *)convertFromResponseToData:(NSDictionary *)dicResponse
{
    if (dicResponse) {
        NSMutableArray *retArray = nil;
        NSArray *tempArray = dicResponse[@"list"];
        retArray = [BSTopic mj_objectArrayWithKeyValuesArray:tempArray];
//        if (tempArray) {
//            [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                NSDictionary *dict = (NSDictionary *)obj;
//                BSTopic *topic = [BSTopic mj_objectArrayWithKeyValuesArray:tempArray];
//                if (topic) {
//                    [retArray addObject:topic];
//                }
//            }];
//        }
        return retArray;
    }
    return nil;
}

@end
