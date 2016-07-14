//
//  IShowTraceManager.mm
//  IShowTraceManager
//
//  Created by zhangyuanke on 16/7/13.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "IShowTraceManager.h"

#define kIShowMaxSaveCount 20 // 最大的文件保存个数限制，count大于这个数强制保存数据
#define kIShowTraceFileKey @"iShowTrace_" // 后面跟用户名作为key存储当前用户的文件信息，当前文件名称索引
#define kIShowUnknowUser   @"unknownUser"

#pragma mark - IShowTraceManager

@interface IShowTraceManager()
{
    NSString *_tracePath; // 轨迹路径
    NSString *_userName;    // 用户名
    NSUInteger _timeInterval; // 时间间隔，默认5s
    NSUInteger _distanceInterval; // 距离间隔，默认50m
    NSUInteger _maxCountForPage; // 每一个文件保存的最大轨迹点的个数，默认 200
    NSUInteger _currentPageCount; // 当前文件记录的轨迹点个数
    
    NSString *_traceFileKey;    // 轨迹文件信息Key
    NSUInteger _count;  // 记录点的个数
    IShowTraceStruct *_lastTrace; // 上一个轨迹点，目前没有使用
    
    NSFileHandle *_fileHandler;
}
@end

@implementation IShowTraceManager

/**
 *  初始化轨迹管理类，保存的轨迹点时间，轨迹点距离，以及每个文件的轨迹点个数都是默认的，分别是（5s,50m,200）
 *
 *  @param tracePath        轨迹存储路径
 *  @param userName         用户名称
 *
 *  @return 类的实例
 */
- (instancetype)initWithTracePath:(NSString *)tracePath
                         userName:(NSString *)userName
{
    return [self initWithTracePath:tracePath
                          userName:userName
                      timeInterval:5
                  distanceInterval:50
                   maxCountForPage:200];
}

/**
 *  初始化轨迹管理类
 *
 *  @param tracePath        轨迹存储路径
 *  @param userName         用户名称
 *  @param timeInterval     保存轨迹点时间间隔，默认5s
 *  @param distanceInterval 保存轨迹点距离间隔，默认50m
 *  @param maxCountForPage  一个文件最大保存的轨迹点的个数，默认200
 *
 *  @return 类的实例
 */
- (instancetype)initWithTracePath:(NSString *)tracePath
                         userName:(NSString *)userName
                     timeInterval:(NSUInteger)timeInterval
                 distanceInterval:(NSUInteger)distanceInterval
                  maxCountForPage:(NSUInteger)maxCountForPage;
{
    self = [super init];
    if (self) {
        if ([tracePath length] == 0) {
            return nil;
        }
        _tracePath = tracePath;
        _userName = [userName length] > 0 ? userName : kIShowUnknowUser;
        _timeInterval = timeInterval;
        _distanceInterval = distanceInterval;
        _maxCountForPage = maxCountForPage;
    
        [self setupData];
        
    }
    return self;
}

/**
 *  获取用户的轨迹列表
 *
 *  @return 存放用户轨迹文件路径列表
 */
- (NSArray *)getUserTraceList
{
    NSString *userPath = [NSString stringWithFormat:@"%@/%@", _tracePath, _userName];
    NSArray *tempFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:userPath error:nil];
    NSMutableArray *userTraceList = [[NSMutableArray alloc] init];
    [tempFiles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [userTraceList addObject:[NSString stringWithFormat:@"%@/%@",userPath,(NSString *)obj]];
    }];
    return userTraceList;
}

/**
 *  保存轨迹，每10个点强制保存一次文件
 *
 *  @param trace 轨迹数据
 *
 *  @return 成功返回YES，失败返回NO
 */
- (BOOL)saveTrace:(IShowTraceStruct *)trace
{
    if (!_fileHandler) {
        [self updateTraceFileInfo];
        [self saveTrace:trace];
    }
    // 保存轨迹
    BOOL ret = [self _saveTrace:trace];
    if (ret) {
        // 轨迹保存成功
        _currentPageCount += 1;
        _count += 1;
        if (_currentPageCount >= _maxCountForPage) {
            [self createNextTraceFile];
        }
        if (_count >= kIShowMaxSaveCount) {
            [_fileHandler closeFile];
            _fileHandler = [NSFileHandle fileHandleForWritingAtPath:[self getCurrentFilePathName]];
            [_fileHandler seekToEndOfFile];
            _count = 0;
        }
    } else {
        return NO;
    }

    return YES;
}

/**
 *  强制保存文件，保存之后文件句柄会关闭
 *
 *  @return 关闭成功返回 YES，失败 返回 NO
 */
- (BOOL)saveForce
{
    [_fileHandler closeFile];
    _fileHandler = nil;
    return YES;
}

/**
 *  获取某一个轨迹文件中的轨迹点列表
 *
 *  @param traceFilePath 轨迹文件路径
 *
 *  @return 轨迹点IShowTraceStruct列表
 */
- (NSArray *)getTracePointsForPath:(NSString *)traceFilePath
{
    [_fileHandler closeFile];
    _fileHandler = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:traceFilePath]) {
        _fileHandler = [NSFileHandle fileHandleForReadingAtPath:traceFilePath];
        NSData *data = [_fileHandler readDataToEndOfFile];
        NSString *tempStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [_fileHandler closeFile];
        NSMutableArray *traceStructArray = [[NSMutableArray alloc] init];
        NSArray *array = [tempStr componentsSeparatedByString:@"\n"];
        for (int i = 0; i < array.count - 1; i++) {
            NSString *valueString = array[i];
            if ([valueString length]) {
                NSArray *valueArray = [valueString componentsSeparatedByString:@","];
                // 判断，写入数据
                if (valueArray.count > 5) {
                    IShowTraceStruct *trace = [[IShowTraceStruct alloc] init];
                    trace.create_time = valueArray[0];
                    [traceStructArray addObject:trace];
                }
            }
        }
        return traceStructArray;
    }
    return nil;
}

/**
 *  删除轨迹文件
 *
 *  @param traceFilePath 轨迹文件路径
 *
 *  @return 删除成功，返回YES，其他，返回NO
 */
- (BOOL)deleteTraceFilePath:(NSString *)traceFilePath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:traceFilePath]) {
        if ([[NSFileManager defaultManager] removeItemAtPath:traceFilePath error:nil]) {
            return YES;
        } else {
            return NO;
        }
    }
    // 文件不存在
    return YES;
}

/**
 *  删除所有的轨迹文件（当前用户）
 *
 *  @return 删除成功，返回YES，其他，返回NO
 */
- (BOOL)deleteAllTraceFiles
{
    [_fileHandler closeFile];
    _fileHandler = nil;
    NSString *userPath = [NSString stringWithFormat:@"%@/%@", _tracePath, _userName];
    if ([[NSFileManager defaultManager] removeItemAtPath:userPath error:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:_traceFileKey];
        return YES;
    }
    return NO;
}

#pragma mark - private method

- (void)setupData
{
    // 路径创建
    NSString *userPath = [NSString stringWithFormat:@"%@/%@", _tracePath, _userName];
    [[NSFileManager defaultManager] createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
    // 轨迹文件信息Key
    _traceFileKey = [NSString stringWithFormat:@"%@%@", kIShowTraceFileKey, _userName];
    // 轨迹文件信息
    NSNumber *index = [[NSUserDefaults standardUserDefaults] objectForKey:_traceFileKey];
    if (index == nil) {
        [self createNextTraceFile];
    } else {
        // 更新轨迹信息
        [self updateTraceFileInfo];
    }
}

- (NSString *)getCurrentFilePathName
{
    NSNumber *index = [[NSUserDefaults standardUserDefaults] objectForKey:_traceFileKey];
    NSInteger indexNumber = [index integerValue];
    // 当前的文件名
    NSString *fileName = [NSString stringWithFormat:@"%zd.csv", indexNumber];
    NSString *filePathName = [NSString stringWithFormat:@"%@/%@/%@", _tracePath,_userName,fileName];
    return filePathName;
}

- (void)updateTraceFileInfo
{
    [_fileHandler closeFile];
    _fileHandler = nil;
    NSNumber *index = [[NSUserDefaults standardUserDefaults] objectForKey:_traceFileKey];
    if (index) {
        NSString *filePathName = [self getCurrentFilePathName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePathName]) {
            [[NSFileManager defaultManager] createFileAtPath:filePathName contents:nil attributes:nil];
            _fileHandler = [NSFileHandle fileHandleForWritingAtPath:filePathName];
            _lastTrace = nil;
        } else {
            // 读取当前的文件信息点的个数
            _currentPageCount = [self getTracePointCountForFile:filePathName];
            if (_currentPageCount >= _maxCountForPage) {
                //  创建下一个文件
                [self createNextTraceFile];
            } else {
                _fileHandler = [NSFileHandle fileHandleForWritingAtPath:filePathName];
                [_fileHandler seekToEndOfFile];
            }
        }
    } else {
         [self createNextTraceFile];
    }
}

- (NSUInteger)getTracePointCountForFile:(NSString *)filePath
{
    [_fileHandler closeFile];
    _fileHandler = nil;
    _fileHandler = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData *data = [_fileHandler readDataToEndOfFile];
    NSString *tempStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [_fileHandler closeFile];
    NSArray *array = [tempStr componentsSeparatedByString:@"\n"];
    return array.count > 0 ? [array count] - 1 : 0;
}

- (void)createNextTraceFile
{
    [_fileHandler closeFile];
    _fileHandler = nil;
    NSNumber *index = [[NSUserDefaults standardUserDefaults] objectForKey:_traceFileKey];
    NSInteger indexNumber = 0;
    if (index) {
        indexNumber = [index integerValue];
        indexNumber += 1;
    } else {
        indexNumber = 1;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(indexNumber) forKey:_traceFileKey];
    NSString *filePathName = [self getCurrentFilePathName];
    [[NSFileManager defaultManager] createFileAtPath:filePathName contents:nil attributes:nil];
    _fileHandler = [NSFileHandle fileHandleForWritingAtPath:filePathName];
    _currentPageCount = 0;
    _count = 0;
    _lastTrace = nil;
}

- (BOOL)_saveTrace:(IShowTraceStruct *)trace
{
    // 根据指定的规则保存轨迹
    NSString *saveStr = [NSString stringWithFormat:@"%@,%@,%lf,%lf,%zd,%lf,%lf\n",trace.create_time,trace.entity_name,trace.longitude,trace.latitude,trace.loc_time,trace.speed,trace.direction];
    [_fileHandler writeData:[NSData dataWithBytes:[saveStr cStringUsingEncoding:NSUTF8StringEncoding] length:[saveStr length]]];
    return YES;
}

- (void)dealloc
{
    [_fileHandler closeFile];
    _fileHandler = nil;
}

@end