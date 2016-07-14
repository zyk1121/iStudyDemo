//
//  IShowTraceSDK.m
//  IShowTraceSDK
//
//  Created by zhangyuanke on 16/7/13.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "IShowTraceSDK.h"
#import "IShowTraceManager.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "IShowTraceManager.h"
#import "IShowTraceObject.h"
#import "IShowReachability.h"

#pragma mark - IShowTrace

@interface IShowTrace()
{
    NSUInteger _gatherInterval;
    NSUInteger _packMinDistance;
}
@property (nonatomic, copy) NSString *ak;
@property (nonatomic, assign) long long serviceId;
@property (nonatomic, copy) NSString *entityName;
@property (nonatomic, strong) IShowTraceManager *traceManager;

@end

@implementation IShowTrace

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
                        entityName:(NSString * _Nonnull)entityName
{
    self = [super init];
    if (self) {
        _ak = ak;
        _serviceId = serviceId;
        _entityName = entityName;
        _gatherInterval = 5;
        _packMinDistance = 50;
        
        [self initTraceManager];
    }
    return self;
}

- (void)initTraceManager
{
    NSString *tracePath = [NSString stringWithFormat:@"%@/Documents/Trace", NSHomeDirectory()];
    _traceManager = [[IShowTraceManager alloc] initWithTracePath:tracePath userName:_entityName];
}

/**
 *  设置采集周期和打包最小距离
 *
 *  @param gatherInterval   >= 2s（秒）
 *  @param packMinDistance  >= 5m (米)
 *
 *  @return 成功返回YES，其他返回NO
 */
- (BOOL)setInterval:(NSUInteger)gatherInterval
    packMinDistance:(NSUInteger)packMinDistance
{
    _gatherInterval = gatherInterval;
    _packMinDistance = packMinDistance;
    return YES;
}

@end

#pragma mark - IShowTraceAction
@interface IShowTraceAction()<CLLocationManagerDelegate>
{
    IShowReachability* _reachability;
    BOOL _networkReachability;
}
@property (nonatomic, strong) IShowTrace *trace;
@property (nonatomic, weak) id<IShowTraceServiceDelegate> delegate;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *lastLocation;// 上一个位置

@end

@implementation IShowTraceAction

+ (IShowTraceAction * _Nonnull)sharedAction
{
    static IShowTraceAction *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initReachability];
        
        _locationManager = [[CLLocationManager alloc] init];
        // 设置定位精度，十米，百米，最好
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
                [_locationManager requestAlwaysAuthorization];
            }
        }
        if ([[UIDevice currentDevice].systemVersion floatValue] > 9)
        {
            // iOS9新特性
            [self.locationManager setAllowsBackgroundLocationUpdates:YES];
        }
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        _locationManager.distanceFilter = 10;
        _locationManager.delegate = self;
    }
    return self;
}

/**
 *  开始轨迹服务
 *
 *  @param delegate 轨迹服务的代理
 *  @param trace    轨迹类的对象
 */
- (void)startTrace:(id<IShowTraceServiceDelegate>_Nonnull)delegate
             trace:(IShowTrace * _Nonnull)trace
{
    _trace = trace;
    // 开启定位
    [_locationManager startUpdatingLocation];
}

/**
 *  结束轨迹服务
 *
 *  @param delegate 轨迹服务的代理
 *  @param trace    轨迹类的对象
 */
- (void)stopTrace:(id<IShowTraceServiceDelegate>_Nonnull)delegate
            trace:(IShowTrace * _Nonnull)trace
{
    _trace = trace;
    // 关闭定位
    [_locationManager stopUpdatingLocation];
    [self.trace.traceManager saveForce];
}

/**
 *  设置采集周期和打包最小距离, 此方法用于已经startTrace服务后想改变采集、打包距离和代理的情况
 *
 *  @param delegate        新的代理
 *  @param gatherInterval  采集周期
 *  @param packMinDistance 最小打包距离
 */
- (void)changeGatherAndPackIntervalsAfterStartTrace:(id<IShowTraceServiceDelegate>_Nonnull)delegate
                                     gatherInterval:(NSUInteger)gatherInterval
                                    packMinDistance:(NSUInteger)packMinDistance
{
    // 更改
}
/**
 *  设置定位相关的属性
 *
 *  @param activityType    定位设备的活动类型 0代表步行，1代表汽车，2代表火车高铁等，3代表其他，目前没有使用
 *  @param desiredAccuracy 需要的定位精度 0代表最高定位精度，此选项定位最为精确，适用于导航等场景，只有手机插上电源才有效； 1代表米级别的定位精度，是不插电源情况下的最高定位精度；2代表十米级别的定位精度；3代表百米级别的定位精度；4代表千米级别的定位精度；5代表最低定位精度，偏移可能达到几公里以上
 *  @param distanceFilter  触发定位的距离阈值, 单位是米
 */
- (void)setAttributeOfLocation:(NSInteger)activityType
               desiredAccuracy:(NSInteger)desiredAccuracy
                distanceFilter:(double)distanceFilter
{
    // 更新定位信息
}

- (void)dealloc
{
    [_reachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private

- (void)initReachability
{
    _reachability = [IShowReachability reachabilityWithHostname:@"www.ishowchina.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kIShowReachabilityChangedNotification
                                               object:nil];
    [_reachability startNotifier];
}

- (void)reachabilityChanged:(NSNotification*)note {
    IShowReachability *reachability = [note object];
    _networkReachability = reachability.isReachable;// 网络是否可用
}

/**
 *  当前位置能否上报
 *
 *  @param location
 *
 *  @return 能上报返回YES，否则返回NO
 */
- (BOOL)canUploadForLocation:(CLLocation *)location
{
    // lastLocation
    return YES;
}

/**
 *  上报位置
 *
 *  @param location
 */
- (void)uploadLocation:(CLLocation *)location
{
    // 1.判断是否满足条件，时间和距离
    
    // 2.判断网络
    
    // 3.网络正常直接单点上报
    
    // 4.网络不正常，入库
    
    [self.trace.traceManager saveTrace:[self convertIShowTraceStructFromCLLocation:location andIShowTrace:self.trace]];
   
    
    // 5.入库文件查询，有文件，上报文件，（上报成功删除文件）
    
    // 删除文件测试
//    [self.trace.traceManager deleteAllTraceFiles];
//    NSArray *arr = [self.trace.traceManager getUserTraceList];
//    NSArray *aa = [self.trace.traceManager getTracePointsForPath:arr[0]];
//    
//    [self.trace.traceManager deleteAllTraceFiles];
}

- (IShowTraceStruct *)convertIShowTraceStructFromCLLocation:(CLLocation *)location andIShowTrace:(IShowTrace * _Nonnull)trace
{
    IShowTraceStruct *tempTrace  =[[IShowTraceStruct alloc] init];
    tempTrace.create_time = @"2016-07-14 18:23:43";
    tempTrace.entity_name = trace.entityName;
//    tempTrace.entity_name = @"abc";
    tempTrace.longitude = location.coordinate.longitude;
    tempTrace.latitude = location.coordinate.latitude;
    tempTrace.loc_time = 1468231090;
    tempTrace.speed = 12.3;
    tempTrace.direction = 30;
    tempTrace.custom_field = nil;
    
    return tempTrace;
}



#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    // 定位失败
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [self uploadLocation:[locations lastObject]];
}

@end
