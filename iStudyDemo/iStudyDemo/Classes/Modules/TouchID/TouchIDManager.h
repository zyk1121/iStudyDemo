//
//  TouchIDManager.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchIDManager : NSObject
+ (BOOL)fingerPrintAvailable;
+ (BOOL)TouchIDAvailable;
+ (void)verifyFingerPrintSuccessBlock:(void (^)())successBlock
                    userFallbackBlock:(void (^)())userFallbackBlock
                      userCancelBlock:(void (^)())userCancelBlock
            authenticationFailedBlock:(void (^)())authenticationFailedBlock;
@end
