//
//  DPAFObject.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/5/5.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>

// 抽象类（相当于）
@protocol DPShape <NSObject>

- (void)draw;

@end

@interface DPRectangle : NSObject<DPShape>

@end

@interface DPCircle : NSObject<DPShape>

@end

@interface DPSquare : NSObject<DPShape>

@end


@protocol DPColor <NSObject>

- (void)fill;

@end

@interface DPRed : NSObject<DPColor>

@end

@interface DPGreen : NSObject<DPColor>

@end

@interface DPBlue : NSObject<DPColor>

@end


// 抽象工厂
@protocol DPAbstractFactory <NSObject>

-(id<DPColor>)getColor:(NSString *)color;
-(id<DPShape>)getShape:(NSString *)shape;

@end

@interface  DPShapeFactory : NSObject<DPAbstractFactory>

@end

@interface  DPColorFactory : NSObject<DPAbstractFactory>

@end

// 工厂生产者
/*public class FactoryProducer {
 public static AbstractFactory getFactory(String choice){
 if(choice.equalsIgnoreCase("SHAPE")){
 return new ShapeFactory();
 } else if(choice.equalsIgnoreCase("COLOR")){
 return new ColorFactory();
 }
 return null;
 }
 }
*/

@interface DPFactoryProducer : NSObject

+ (id<DPAbstractFactory>)getFactory:(NSString *)choice;

@end

