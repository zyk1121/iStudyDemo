//
//  DPPrincipleViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/5/3.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "DPPrincipleViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "LEDWebViewController.h"

@interface DPPrincipleViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation DPPrincipleViewController

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
//    _textView.scrollEnabled = YES;
    _textView.editable = NO;
    _textView.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_textView];
    
}

- (void)setupData
{
    // 设计模式是一套被反复使用的、多数人知晓的、经过分类编目的、代码设计经验的总结。使用设计模式是为了重用代码、让代码更容易被他人理解、保证代码可靠性。
    self.textView.text =
@"\
一，开闭原则（Open Close Principle）：\n\
    开闭原则的意思是，对扩展开放，对修改关闭。在程序需要进行拓展的时候，不能去修改原有的代码，实现一个热插拔的效果。简言之，是为了使程序的扩展性好，\
易于维护和升级（需要使用接口和抽象类）。\n\
二，里氏代换原则（Liskov Substitution Principle）：\n\
    里氏代换原则是面向对象设计的基本原则之一。里氏代换原则中说，任何基类可以出现的地方，子类一定可以出现。LSP是继承复用的基石，只有当派生类可以替换\
掉基类，且软件单位的功能不受影响时，基类才能真正被复用，而派生类也能够在基类的基础上增加新的行为。里氏代换原则是对开闭原则的补充。实现开闭原则的关键\
步骤是抽象化，而基类与子类的继承关系就是抽象化的具体实现，所以里氏代换原则是对实现抽象化的具体步骤的规范。\n\
三，依赖倒转原则（Dependence Inversion Principle）：\n\
    这个原则是开闭原则的基础。具体为：针对接口编程，依赖于抽象，而不依赖于具体。\n\
四，接口隔离原则（Interface Segregation Principle）：\n\
    这个原则的意思是：使用多个隔离的接口，比使用单个接口更好。它还有另外一个意思：降低类之间的耦合度。由此可见，其实设计模式就是从大型软件架构出发、\
便于升级和维护的软件设计思想，它强调降低依赖，降低耦合。\n\
五，迪米特法则（最少知道原则）（Demeter Principle）：\n\
    最少知道原则是指：一个实体应当尽量少地与其它实体发生相互作用，使得系统功能模块相对独立。\n\
六，合成复用原则（Composite Reuse Principle）：\n\
    合成复用原则是指：尽量使用合成／聚合的方式，而不是使用继承。\n\n\n\n\
软件设计思想：\n\
    1.可维护。\n\
    2.可复用。\n\
    3.可扩展。\n\
    4.灵活性好。\n\
    \
高内聚，低耦合!\n\
    ";
}


@end
