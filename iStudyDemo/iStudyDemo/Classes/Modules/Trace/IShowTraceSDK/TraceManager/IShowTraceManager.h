//
//  IShowTraceManager.h
//  IShowTraceManager
//
//  Created by zhangyuanke on 16/7/13.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IShowTraceObject.h"

@interface IShowTraceManager : NSObject

/**
 *  初始化轨迹管理类，保存的轨迹点时间，轨迹点距离，以及每个文件的轨迹点个数都是默认的，分别是（5s,50m,200）
 *
 *  @param tracePath        轨迹存储路径
 *  @param userName         用户名称
 *
 *  @return 类的实例
 */
- (instancetype)initWithTracePath:(NSString *)tracePath
                         userName:(NSString *)userName;

/**
 *  获取用户的轨迹列表
 *
 *  @return 存放用户轨迹文件路径列表
 */
- (NSArray *)getUserTraceList;

/**
 *  保存轨迹，每10个点强制保存一次文件
 *
 *  @param trace 轨迹数据
 *
 *  @return 成功返回YES，失败返回NO
 */
- (BOOL)saveTrace:(IShowTraceStruct *)trace;

/**
 *  强制保存文件，保存之后文件句柄会关闭
 *
 *  @return 关闭成功返回 YES，失败 返回 NO
 */
- (BOOL)saveForce;

/**
 *  获取某一个轨迹文件中的轨迹点列表
 *
 *  @param traceFilePath 轨迹文件路径
 *
 *  @return 轨迹点IShowTraceStruct列表
 */
- (NSArray *)getTracePointsForPath:(NSString *)traceFilePath;

/**
 *  删除轨迹文件
 *
 *  @param traceFilePath 轨迹文件路径
 *
 *  @return 删除成功，返回YES，其他，返回NO
 */
- (BOOL)deleteTraceFilePath:(NSString *)traceFilePath;

/**
 *  删除所有的轨迹文件
 *
 *  @return 删除成功，返回YES，其他，返回NO
 */
- (BOOL)deleteAllTraceFiles;

@end
