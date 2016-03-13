//
//  ObjectStorageManager.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/8.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectStorageManager : NSObject

+ (instancetype)sharedObjectManager;

- (BOOL)saveObject:(id)object forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

- (unsigned long long)cacheSize;
- (void)cleanCache;

@end
