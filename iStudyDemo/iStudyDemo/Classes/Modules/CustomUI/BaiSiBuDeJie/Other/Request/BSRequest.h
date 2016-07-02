//
//  BSRequest.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/2.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSRequest : NSObject

+ (void)doRequestWithParams:(NSDictionary *)params
                    success:(void (^)(NSArray *response))success
                    failure:(void (^)(NSError *error))failure;

@end
