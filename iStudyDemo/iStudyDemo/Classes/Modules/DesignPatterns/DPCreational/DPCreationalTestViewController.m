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
#import "DPBuilder/DPBObject.h"

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
            
        case DPCreationalTypeSingleton:
            self.textView.text = @"单例模式";
            break;
            
            
        case DPCreationalTypeBuilder:
            self.textView.text =@"\
建造者模式描述：\n\
            建造者模式（Builder Pattern）使用多个简单的对象一步一步构建成一个复杂的对象。这种类型的设计模式属于创建型模式，它提供了一种创建对象的最佳方式。\
            一个 Builder 类会一步一步构造最终的对象。该 Builder 类是独立于其他对象的。\n何时使用：一些基本部件不会变，而其组合经常变化的时候。\
            ";
            break;
            
        case DPCreationalTypePrototype:
            self.textView.text =@"\
原型模式描述：\n\
            原型模式（Prototype Pattern）是用于创建重复的对象，同时又能保证性能。这种类型的设计模式属于创建型模式，它提供了一种创建对象的最佳方式。\
            这种模式是实现了一个原型接口，该接口用于创建当前对象的克隆。当直接创建对象的代价比较大时，则采用这种模式。例如，一个对象需要在一个高代价的数据库操作之后被创建。我们可以缓存该对象，在下一个请求时返回它的克隆，在需要的时候更新数据库，以此来减少数据库调用。\n\
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
        case DPCreationalTypeSingleton:
            [[DPSSingleton defaultSingleton] test];// 单例模式
            break;
        case DPCreationalTypeBuilder:
            [self builderPattern];// 建造者模式
            break;
        case DPCreationalTypePrototype:
            [self prototypePattern];// 原型模式
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

- (void)builderPattern
{
    // 建造者模式
    DPMeal *meal = [[DPMeal alloc] init];
    DPVegBurger *veg = [[DPVegBurger alloc] init];
    DPCoffice *coffice = [[DPCoffice alloc] init];
    [meal addItem:veg];
    [meal addItem:coffice];
    float ff = [meal getCost];
    NSLog(@"meal花费：%f",ff);
    [meal showItems];

}

- (void)prototypePattern
{
    /*
    NSLog(@"5、原型模式（Prototype）
          原型模式虽然是创建型的模式，但是与工程模式没有关系，从名字即可看出，该模式的思想就是将一个对象作为原型，对其进行复制、克隆，产生一个和原对象类似的新对象。本小结会通过对象的复制，进行讲解。在Java中，复制对象是通过clone()实现的，先创建一个原型类：
          [java] view plaincopy
          public class Prototype implements Cloneable {
              
              public Object clone() throws CloneNotSupportedException {
                  Prototype proto = (Prototype) super.clone();
                  return proto;
              }
          }
          很简单，一个原型类，只需要实现Cloneable接口，覆写clone方法，此处clone方法可以改成任意的名称，因为Cloneable接口是个空接口，你可以任意定义实现类的方法名，如cloneA或者cloneB，因为此处的重点是super.clone()这句话，super.clone()调用的是Object的clone()方法，而在Object类中，clone()是native的，具体怎么实现，我会在另一篇文章中，关于解读Java中本地方法的调用，此处不再深究。在这儿，我将结合对象的浅复制和深复制来说一下，首先需要了解对象深、浅复制的概念：
          浅复制：将一个对象复制后，基本数据类型的变量都会重新创建，而引用类型，指向的还是原对象所指向的。
          深复制：将一个对象复制后，不论是基本数据类型还有引用类型，都是重新创建的。简单来说，就是深复制进行了完全彻底的复制，而浅复制不彻底。");
     */
}

@end
