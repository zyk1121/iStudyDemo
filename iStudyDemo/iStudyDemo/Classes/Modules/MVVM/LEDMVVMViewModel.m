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
#import "LEDProvince.h"
#import "LEDCities.h"
#import <objc/runtime.h>

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
            //  使用KVC解析Dic数据
//            self.provinces = [self kvcLEDProvincesDomainForFormDictionary:[dataDic objectForKey:@"result"]];
            self.provinces = [LEDProvincesDomain domainWithJSONDictionary:[dataDic objectForKey:@"result"]];
//            [self getPropertyNameList:[LEDProvince new]];
//            [self getPropertyNameList:[LEDCities new]];
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

#pragma mark - KVC 机制解析 JSon(直接KVC)
// KVC 机制解析 JSon(直接KVC)
// http://blog.csdn.net/whf727/article/details/14169729

- (LEDProvincesDomain *)kvcLEDProvincesDomainForFormDictionary:(NSDictionary *)dic
{
    LEDProvincesDomain *provinceDomain = [[LEDProvincesDomain alloc] init];
    provinceDomain.version = [dic objectForKey:@"version"];
    provinceDomain.provinces = [self provincesWithJsonArray:[dic objectForKey:@"provinces"]];
    return provinceDomain;
}

- (LEDProvince *)kvcLEDProvinceForFormDictionary:(NSDictionary *)dic
{
    /*@property (nonatomic, strong) NSURL* url;
     @property (nonatomic, copy) NSString* name;
     @property (nonatomic, copy) NSString* jianpin;
     @property (nonatomic, copy) NSString* pinyin;
     @property (nonatomic, copy) NSString* adcode;
     @property (nonatomic, copy) NSString* version;
     @property (nonatomic, assign) NSUInteger size;
     @property (nonatomic, copy) NSArray* cities;*/
    LEDProvince *province = [[LEDProvince alloc] init];
    province.url = [NSURL URLWithString:[dic objectForKey:@"url"]];
    province.name = [dic objectForKey:@"name"];
    province.jianpin = [dic objectForKey:@"jianpin"];
    province.pinyin = [dic objectForKey:@"pinyin"];
    province.adcode = [dic objectForKey:@"adcode"];
    province.version = [dic objectForKey:@"version"];
    NSString *size = (NSString*)[dic objectForKey:@"size"];
    province.size = [size integerValue];
    province.cities = [self citiesWithJsonArray:[dic objectForKey:@"cities"]];
    
    return province;
}

- (LEDCities *)kvcLEDCitiesForFormDictionary:(NSDictionary *)dic
{
    /*
     @property (nonatomic, strong) NSURL* url;
     @property (nonatomic, copy) NSString* name;
     @property (nonatomic, copy) NSString* jianpin;
     @property (nonatomic, copy) NSString* pinyin;
     @property (nonatomic, copy) NSString* adcode;
     @property (nonatomic, copy) NSString* citycode;
     @property (nonatomic, copy) NSString* version;
     @property (nonatomic, assign) NSUInteger size;
     @property (nonatomic, copy) NSString* md5;
     */
    LEDCities *cities = [[LEDCities alloc] init];
    cities.url = [NSURL URLWithString:[dic objectForKey:@"url"]];
    cities.name = [dic objectForKey:@"name"];
    cities.jianpin = [dic objectForKey:@"jianpin"];
    cities.pinyin = [dic objectForKey:@"pinyin"];
    cities.adcode = [dic objectForKey:@"adcode"];
    cities.version = [dic objectForKey:@"version"];
     cities.citycode = [dic objectForKey:@"citycode"];
    NSString *size = (NSString*)[dic objectForKey:@"size"];
    cities.size = [size integerValue];
     cities.md5 = [dic objectForKey:@"md5"];
    
    return cities;
}

- (NSArray *)provincesWithJsonArray:(NSArray *)jsonArray
{
    NSMutableArray *provinceArray = [[NSMutableArray alloc] init];
    [jsonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        LEDProvince *province = [self kvcLEDProvinceForFormDictionary:dic];
        if (province) {
            [provinceArray addObject:province];
        }
    }];
    
    return [provinceArray copy];
}

- (NSArray *)citiesWithJsonArray:(NSArray *)jsonArray
{
    NSMutableArray *cityArray = [[NSMutableArray alloc] init];
    [jsonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        LEDCities *city = [self kvcLEDCitiesForFormDictionary:dic];
        if (city) {
            [cityArray addObject:city];
        }
    }];
    
    return [cityArray copy];
}

#pragma mark - KVC 机制解析 JSon(KVC + runtime)

- (LEDProvincesDomain *)kvcRuntimeObjectForFormDictionary:(NSDictionary *)dic
{
    LEDProvincesDomain *provinceDomain = [[LEDProvincesDomain alloc] init];
    
    return provinceDomain;
}

// 获取属性名称数组
- (NSArray *)getPropertyNameList:(id)object
{
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    NSMutableArray * propertyNames = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
        
    }
    
    return propertyNames;
}


/*
 
 http://blog.csdn.net/whf727/article/details/14169729
 
 +（Result*）resultWithDict：(NSDictory*)dict{
 Result* r = [[Result alloc] init];
 NSArray* propertyArray = getPropertyNameList(result);
 for (NSString* key in propertyArray) {
 @try{
 NSLog(@"%@:%@,%@",key,dict[key],NSStringFromClass([dict[key] class]));
 if([key isEqual:@"items"]){
 [result setValue:[Item itemsWitdhArray:dict[key]] forKey:key];
 }else{
 [result setValue:dict[key] forKey:key];
 }
 }@catch (NSException *exception) {
 NSLog(@"except:%@:%@",key,dict[key]);
 }
 }
 */

@end
