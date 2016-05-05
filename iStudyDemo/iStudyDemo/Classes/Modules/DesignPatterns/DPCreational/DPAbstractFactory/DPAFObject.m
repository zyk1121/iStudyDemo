//
//  DPAFObject.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/5/5.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "DPAFObject.h"

@implementation DPRectangle

-(void)draw
{
    NSLog(@"DPRectangle draw");
}

@end

@implementation DPCircle

-(void)draw
{
    NSLog(@"DPCircle draw");
}

@end


@implementation DPSquare

-(void)draw
{
    NSLog(@"DPSquare draw");
}

@end


@implementation DPRed

-(void)fill
{
    NSLog(@"DPRed fill");
}

@end

@implementation DPGreen

-(void)fill
{
    NSLog(@"DPGreen fill");
}

@end


@implementation DPBlue

-(void)fill
{
    NSLog(@"DPBlue fill");
}

@end


@implementation DPShapeFactory

-(id<DPColor>)getColor:(NSString *)color
{
    return nil;
}

-(id<DPShape>)getShape:(NSString *)shape
{
    if(shape == nil){
        return nil;
    }
    if([shape isEqualToString:@"CIRCLE"]){
        return [DPCircle new];
    } else if([shape isEqualToString:@"RECTANGLE"]){
        return [DPRectangle new];
    } else if([shape isEqualToString:@"SQUARE"]){
        return [DPSquare new];
    }
    return nil;
}

@end

@implementation  DPColorFactory

-(id<DPColor>)getColor:(NSString *)color
{
    
    if(color == nil){
        return nil;
    }
    if([color isEqualToString:@"RED"]){
        return [DPRed new];
    } else if([color isEqualToString:@"GREEN"]){
        return [DPGreen new];
    } else if([color isEqualToString:@"BLUE"]){
        return [DPBlue new];
    }
    return nil;
}

-(id<DPShape>)getShape:(NSString *)shape
{
    return nil;
}

@end


@implementation DPFactoryProducer

+ (id<DPAbstractFactory>)getFactory:(NSString *)choice
{
    if (!choice) {
        return nil;
    }
    if([choice isEqualToString:@"SHAPE"]){
        return [DPShapeFactory new];
    } else if([choice isEqualToString:@"COLOR"]){
        return [DPColorFactory new];
    }
    return nil;
}

@end
