//
//  LEDMVVMViewModel.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/10.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDMVVMModel.h"
#import "LEDMVVMViewModel.h"
#import "LEDProvincesDomain.h"

@interface LEDMVVMViewModel ()

@property (nonatomic, strong) LEDMVVMModel* model;

@end

@implementation LEDMVVMViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _model = [[LEDMVVMModel alloc] init];
    }
    return self;
}

- (RACCommand*)loadCommand
{
    if (!_loadCommand) {
        @weakify(self)
            _loadCommand
            = [[RACCommand alloc] initWithSignalBlock:^RACSignal*(id input) {
                  @strongify(self);
                  return [self fetchDataSignal];
              }];
    }

    return _loadCommand;
}

- (RACSignal*)fetchDataSignal
{
    @weakify(self) return [[[[self.model fetchDataSignal] doNext:^(NSDictionary* dataDic) {
        // 假设我想要字典中的省份 数据
        @strongify(self);
        if ([[dataDic objectForKey:@"status"] integerValue] == 1) {
            self.provinces = [LEDProvincesDomain domainWithJSONDictionary:[dataDic objectForKey:@"result"]];
        }
        else {
            self.provinces = nil;
        }
    }] doError:^(NSError* error) {
        @strongify(self);
        self.provinces = nil;
    }] doCompleted:^{

    }];
}

@end
