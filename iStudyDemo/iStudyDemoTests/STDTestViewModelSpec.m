//
//  STDTestViewModelSpec.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/6.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Specta.h>
#import <Expecta.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "OCMock.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "STDTestViewModelStub.h"
#import "LEDMVVMViewModel.h"
#import "LEDProvincesDomain.h"



#define within_main_thread(block,...) \
try {} @finally {} \
do { \
if ([[NSThread currentThread] isMainThread]) { \
if (block) { \
block(__VA_ARGS__); \
} \
} else { \
if (block) { \
dispatch_async(dispatch_get_main_queue(), ^(){ \
block(__VA_ARGS__); \
}); \
} \
} \
} while(0)

#define within_main_thread_sync(block,...) \
try {} @finally {} \
do { \
if ([[NSThread currentThread] isMainThread]) { \
if (block) { \
block(__VA_ARGS__); \
} \
} else { \
if (block) { \
dispatch_async(dispatch_get_main_queue(), ^(){ \
CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^{ \
block(__VA_ARGS__); \
}); \
}); \
} \
} \
} while(0)



SpecBegin(LEDMVVMViewModel)

describe(@"LEDMVVMViewModel", ^{
    
    __block LEDMVVMViewModel *viewModel;
    
    beforeEach(^(){
        viewModel = [[LEDMVVMViewModel alloc] init];
    });
    
    context(@"Test load data When No error occurs.", ^{
        
        beforeAll(^{
            [STDTestViewModelStub getSuccessStub];
        });
        
        afterAll(^{
            [OHHTTPStubs removeAllStubs];
        });
        
        it(@"should get data success info", ^AsyncBlock {
            [[viewModel.loadCommand execute:nil] subscribeNext:^(id data) {
                expect(viewModel.provinces.provinces.count).to.equal(@4);
            } error:^(NSError *error) {
                expect(error).to.beNil();
                @within_main_thread(^{
                    done();
                });
            } completed:^{
                @within_main_thread(^{
                    done();
                });
            }];
//            [[viewModel.loadCommand execute:nil] subscribeError:^(NSError *error) {
//                expect(error).to.beNil();
//                @within_main_thread(^{
//                    done();
//                });
//            } completed:^{
//                @within_main_thread(^{
//                    done();
//                });
//            }];
        });
    });
    
    context(@"Test loadCommand When error occurs.", ^{
        
        afterEach(^{
            [OHHTTPStubs removeAllStubs];
        });
        
        it(@"should be error when account balance  info", ^AsyncBlock {
            [STDTestViewModelStub getFailStub];
            [[viewModel.loadCommand execute:nil] subscribeError:^(NSError *error) {
                expect(error).toNot.beNil();
                @within_main_thread(^{
                    done();
                });
            }];
        });
        
        it(@"should be error when network errors", ^AsyncBlock {
            [STDTestViewModelStub getFailNetworkStub];
            [[viewModel.loadCommand execute:nil] subscribeError:^(NSError *error) {
                expect(error).toNot.beNil();
                @within_main_thread(^{
                    done();
                });
            }];
            
        });
    });
});

SpecEnd

