//
//  ObjectStorageManager.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/8.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "ObjectStorageManager.h"
#import <CommonCrypto/CommonDigest.h>

static NSString * const kLeadorComPath = @"com.leaor.cn";
static NSString * const kLeaderGuestPath = @"guest";


@interface NSFileManager (LeadorFoundation)
@end
@implementation NSFileManager (LeadorFoundation)

- (NSString *)destinationPathForMovingWithPath_:(NSString *)path
{
    if ([self fileExistsAtPath:path]) {
        NSString *fileName = [[path lastPathComponent] stringByDeletingPathExtension];
        NSString *fileExtension = [[path lastPathComponent] pathExtension];
        
        NSString *fileDirectory = [path stringByDeletingLastPathComponent];
        double timeInterval = [[NSDate date] timeIntervalSince1970];
        
        NSString *dstFileName = [fileName stringByAppendingFormat:@"%.2f", timeInterval];
        NSString *dstPath = [[fileDirectory stringByAppendingPathComponent:dstFileName] stringByAppendingPathExtension:fileExtension];
        
        return dstPath;
    } else {
        return path;
    }
}

- (void)clearTrashAtPath_:(NSString *)path
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        [self removeItemAtPath:path error:&error];
        if (error) {
            NSLog(@"%@", [error debugDescription]);
        }
    });
}

- (void)removeItemAtPathSafely:(NSString *)path
{
    BOOL isDirectory;
    BOOL fileExists = [self fileExistsAtPath:path isDirectory:&isDirectory];
    if (!fileExists) {
        return;
    }
    
    NSString *fileDirectory = [path stringByDeletingLastPathComponent];
    NSString *trashDirectory = [NSTemporaryDirectory() stringByAppendingPathComponent:fileDirectory];
    if (![self fileExistsAtPath:trashDirectory]) {
        [self createDirectoryAtPath:trashDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    NSString *fileName = [path lastPathComponent];
    NSString *dstPath = [self destinationPathForMovingWithPath_:[trashDirectory stringByAppendingPathComponent:fileName]];
    
    NSError *error = nil;
    [self moveItemAtPath:path toPath:dstPath error:&error];
    if (error) {
        NSLog(@"%@", [error debugDescription]);
    } else {
        [self clearTrashAtPath_:dstPath];
    }
}

- (void)removeItemAtURLSafely:(NSURL *)URL
{
    NSError *error = nil;
    BOOL fileExists = [URL checkResourceIsReachableAndReturnError:&error];
    if (!fileExists) {
        return;
    } else {
        [self removeItemAtPathSafely:[URL path]];
    }
}

@end

@interface NSString (Hash)

- (NSString *)stringByComputingMD5;

@end

@interface ObjectStorageManager () {
    dispatch_queue_t _queue;
}

@property (nonatomic, copy) NSString *rootPath;

@end

@implementation ObjectStorageManager

+ (instancetype)sharedObjectManager
{
    static ObjectStorageManager *sharedObjectManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObjectManager = [[ObjectStorageManager alloc] init];
    });
    return sharedObjectManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        if (cachePaths.count == 0) {
            return nil;
        }
        NSString *cachePath = cachePaths[0];
        _rootPath = [cachePath stringByAppendingPathComponent:kLeadorComPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:_rootPath withIntermediateDirectories:YES attributes:nil error:nil];
        _queue = dispatch_queue_create("com.leador.dispatchQueue.objectStorageManager", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (unsigned long long)cacheSize
{
    __block unsigned long long cacheSize = 0;
    dispatch_sync(_queue, ^{
        cacheSize = [self cacheSizeAtPath:nil];
    });
    return cacheSize;
}

- (void)cleanCache
{
    dispatch_barrier_sync(_queue, ^{
        [self cleanCacheAtPath:nil];
    });
}

#pragma mark - private method

- (void)cleanCacheAtPath:(NSString *)path
{
    NSString *realPath = [self.rootPath stringByAppendingPathComponent:path.length ? path:@""];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    [fileManager removeItemAtPathSafely:realPath];
    
    [fileManager createDirectoryAtPath:realPath withIntermediateDirectories:YES attributes:nil error:nil];
}

- (unsigned long long)cacheSizeAtPath:(NSString *)path
{
    NSString *realPath = [self.rootPath stringByAppendingPathComponent:path.length ? path:@""];
    unsigned long long size = 0;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:realPath error:&error];
    if (error) {
        return 0;
    }
    NSString *fileType = [attributes fileType];
    if ([fileType isEqualToString:NSFileTypeRegular]) {
        return [attributes fileSize];
    }
    if (![fileType isEqualToString:NSFileTypeDirectory]) {
        return 0;
    }
    NSArray *files = [fileManager subpathsOfDirectoryAtPath:realPath error:&error];
    if (error) {
        return 0;
    }
    for (NSString *subPath in files) {
        NSString *itemPath = [realPath stringByAppendingPathComponent:subPath];
        NSDictionary *attributes = [fileManager attributesOfItemAtPath:itemPath error:&error];
        if (error) {
            continue;
        }
        if ([[attributes fileType] isEqualToString:NSFileTypeDirectory]) {
            continue;
        }
        size += [attributes fileSize];
    }
    return size;
}

- (BOOL)saveObject:(id)object forKey:(NSString *)key
{
    BOOL retVal = NO;
    if ([key length]) {
//        NSString *path = [NSString stringWithFormat:@"%@/%@", self.rootPath, (userID ? : kLeaderGuestPath)];
//        NSFileManager *fileManager = [[NSFileManager alloc] init];
//        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *path = [self.rootPath stringByAppendingPathComponent:[key stringByComputingMD5]];
        if ([self canSupportObject:object]) {
            retVal = [NSKeyedArchiver archiveRootObject:object toFile:path];
        }
    }
    return retVal;
}

- (id)objectForKey:(NSString *)key
{
    if(![key length]) {
        return nil;
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@", self.rootPath, [key stringByComputingMD5]];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];;
}

#pragma mark - private

- (BOOL)canSupportObject:(id)object
{
    return !object || [object conformsToProtocol:@protocol(NSCoding)];
}


@end

@implementation NSString (Hash)
// Create pointer to the string as UTF8
// Create byte array of unsigned chars
// Create 16 byte MD5 hash value, store in buffer
// Convert MD5 value in the buffer to NSString of hex values
- (NSString *)stringByComputingMD5
{
    const char *ptr = [self UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", md5Buffer[i]];
    }
    return output;
}

@end
