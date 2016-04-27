//
//  ViewController.m
//  iTestApp
//
//  Created by zhangyuanke on 16/4/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LayoutConstraintViewController.h"

@interface LayoutConstraintViewController ()

@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@property (nonatomic, strong) UIView *view4;// 子view

@end

@implementation LayoutConstraintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

/*
 
 [NSLayoutConstraint constraintsWithVisualFormat:<visual format string>
 
 options:<options>metrics:<metrics>
 
 views: <views dictionary>
 
 ];
 
 constraintsWithVisualFormat:参数为NSString型，指定Contsraint的属性，是垂直方向的限定还是水平方向的限定，参数定义一般如下：
 
 V:|-(>=XXX) :表示垂直方向上相对于SuperView大于、等于、小于某个距离
 
 若是要定义水平方向，则将V：改成H：即可
 
 在接着后面-[]中括号里面对当前的View/控件 的高度/宽度进行设定；
 
 options：字典类型的值；这里的值一般在系统定义的一个enum里面选取
 
 metrics：nil；一般为nil ，参数类型为NSDictionary，从外部传入 //衡量标准
 
 views：就是上面所加入到NSDictionary中的绑定的View
 
 在这里要注意的是 AddConstraints  和 AddConstraint 之间的区别，一个添加的参数是NSArray，一个是NSLayoutConstraint
 
 使用规则
 
 |: 表示父视图
 
 -:表示距离
 
 V:  :表示垂直
 
 H:  :表示水平
 
 >= :表示视图间距、宽度和高度必须大于或等于某个值
 
 <= :表示视图间距、宽度和高度必须小宇或等于某个值
 
 == :表示视图间距、宽度或者高度必须等于某个值
 
 @  :>=、<=、==  限制   最大为  1000
 
 
 
 1.|-[view]-|:  视图处在父视图的左右边缘内
 
 2.|-[view]  :   视图处在父视图的左边缘
 
 3.|[view]   :   视图和父视图左边对齐
 
 4.-[view]-  :  设置视图的宽度高度
 
 5.|-30.0-[view]-30.0-|:  表示离父视图 左右间距  30
 
 6.[view(200.0)] : 表示视图宽度为 200.0
 
 7.|-[view(view1)]-[view1]-| :表示视图宽度一样，并且在父视图左右边缘内
 
 8. V:|-[view(50.0)] : 视图高度为  50
 
 9: V:|-(==padding)-[imageView]->=0-[button]-(==padding)-| : 表示离父视图的距离
 
 为Padding,这两个视图间距必须大于或等于0并且距离底部父视图为 padding。
 
 10:  [wideView(>=60@700)]  :视图的宽度为至少为60 不能超过  700 ，最大为1000
 
 // http://www.tuicool.com/articles/ueUnyuI
 
 */


/*
 NSDictionary *views = NSDictionaryOfVariableBindings(self.view,_view3,_view2,_view1);
 
 [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_view1(==_view2)]-10-[_view2]-10-|" options:0 metrics:0 views:views]];
 [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_view1(<=200)]-10-[_view3]-10-|" options:0 metrics:0 views:views]];
 [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_view2(<=200)]-10-[_view3]-10-|" options:0 metrics:0 views:views]];
 [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_view3]-10-|" options:0 metrics:0 views:views]];
 [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_view3(>=150)]-10-|" options:0 metrics:0 views:views]];
 
 这里用到了一个系统宏定义,NSDictionaryOfVariableBindings(),其作用是生成一个词典,key的名字和对象的标识符相同,以上述为例,生成的词典形式就是{"self.view":self.view,@"_view3":_view3,...},这个词典应当包含需要自动布局的父视图和所有的子视图,
 
 [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_view1(==_view2)]-10-[_view2]-10-|" options:0 metrics:0 views:views]];
 
 这里则是添加了一条自动布局规则,可以看到有个比较麻烦的字符串参数,简单解释一下
 |
 
 -10-
 
 [_view2]
 
 [_view1(==_view2)]
 
 字符串中的每个部分都解释清楚后,那么就容易理解多了~这句话完整的意思整理出来就是:
 
 两个宽度相同的view,其间距是10个点,距离左右边框的距离也是10个点~
 
 这样,无论是竖屏还是横屏,都会按照这样一个标准来去进行自动布局.
 
 值得注意的是,能够执行这种布局的view必须通过 -(CGSize)intrinsicContentSize方法返回一个有效的CGSize,而UIView默认返回的是0,所以如果只设置了横向的布局规则那么UIView是不会显示在屏幕上的
 
 对于UIView而言,必须同时设置横向和纵向布局规则或者写一个继承自UIView的自定义View然后重写-(CGSize)intrinsicContentSize才能实现该效果.
 
 但是对于UIButton,UILabel等则不必,设置个横向的就够了.
 
 再看下一句:
 
 V:|-30-[_view1(<=200)]-10-[_view3]-10-|
 
 V:
 
 简单解释一下,view1的高度不能大于200点,距离上边框30个点,与view3的间距是10个点,view3与底边框的距离是10个点
 
 由此,通过设置view1的高度上限和间距就可以自动计算出view3的高度.其他的布局规则大家自己看一下也就可以明白了.
 
 */

- (void)setupUI
{
    self.view1 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor redColor];
        [self.view addSubview:view];
        view;
    });
    //布局
    /*
     [self.view1 setTranslatesAutoresizingMaskIntoConstraints:NO];
     NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offsetY)-[_view1(height)]-|" options:0 metrics:@{@"height":@(48),@"offsetY":@(48)} views:NSDictionaryOfVariableBindings(_view1)];
     [self.view addConstraints:vConstraints];
     NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offsetX)-[_view1(width)]-|" options:0 metrics:@{@"width":@(48),@"offsetX":@(48)} views:NSDictionaryOfVariableBindings(_view1)];
     [self.view addConstraints:hConstraints];
     [self.view1 setNeedsLayout];
     */
    //
    
    self.view2 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor blueColor];
        [self.view addSubview:view];
        view;
    });
    
    self.view3 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:view];
        view;
    });
    
    
    // view 3 的子view
    self.view4 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor redColor];
        [self.view3 addSubview:view];
        view;
    });
    
    
    // 布局
    /*
     NSDictionary *views = NSDictionaryOfVariableBindings(self.view,_view1,_view2,_view3);
     
     [self.view1 setTranslatesAutoresizingMaskIntoConstraints:NO];
     NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offsetY)-[_view1(height)]" options:0 metrics:@{@"height":@(48),@"offsetY":@(48)} views:views];
     [self.view addConstraints:vConstraints];
     NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offsetX)-[_view1(width)]" options:0 metrics:@{@"width":@(48),@"offsetX":@(48)} views:views];
     [self.view addConstraints:hConstraints];
     [self.view1 setNeedsLayout];
     */
    
    /*
     NSDictionary *views = NSDictionaryOfVariableBindings(self.view,_view1,_view2,_view3);
     
     [self.view1 setTranslatesAutoresizingMaskIntoConstraints:NO];
     NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_view1]-0-|" options:NSLayoutFormatAlignAllLeft metrics:@{@"height":@(48),@"offsetY":@(48)} views:views];
     [self.view addConstraints:vConstraints];
     NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_view1]-0-|" options:NSLayoutFormatAlignAllLeft metrics:@{@"width":@(48),@"offsetX":@(48)} views:views];
     [self.view addConstraints:hConstraints];
     [self.view1 setNeedsLayout];
     */
    
    
    /*
     
     NSDictionary *views = NSDictionaryOfVariableBindings(self.view,_view1,_view2,_view3);
     
     [self.view1 setTranslatesAutoresizingMaskIntoConstraints:NO];
     NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offsetY)-[_view1(height)]" options:0 metrics:@{@"height":@(48),@"offsetY":@(48)} views:views];
     [self.view addConstraints:vConstraints];
     NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offsetX)-[_view1(width)]" options:0 metrics:@{@"width":@(48),@"offsetX":@(48)} views:views];
     [self.view addConstraints:hConstraints];
     [self.view1 setNeedsLayout];
     
     [self.view2 setTranslatesAutoresizingMaskIntoConstraints:NO];
     NSArray *vConstraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offsetY)-[_view2(height)]" options:0 metrics:@{@"height":@(48),@"offsetY":@(48)} views:views];
     [self.view addConstraints:vConstraints2];
     NSArray *hConstraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-offsetX-[_view2]-20-|" options:0 metrics:@{@"width":@(48),@"offsetX":@(100)} views:views];
     [self.view addConstraints:hConstraints2];
     [self.view2 setNeedsLayout];
     
     [self.view3 setTranslatesAutoresizingMaskIntoConstraints:NO];
     NSArray *vConstraints3 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offsetY)-[_view3(height)]" options:0 metrics:@{@"height":@(48),@"offsetY":@(100)} views:views];
     [self.view addConstraints:vConstraints3];
     NSArray *hConstraints3 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[_view3]-30-|" options:0 metrics:@{@"width":@(48),@"offsetX":@(100)} views:views];
     [self.view addConstraints:hConstraints3];
     [self.view3 setNeedsLayout];
     */
    
    // 相对布局
    
    NSDictionary *views = NSDictionaryOfVariableBindings(self.view,_view1,_view2,_view3,_view4);
    
    [self.view1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offsetY)-[_view1(height)]" options:0 metrics:@{@"height":@(48),@"offsetY":@(100)} views:views];
    [self.view addConstraints:vConstraints];
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offsetX)-[_view1(width)]" options:0 metrics:@{@"width":@(48),@"offsetX":@(48)} views:views];
    [self.view addConstraints:hConstraints];
    [self.view1 setNeedsLayout];
    
    [self.view2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSArray *vConstraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offsetY)-[_view2(height)]" options:0 metrics:@{@"height":@(48),@"offsetY":@(100)} views:views];
    [self.view addConstraints:vConstraints2];
    // 相对布局
    NSArray *hConstraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[_view1]-50-[_view2]-20-|" options:0 metrics:@{@"width":@(48),@"offsetX":@(100)} views:views];
    [self.view addConstraints:hConstraints2];
    [self.view2 setNeedsLayout];
    
    [self.view3 setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSArray *vConstraints3 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[_view1]-50-[_view3(height)]" options:0 metrics:@{@"height":@(200),@"offsetY":@(100)} views:views];
    [self.view addConstraints:vConstraints3];
    NSArray *hConstraints3 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[_view3]-30-|" options:0 metrics:@{@"width":@(48),@"offsetX":@(100)} views:views];
    [self.view addConstraints:hConstraints3];
    [self.view3 setNeedsLayout];
    
    
    // 子view
    [self.view4 setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSArray *vConstraints4 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offsetY)-[_view4]-(offsetY)-|" options:0 metrics:@{@"height":@(20),@"offsetY":@(40)} views:views];
    [self.view3 addConstraints:vConstraints4];
    NSArray *hConstraints4 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offsetX)-[_view4]-(offsetX)-|" options:0 metrics:@{@"width":@(48),@"offsetX":@(20)} views:views];
    [self.view3 addConstraints:hConstraints4];
    [self.view4 setNeedsLayout];
    
    
}

@end
