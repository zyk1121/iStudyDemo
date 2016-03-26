//
//  TouchIDManager.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "TouchIDManager.h"
#import <UIKit/UIKit.h>

@import LocalAuthentication;

@implementation TouchIDManager

+ (BOOL)fingerPrintAvailable
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        return NO;
    }
    NSError *error = nil;
    return [[LAContext new] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                                        error:&error];
}

+ (BOOL)TouchIDAvailable
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        return NO;
    }
    NSError *error = nil;
    [[LAContext new] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                                 error:&error];
    switch (error.code) {
        case LAErrorAuthenticationFailed:
            break;
        case LAErrorUserCancel:
            break;
        case LAErrorUserFallback:
            break;
        case LAErrorSystemCancel:
            break;
        case LAErrorPasscodeNotSet:
            break;
        case LAErrorTouchIDNotAvailable:
            return NO;
            break;
        case LAErrorTouchIDNotEnrolled:
            break;
    }
    return YES;
}

+ (void)verifyFingerPrintSuccessBlock:(void (^)())successBlock
                    userFallbackBlock:(void (^)())userFallbackBlock
                      userCancelBlock:(void (^)())userCancelBlock
            authenticationFailedBlock:(void (^)())authenticationFailedBlock
{
    NSError *error = nil;
    LAContext *context = [LAContext new];
    context.localizedFallbackTitle = @"指纹解锁";
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"请将手指放在Home键上，用于指纹解锁"
                          reply:^(BOOL succes, NSError *error) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  if (succes) {
                                      if (successBlock) {
                                          successBlock();
                                      }
                                  } else {
                                      switch (error.code) {
                                          case LAErrorAuthenticationFailed:
                                              if (authenticationFailedBlock) {
                                                  authenticationFailedBlock();
                                              }
                                              break;
                                          case LAErrorUserCancel:
                                              if (userCancelBlock) {
                                                  userCancelBlock();
                                              }
                                              break;
                                          case LAErrorUserFallback:
                                              if (userFallbackBlock) {
                                                  userFallbackBlock();
                                              }
                                              break;
                                          case LAErrorSystemCancel:
                                              break;
                                          case LAErrorPasscodeNotSet:
                                              break;
                                          case LAErrorTouchIDNotAvailable:
                                              break;
                                          case LAErrorTouchIDNotEnrolled:
                                              break;
                                          case LAErrorTouchIDLockout:
                                              if (authenticationFailedBlock) {
                                                  authenticationFailedBlock();
                                              }
                                              break;
                                          case LAErrorAppCancel:
                                              break;
                                          case LAErrorInvalidContext:
                                              break;
                                      }
                                  }
                              });
                          }];
    }
}



@end
