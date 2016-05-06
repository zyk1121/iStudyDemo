//
//  DPBObject.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/5/6.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "DPBObject.h"

@implementation DPWrapper

- (NSString *)pack
{
    return @"wrapper";
}

@end


@implementation DPBottle

- (NSString *)pack
{
    return @"bottle";
}

@end


// 素食汉堡
@implementation DPVegBurger
- (NSString *)packing
{
    return [[DPWrapper new] pack];
}
- (NSString *)name
{
    return @"VegBurger";
}
- (float)price
{
    return 23.8;
}


@end

// 鸡肉汉堡
@implementation DPChickenBurger

- (NSString *)packing
{
    return [[DPWrapper new] pack];
}

- (NSString *)name
{
    return @"ChickenBurger";
}
- (float)price
{
    return 33.8;
}

@end

// 咖啡冷饮
@implementation DPCoffice

- (NSString *)packing
{
    return [[DPBottle new] pack];
}

- (NSString *)name
{
    return @"DPCoffice";
}
- (float)price
{
    return 12;
}

@end

// juice
@implementation DPJuice

- (NSString *)packing
{
    return [[DPBottle new] pack];
}

- (NSString *)name
{
    return @"DPJuice";
}
- (float)price
{
    return 7;
}

@end


/*public class Meal {
 private List<Item> items = new ArrayList<Item>();
 
 public void addItem(Item item){
 items.add(item);
 }
 
 public float getCost(){
 float cost = 0.0f;
 for (Item item : items) {
 cost += item.price();
 }
 return cost;
 }
 
 public void showItems(){
 for (Item item : items) {
 System.out.print("Item : "+item.name());
 System.out.print(", Packing : "+item.packing().pack());
 System.out.println(", Price : "+item.price());
 }
 }
 }*/

@interface DPMeal ()
{
    NSMutableArray *items;
}
@end

@implementation DPMeal

- (instancetype)init
{
    self = [super init];
    if (self) {
        items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addItem:(id<DPItem>)item
{
    if (![items containsObject:item]) {
        [items addObject:item];
    }
}
- (float)getCost
{
    __block float sum = 0;
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id<DPItem> ttt = (id<DPItem>)obj;
        sum += [ttt price];
    }];
    return sum;
}
- (void)showItems
{
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id<DPItem> ttt = (id<DPItem>)obj;
        NSLog(@"%@",[ttt name]);
    }];
}

@end
