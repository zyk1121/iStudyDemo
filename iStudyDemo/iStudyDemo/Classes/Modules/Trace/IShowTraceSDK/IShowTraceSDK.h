//
//  IShowTraceSDK.h
//  IShowTraceSDK
//
//  Created by zhangyuanke on 16/7/13.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IShowTraceServiceDelegate;

#pragma mark - IShowTrace

@interface IShowTrace : NSObject

/**
 *  构造函数
 *
 *  @param ak         用户申请的API key
 *  @param serviceId
 *  @param entityName
 *
 *  @return IShowTrace
 */
- (nonnull instancetype)initWithAk:(NSString * _Nonnull)ak
                         serviceId:(long long)serviceId
                        entityName:(NSString * _Nonnull)entityName;

/**
 *  设置采集周期和打包最小距离
 *
 *  @param gatherInterval   >= 2s（秒）
 *  @param packMinDistance  >= 5m (米)
 *
 *  @return 成功返回YES，其他返回NO
 */
- (BOOL)setInterval:(NSUInteger)gatherInterval
    packMinDistance:(NSUInteger)packMinDistance;

@end

#pragma mark - IShowTraceAction
@interface IShowTraceAction : NSObject

+ (IShowTraceAction * _Nonnull)sharedAction;

/**
 *  开始轨迹服务
 *
 *  @param delegate 轨迹服务的代理
 *  @param trace    轨迹类的对象
 */
- (void)startTrace:(id<IShowTraceServiceDelegate>_Nonnull)delegate
             trace:(IShowTrace * _Nonnull)trace;

/**
 *  结束轨迹服务
 *
 *  @param delegate 轨迹服务的代理
 *  @param trace    轨迹类的对象
 */
- (void)stopTrace:(id<IShowTraceServiceDelegate>_Nonnull)delegate
            trace:(IShowTrace * _Nonnull)trace;

/**
 *  设置采集周期和打包最小距离, 此方法用于已经startTrace服务后想改变采集、打包距离和代理的情况
 *
 *  @param delegate        新的代理
 *  @param gatherInterval  采集周期
 *  @param packMinDistance 最小打包距离
 */
- (void)changeGatherAndPackIntervalsAfterStartTrace:(id<IShowTraceServiceDelegate>_Nonnull)delegate
                                     gatherInterval:(NSUInteger)gatherInterval
                                    packMinDistance:(NSUInteger)packMinDistance;
/**
 *  设置定位相关的属性
 *
 *  @param activityType    定位设备的活动类型 0代表步行，1代表汽车，2代表火车高铁等，3代表其他，目前没有使用
 *  @param desiredAccuracy 需要的定位精度 0代表最高定位精度，此选项定位最为精确，适用于导航等场景，只有手机插上电源才有效； 1代表米级别的定位精度，是不插电源情况下的最高定位精度；2代表十米级别的定位精度；3代表百米级别的定位精度；4代表千米级别的定位精度；5代表最低定位精度，偏移可能达到几公里以上
 *  @param distanceFilter  触发定位的距离阈值, 单位是米
 */
- (void)setAttributeOfLocation:(NSInteger)activityType
               desiredAccuracy:(NSInteger)desiredAccuracy
                distanceFilter:(double)distanceFilter;

@end

#pragma mark - IShowTraceServiceDelegate
/**
 *  轨迹服务的协议,包括轨迹服务相关的回调方法
 */
@protocol IShowTraceServiceDelegate
@optional
/**
 *  开始轨迹服务的回调方法
 *
 *  @param errNo  状态码
 *  @param errMsg 状态信息
 */
- (void)onStartTrace:(NSInteger)errNo errMsg:(NSString * _Nonnull)errMsg;

/**
 *  结束轨迹服务回调方法
 *
 *  @param errNo  状态码
 *  @param errMsg 状态信息
 */
- (void)onStopTrace:(NSInteger)errNo errMsg:(NSString * _Nonnull)errMsg;

@end


