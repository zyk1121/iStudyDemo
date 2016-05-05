//
//  DPCreationalTestViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/5/5.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "DPCreationalTestViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "LEDWebViewController.h"
#import "DPSFObject.h"
#import "DPAFObject.h"

@interface DPCreationalTestViewController ()

@property (nonatomic, assign) DPCreationalType type;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation DPCreationalTestViewController

- (instancetype)initWithType:(DPCreationalType)type
{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self setupData];
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - masonry

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - private method

- (void)setupUI
{
    
    _textView = [[UITextView alloc] init];
    _textView.editable = NO;
    _textView.userInteractionEnabled = NO;
    _textView.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_textView];
    
}

- (void)setupData
{
    // 根据不同的type生成不同的描述
    switch (_type) {
        case DPCreationalTypeSimpleFactory:
            self.textView.text =
            @"\
简单工厂模式描述：\n\
    首先，简单工厂模式不属于23中设计模式，简单工厂一般分为：普通简单工厂、多方法简单工厂、静态方法简单工厂。\n\
工厂方法模式：简单工厂模式有一个问题就是，类的创建依赖工厂类，也就是说，如果想要拓展程序，必须对工厂类进行修改，这违背了闭包原则，所以，从设计角度考虑，有一定的问题，如何解决？就用到工厂方法模式，创建一个工厂接口和创建多个工厂实现类，这样一旦需要增加新的功能，直接增加新的工厂类就可以了，不需要修改之前的代码。\
            ";
            break;
        case DPCreationalTypeAbstractFactory:
            self.textView.text =
            @"\
            抽象工厂模式描述：工厂方法模式：\
            一个抽象产品类，可以派生出多个具体产品类。\
            一个抽象工厂类，可以派生出多个具体工厂类。\
            每个具体工厂类只能创建一个具体产品类的实例。\
            \
            抽象工厂模式：\
            多个抽象产品类，每个抽象产品类可以派生出多个具体产品类。\
            一个抽象工厂类，可以派生出多个具体工厂类。   \
            每个具体工厂类可以创建多个具体产品类的实例，也就是创建的是一个产品线下的多个产品。\n\n\
            抽象工厂模式（Abstract Factory Pattern）是围绕一个超级工厂创建其他工厂。该超级工厂又称为其他工厂的工厂。这种类型的设计模式属于创建型模式，它提供了一种创建对象的最佳方式。\
            在抽象工厂模式中，接口是负责创建一个相关对象的工厂，不需要显式指定它们的类。每个生成的工厂都能按照工厂模式提供对象。  \n\
            \
            ";
            break;
            
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 根据不同的type执行不同的入口
    switch (_type) {
        case DPCreationalTypeSimpleFactory:
            [self factoryMothod]; //  工厂方法模式
            break;
        case DPCreationalTypeAbstractFactory:
            [self abstractFactory];// 抽象工厂模式
            break;
        default:
            break;
    }
}

#pragma mark - private method
- (void)factoryMothod
{
    // 简单工厂模式 － 普通方法
//    DSFSSimpleFactory *simpleFactory = [[DSFSSimpleFactory alloc] init];
//    DPSFSmsSender *smsSender =  [simpleFactory produce:@"sms"];
//    [smsSender send];
//    DPSFMailSender *mailSender =  [simpleFactory produce:@"mail"];
//    [mailSender send];
    
    // 简单工厂模式－多个方法-- 不需要创建的时候传入字符串
//    DSFSSendFactory *sendFactory = [DSFSSendFactory new];
//    DPSFSmsSender *smsSender =  [sendFactory produceSms];
//    [smsSender send];
//    DPSFMailSender *mailSender =  [sendFactory produceMail];
//    [mailSender send];
    
    
//    DSFSSendFactory *sendFactory = [DSFSSendFactory new];
    /*
    DPSFSmsSender *smsSender =  [DSFSSendFactory produceSms];
    [smsSender send];
    DPSFMailSender *mailSender =  [DSFSSendFactory produceMail];
    [mailSender send];
     */
    
    // 工厂方法模式
    
    SendMailFactory *mailFactory = [[SendMailFactory alloc] init];
    [[mailFactory produce] send];
    SendSmsFactory *smsFactory = [SendSmsFactory new];
    [[smsFactory produce] send];

    
}
             
- (void)abstractFactory
{
    // 抽象工厂创建工厂
    DPShapeFactory *shapeFactory = [DPFactoryProducer getFactory:@"SHAPE"];
    [[shapeFactory getShape:@"CIRCLE"] draw];
    [[shapeFactory getShape:@"RECTANGLE"] draw];
    [[shapeFactory getShape:@"SQUARE"] draw];
    
    DPColorFactory *colorFactory = [DPFactoryProducer getFactory:@"COLOR"];
    [[colorFactory getColor:@"RED"] fill];
    [[colorFactory getColor:@"GREEN"] fill];
    [[colorFactory getColor:@"BLUE"] fill];
}

@end
