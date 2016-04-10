//
//  RunTimeViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "RunTimeViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import <objc/runtime.h>
#import "LEDStudent+Other.h"
#import "LEDProvincesDomain.h"
#import "LEDProvince.h"

@interface RunTimeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* listData;

@end

@implementation RunTimeViewController

- (void)viewDidLoad
{
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
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - private method

- (void)setupUI
{
    _tableView = ({
        UITableView* tableview = [[UITableView alloc] init];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        tableview;
    });
    [self.view addSubview:_tableView];
}

- (void)setupData
{
    _listData = [[NSMutableArray alloc] init];
    [_listData addObject:@"OC动态语言"];
    [_listData addObject:@"运行时概念"];
    [_listData addObject:@"objc_msgSend"];
    [_listData addObject:@"对象内存模型"];
    [_listData addObject:@"消息传递"];
    [_listData addObject:@"消息转发"];
    [_listData addObject:@"方法替换"];
    [_listData addObject:@"关联对象"];
    [_listData addObject:@"成员变量+成员方法"];
    [_listData addObject:@"动态添加方法"];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self actionWithRow:indexPath.row];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* reuseIdetify = @"tableViewCellIdetify";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showsReorderControl = YES;
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [self.listData objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 50;
}

#pragma mark - private method

- (void)actionWithRow:(NSUInteger)row
{
    NSString *methodName = [NSString stringWithFormat:@"test%ld",row];
    SEL sel = NSSelectorFromString(methodName);
    [self performSelector:sel withObject:nil afterDelay:0];
}

#pragma mark -
- (void)test0
{
    NSLog(@"封装可以使得代码模块化。继承可以扩展已存在的代码，他们的目的都是为了代码重用。而多态的目的则是为了接口重用。也就是说，不论传递过来的究竟是那个类的对象，函数都能够通过同一个接口调用到适应各自对象的实现方法。1.使用消息结构的语言，其运行时所执行的代码有运行时环境决定（运行时才会去查找所要执行的方法，和是否多态没有关系）；2.而使用函数调用的语言，则有编译器决定（如果代码中调用的函数是多态的，那么在运行时就会按照“虚方法表”来查找应该执行哪个函数实现）。");
}

- (void)test1
{
    NSLog(@"运行时：运行时环境，运行期组件，实质是 运行时库（C语言写的，动态链接库，能把开发者开发的程序粘合起来，然后运行）\
          作用：1.OC的重要工作都由“运行期组件”而非编译器完成。\
          2.OC中面向对象特性所需的全部数据结构及函数都是在“运行期组件”里面的（比如说内存管理方法，对象的创建和销毁,消息的传递和转发等等）。");
}
- (void)test2
{
    NSLog(@"在oc中，我们向某对象传递消息，编译器会把它转化为一条标准的C语言调用，objc_msgSend，其原型如下：\
          void objc_msgSend(id self, SEL cmd, …)\
          它能接受两个或者两个以上的参数。receiver+消息。\
          首先根据receiver对象的isa指针获取它对应的class；\
          优先在class的cache查找message方法，如果找不到，再到methodLists查找；\
          如果没有在class找到，再到super_class查找；\
          一旦找到message这个方法，就执行它实现的IMP。");
    
    /*
     self与super
     
     为了让大家更好地理解self和super，借用sunnyxx博客的iOS程序员6级考试一道题目：下面的代码分别输出什么？
     
     [cpp] view plaincopy
     @implementation Son : Father
     - (id)init
     {
     self = [super init];
     if (self)
     {
     NSLog(@"%@", NSStringFromClass([self class]));
     NSLog(@"%@", NSStringFromClass([super class]));
     }
     return self;
     }
     @end
     self表示当前这个类的对象，而super是一个编译器标示符，和self指向同一个消息接受者。在本例中，无论是[self class]还是[super class]，接受消息者都是Son对象，但super与self不同的是，self调用class方法时，是在子类Son中查找方法，而super调用class方法时，是在父类Father中查找方法。
     
     当调用[self class]方法时，会转化为objc_msgSend函数，这个函数定义如下：
     
     [cpp] view plaincopy
     id objc_msgSend(id self, SEL op, ...)
     这时会从当前Son类的方法列表中查找，如果没有，就到Father类查找，还是没有，最后在NSObject类查找到。我们可以从NSObject.mm文件中看到- (Class)class的实现：
     
     [cpp] view plaincopy
     - (Class)class {
     return object_getClass(self);
     }
     所以NSLog(@"%@", NSStringFromClass([self class]));会输出Son。
     
     当调用[super class]方法时，会转化为objc_msgSendSuper，这个函数定义如下：
     
     [cpp] view plaincopy
     id objc_msgSendSuper(struct objc_super *super, SEL op, ...)
     objc_msgSendSuper函数第一个参数super的数据类型是一个指向objc_super的结构体，从message.h文件中查看它的定义：
     
     [cpp] view plaincopy
     /// Specifies the superclass of an instance.
     struct objc_super {
     /// Specifies an instance of a class.
     __unsafe_unretained id receiver;
     
     /// Specifies the particular superclass of the instance to message.
     #if !defined(__cplusplus)  &&  !__OBJC2__

    __unsafe_unretained Class class;
#else
    __unsafe_unretained Class super_class;
#endif  
     
};  
#endif  
结构体包含两个成员，第一个是receiver，表示某个类的实例。第二个是super_class表示当前类的父类。
     */
}

- (void)test3
{
    // http://www.csdn.net/article/2015-07-06/2825133-objective-c-runtime/3
    
    /*
     struct objc_class {
     Class isa  OBJC_ISA_AVAILABILITY;
     
     #if !__OBJC2__
     Class super_class                                        OBJC2_UNAVAILABLE;
     const char *name                                         OBJC2_UNAVAILABLE;
     long version                                             OBJC2_UNAVAILABLE;
     long info                                                OBJC2_UNAVAILABLE;
     long instance_size                                       OBJC2_UNAVAILABLE;
     struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;
     struct objc_method_list **methodLists                    OBJC2_UNAVAILABLE;
     struct objc_cache *cache                                 OBJC2_UNAVAILABLE;
     struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
     #endif
     
     } OBJC2_UNAVAILABLE;  
     
     
     struct objc_class : objc_object {
     // Class ISA;
     Class superclass;
     cache_t cache;             // formerly cache pointer and vtable
     class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags
     
     ......  
     }
     
     
     /// An opaque type that represents a method in a class definition.
     typedef struct objc_method *Method;
     struct objc_method {
     SEL method_name                                          OBJC2_UNAVAILABLE;
     char *method_types                                       OBJC2_UNAVAILABLE;
     IMP method_imp                                           OBJC2_UNAVAILABLE;
     }

     */
}

- (void)test4
{
    NSLog(@"objc_msgSend会依据接收者与选择子的类型来调用适当的方法。为了完成此操作，该方法会在接收者所属的类中，先搜寻cache中的方法列表，如果没有找到，则在其“方法列表”中找，如果找到，则执行相关的方法代码；若是找不到，则继续向其父类的方法列表中查找，如果找到，则执行相关的代码并跳转；如果最终还是找不到，则执行“消息转发”（message forwarding）的操作（告诉对象应该如何处理未知消息）。");
}

- (void)test5
{
    // 消息转发，当一个对象沿着继承链查找但仍旧无法执行某一方法（无法解读消息）的时候...
    // teachStudent
    // 阶段一：动态方法解析，本类处理
    /*
     void teachStudentMethod(id self,SEL _cmd)
     {
     NSLog(@"ddd");
     }
     +(BOOL)resolveInstanceMethod:(SEL)sel
     {
     NSString *methodSTr = NSStringFromSelector(sel);
     if ([methodSTr isEqualToString:@"teachStudent"]) {
     class_addMethod(self, sel, (IMP)teachStudentMethod, "v@:@");
     return YES;// 本类能够处理
     }
     return [super resolveInstanceMethod:sel];
     }
     */
    
    
    // 阶段二，备援的接收者：交给其他类去处理未知消息
    // 备援的接收者
    /*
     - (id)forwardingTargetForSelector:(SEL)aSelector
     {
     if ([NSStringFromSelector(aSelector) isEqualToString:@"teachStudent"]) {
     Teacher *techer = [Teacher new];
     return teacher;
     }
     return [super forwardingTargetForSelector:aSelector];
     }
     */
    
    // 阶段三:完整的消息转发（1）
    
    /*
     
     - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
     {
     NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
     if (!signature) {
     if ([Teacher instancesRespondToSelector:aSelector]) {
     // 创建一个非nil得方法签名，否则，不会进入forwrdInvocation方法
     signature = [Teacher instanceMethodSignatureForSelector:aSelector];
     }
     }
     return signature;
     }
     
     - (void)forwardInvocation:(NSInvocation *)anInvocation
     {
     Teacher *teacher = [[Teacher alloc] init];
     if ([teacher respondsToSelector:@selector(teacherXiaoming)]) {
     // 处理转发的消息，进入此方法，就不会产生崩溃
     [anInvocation invokeWithTarget:teacher];
     // 实现forwardInvocation：方法时，不用调用 super forwardInvocation，否则还是会崩溃
     } else {
     [super forwardInvocation:anInvocation];
     }
     }
     */
    
    // 完整的消息转发2:
    
    /*
     - (void)doAnotherThing
     {
     NSLog(@"do another thing");
     }
     
     - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
     {
     NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
     if (!signature) {
     if ([本类 instancesRespondToSelector:aSelector]) {
     // 创建一个非nil得方法签名，否则，不会进入forwrdInvocation方法
     signature = [本类 instanceMethodSignatureForSelector:@selector(doAnotherThing)];
     }
     }
     return signature;
     }
     
     - (void)forwardInvocation:(NSInvocation *)anInvocation
     {
     if (anInvocation) {
     // 处理转发的消息，进入此方法，就不会产生崩溃
     [self doAnotherThing];
     // 实现forwardInvocation：方法时，不用调用 super forwardInvocation，否则还是会崩溃
     }
     }
     */
    
    
    
    
    /*
     Method Resolution：由于Method Resolution不能像消息转发那样可以交给其他对象来处理，所以只适用于在原来的类中代替掉。
     Fast Forwarding：它可以将消息处理转发给其他对象，使用范围更广，不只是限于原来的对象。
     Normal Forwarding：它跟Fast Forwarding一样可以消息转发，但它能通过NSInvocation对象获取更多消息发送的信息，例如：target、selector、arguments和返回值等信息。
     
     1.forwardInvocation:处理转发的消息，进入此方法，就不会产生崩溃
     2.实现forwardInvocation:方法时，不用调用super forwardInvocation:方法，否则，应用仍然会崩溃
     
     Method Swizzling就是在运行时将一个方法的实现代替为另一个方法的实现。
     */
}

- (void)test6
{
    // 替换方法
    NSLog(@"+ (void)load\
    {\Method viewDidAppear = class_getInstanceMethod([UIViewController class], @selector(viewDidAppear:));\
    Method trackPageViewDidAppear = class_getInstanceMethod([UIViewController class], @selector(trackPageViewDidAppear:));\
    method_exchangeImplementations(viewDidAppear, trackPageViewDidAppear);\
    }");
    
    /*
     
     + (void)load
     {
     Method viewDidAppear = class_getInstanceMethod([UIViewController class], @selector(viewDidAppear:));
     Method trackPageViewDidAppear = class_getInstanceMethod([UIViewController class], @selector(trackPageViewDidAppear:));
     method_exchangeImplementations(viewDidAppear, trackPageViewDidAppear);
     }
     
     - (void)trackPageViewDidAppear:(BOOL)animation
     {
     // 调用原来的方法
     [self trackPageViewDidAppear:animation];
     
     if (self.trackPageAutomatically) {
     [self trackPage];
     }
     }
     */
}

- (void)test7
{
    // 关联对象
    /*
     
     OBJC_EXPORT void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
     1
     2
     OBJC_EXPORT id objc_getAssociatedObject(id object, const void *key)
     __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_3_1);
     
     
     // 设置关联对象
     void objc_setAssociatedObject ( id object, const void *key, id value, objc_AssociationPolicy policy );
     
     // 获取关联对象
     id objc_getAssociatedObject ( id object, const void *key );
     
     // 移除关联对象
     void objc_removeAssociatedObjects ( id object );
     */
    
    LEDStudent *student = [LEDStudent new];
    student.school = @"school";
    student.name =@"name";
    NSLog(@"%@",student.name);
}

- (void)test8
{
    unsigned int numIvars; //成员变量个数
    Ivar *vars = class_copyIvarList(NSClassFromString(@"LEDProvince"), &numIvars);
    //Ivar *vars = class_copyIvarList([UIView class], &numIvars);
    
    NSString *key=nil;
    for(int i = 0; i < numIvars; i++) {
        
        Ivar thisIvar = vars[i];
        key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];  //获取成员变量的名字
        NSLog(@"variable name :%@", key);
        key = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)]; //获取成员变量的数据类型
        NSLog(@"variable type :%@", key);
    }
    free(vars);
    
    // 成员函数
//    unsigned int numIvars;
    
    Method *meth = class_copyMethodList(NSClassFromString(@"LEDProvince"), &numIvars);
    //Method *meth = class_copyMethodList([UIView class], &numIvars);
    
    for(int i = 0; i < numIvars; i++) {
        Method thisIvar = meth[i];
        
        SEL sel = method_getName(thisIvar);
        const char *name = sel_getName(sel);
        
        NSLog(@"zp method :%s", name);
        
        
        
    }
    free(meth);
}

- (void)test9
{
    /*
     class_addMethod([SomeClass class], @selector(name), (IMP)nameGetter, "@@:");
     class_addMethod([SomeClass class], @selector(setName:), (IMP)nameSetter, "v@:@");
     */
    
    /*
     @interface SomeClass : NSObject {
     NSString *_privateName;
     }
     @end
     
     @implementation SomeClass
     - (id)init {
     self = [super init];
     if (self) _privateName = @"Steve";
     return self;
     }
     @end
     NSString *nameGetter(id self, SEL _cmd) {
     Ivar ivar = class_getInstanceVariable([SomeClass class], "_privateName");
     return object_getIvar(self, ivar);
     }
     
     void nameSetter(id self, SEL _cmd, NSString *newName) {
     Ivar ivar = class_getInstanceVariable([SomeClass class], "_privateName");
     id oldName = object_getIvar(self, ivar);
     if (oldName != newName) object_setIvar(self, ivar, [newName copy]);
     }
     
     int main(void) {
     @autoreleasepool {
     objc_property_attribute_t type = { "T", "@\"NSString\"" };
     objc_property_attribute_t ownership = { "C", "" }; // C = copy
     objc_property_attribute_t backingivar  = { "V", "_privateName" };
     objc_property_attribute_t attrs[] = { type, ownership, backingivar };
     class_addProperty([SomeClass class], "name", attrs, 3);
     class_addMethod([SomeClass class], @selector(name), (IMP)nameGetter, "@@:");
     class_addMethod([SomeClass class], @selector(setName:), (IMP)nameSetter, "v@:@");
     
     id o = [SomeClass new];
     NSLog(@"%@", [o name]);
     [o setName:@"Jobs"];
     NSLog(@"%@", [o name]);
     }
     }
     */
    
    LEDStudent *student = [LEDStudent new];
    
    
    /*
     
     常见用法
     
     1.方法弃用告警
     
     
     ?
     1
     2
     3
     4
     5
     6
     #pragma clang diagnostic push
     
     #pragma clang diagnostic ignored "-Wdeprecated-declarations"
     [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
     
     #pragma clang diagnostic pop
     
     2.不兼容指针类型
     
     ?
     1
     2
     3
     4
     #pragma clang diagnostic push
     #pragma clang diagnostic ignored "-Wincompatible-pointer-types"
     //
     #pragma clang diagnostic pop
     
     3.循环引用
     ?
     1
     2
     3
     4
     5
     6
     7
     // completionBlock is manually nilled out in AFURLConnectionOperation to break the retain cycle.
     #pragma clang diagnostic push
     #pragma clang diagnostic ignored "-Warc-retain-cycles"
     self.completionBlock = ^ {
     ...  
     };  
     #pragma clang diagnostic pop
     
     4.未使用变量
     ?
     1
     2
     3
     4
     #pragma clang diagnostic push   
     #pragma clang diagnostic ignored "-Wunused-variable"  
     int a;   
     #pragma clang diagnostic pop*/
    
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    class_addMethod([LEDStudent class], @selector(testMethod), (IMP)test, "@@:");
    //
    [student performSelector:@selector(testMethod) withObject:nil];
    // [student testMethod];// -[LEDStudent testMethod]: unrecognized selector sent to instance 0x7f9532f36a10
#pragma clang diagnostic pop
    //
    
  

}

void test(id self, SEL _cmd)
{
    // self是对象
    NSLog(@"%@",self);
}

@end
