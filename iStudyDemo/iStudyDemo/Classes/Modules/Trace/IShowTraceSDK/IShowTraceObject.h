//
//  IShowTraceObject.h
//  IShowTraceSDK
//
//  Created by zhangyuanke on 16/7/13.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>

// 轨迹数据结构
@interface IShowTraceStruct : NSObject

@property(nonatomic, copy) NSString *create_time;
@property(nonatomic, copy) NSString *entity_name;
@property(nonatomic, assign) double longitude;
@property(nonatomic, assign) double latitude;
@property(nonatomic, assign) long   loc_time;
@property(nonatomic, assign) double speed;
@property(nonatomic, assign) double direction;

@property(nonatomic, strong) NSDictionary *custom_field;

@end


