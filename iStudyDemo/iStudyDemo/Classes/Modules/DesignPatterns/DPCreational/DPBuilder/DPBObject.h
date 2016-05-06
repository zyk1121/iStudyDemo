//
//  DPBObject.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/5/6.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>

// 建造者模式
/*
 我们假设一个快餐店的商业案例，其中，一个典型的套餐可以是一个汉堡（Burger）和一杯冷饮（Cold drink）。汉堡（Burger）可以是素食汉堡（Veg Burger）或鸡肉汉堡（Chicken Burger），它们是包在纸盒中。冷饮（Cold drink）可以是可口可乐（coke）或百事可乐（pepsi），它们是装在瓶子中。
 我们将创建一个表示食物条目（比如汉堡和冷饮）的 Item 接口和实现 Item 接口的实体类，以及一个表示食物包装的 Packing 接口和实现 Packing 接口的实体类，汉堡是包在纸盒中，冷饮是装在瓶子中。
 然后我们创建一个 Meal 类，带有 Item 的 ArrayList 和一个通过结合 Item 来创建不同类型的 Meal 对象的 MealBuilder。BuilderPatternDemo，我们的演示类使用 MealBuilder 来创建一个 Meal。
 
 */

@protocol DPPacking <NSObject>

// 打包方式
- (NSString *)pack;

@end

@interface DPWrapper : NSObject <DPPacking>

@end

@interface DPBottle : NSObject <DPPacking>

@end

// 食物的接口
@protocol DPItem <NSObject>

- (NSString *)name;
- (float)price;
- (NSString *)packing;

@end

// 汉堡接口
@protocol DPBurger <DPItem>

@end


// 冷饮接口
@protocol DPColdDrink <DPItem>

@end




// 素食汉堡
@interface DPVegBurger : NSObject<DPBurger>

@end

// 鸡肉汉堡
@interface DPChickenBurger : NSObject<DPBurger>

@end

// 咖啡冷饮
@interface DPCoffice : NSObject<DPColdDrink>

@end

// 鸡肉汉堡
@interface DPJuice : NSObject<DPColdDrink>

@end



// 创建午餐类
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
@interface DPMeal : NSObject

- (void)addItem:(id<DPItem>)item;
- (float)getCost;
- (void)showItems;

@end


