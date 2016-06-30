//
//  BSLoginRegisterView.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/6/28.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSLoginRegisterView.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"

#define kBSLoginRegisterNamePlaceholderKey @"name"
#define kBSLoginRegisterPassWordPlaceholderKey @"password"
#define kBSLoginRegisterLoginButtonKey @"loginbtn"

@interface BSLoginRegisterView ()
{
    NSMutableDictionary *_contentData;
}

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, strong) UITextField *passWordTextField;
@property (nonatomic, strong) UIButton    *loginRegisteButton;
@property (nonatomic, strong) UIButton    *fogotPasswordButton;

@end

@implementation BSLoginRegisterView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupData];
        [self setupUI];
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andLoginRegisterType:(BSLoginRegisterType)type
{
    self = [self initWithFrame:frame];
    self.type = type;
    return self;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)setupData
{
    self.type = BSLoginRegisterTypeLogin;
}

- (void)setType:(BSLoginRegisterType)type
{
    _type = type;
    _contentData = [[NSMutableDictionary alloc] init];
    if (type == BSLoginRegisterTypeLogin) {
        // 登录
        [_contentData setObject:@"手机号" forKey:kBSLoginRegisterNamePlaceholderKey];
        [_contentData setObject:@"密码" forKey:kBSLoginRegisterPassWordPlaceholderKey];
        [_contentData setObject:@"登录" forKey:kBSLoginRegisterLoginButtonKey];
    } else {
        // 注册
        [_contentData setObject:@"请输入手机号" forKey:kBSLoginRegisterNamePlaceholderKey];
        [_contentData setObject:@"请输入密码" forKey:kBSLoginRegisterPassWordPlaceholderKey];
        [_contentData setObject:@"注册" forKey:kBSLoginRegisterLoginButtonKey];
    }
    
    self.userNameTextField.placeholder = [_contentData objectForKey:kBSLoginRegisterNamePlaceholderKey];
    self.passWordTextField.placeholder = [_contentData objectForKey:kBSLoginRegisterPassWordPlaceholderKey];
    NSString *buttonTitle = [_contentData objectForKey:kBSLoginRegisterLoginButtonKey];
    [self.loginRegisteButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.loginRegisteButton setTitle:buttonTitle forState:UIControlStateHighlighted];
}

- (void)setupUI
{
    _bgImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"login_rgister_textfield_bg"];
        [self addSubview:imageView];
        imageView;
    });
    
    _userNameTextField = ({
        UITextField *textField = [[UITextField alloc] init];
        textField.borderStyle = UITextBorderStyleNone;
        textField.tintColor = [UIColor whiteColor];
        textField.keyboardType = UIKeyboardTypePhonePad;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.placeholder = [_contentData objectForKey:kBSLoginRegisterNamePlaceholderKey];
//        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[_contentData objectForKey:kBSLoginRegisterNamePlaceholderKey]
//                                               
//                                                                              attributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor]}];// 当聚焦的时候可以修改这个值，使得placeholder高亮
        [textField addTarget:self action:@selector(beginEditingTextField) forControlEvents:UIControlEventEditingDidBegin];
        [textField addTarget:self action:@selector(endEditingTextField) forControlEvents:UIControlEventEditingDidEnd];
        [self addSubview:textField];
        textField;
    });
    
    _passWordTextField = ({
        UITextField *textField = [[UITextField alloc] init];
        textField.borderStyle = UITextBorderStyleNone;
        textField.secureTextEntry = YES;
        textField.tintColor = [UIColor whiteColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.placeholder = [_contentData objectForKey:kBSLoginRegisterPassWordPlaceholderKey];
        [self addSubview:textField];
        textField;
    });
    
    _loginRegisteButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.tag = 1;
        NSString *buttonTitle = [_contentData objectForKey:kBSLoginRegisterLoginButtonKey];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setTitle:buttonTitle forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"login_register_button"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"login_register_button_click"] forState:UIControlStateHighlighted];
//        button.layer.cornerRadius = 5;
//        button.layer.masksToBounds = YES;//button.clipsToBounds = yes;
        [button setValue:@5 forKeyPath:@"layer.cornerRadius"];
        [button setValue:@YES forKeyPath:@"layer.masksToBounds"];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        button;
    });
    
    if (_type == BSLoginRegisterTypeLogin)
     {
         // 忘记密码
         _fogotPasswordButton = ({
             UIButton *button = [[UIButton alloc] init];
             button.tag = 2;
             [button setTitle:@"忘记密码?" forState:UIControlStateNormal];
             [button setTitle:@"忘记密码?" forState:UIControlStateHighlighted];
             [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
             [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
             //        button.layer.cornerRadius = 5;
             //        button.layer.masksToBounds = YES;//button.clipsToBounds = yes;
//             [button setValue:@5 forKeyPath:@"layer.cornerRadius"];
//             [button setValue:@YES forKeyPath:@"layer.masksToBounds"];
             [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
             [self addSubview:button];
             button;
         });
     }
}

- (void)updateConstraints
{
    //
    [self.bgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    [self.userNameTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView);
        make.left.equalTo(self.bgImageView).offset(5);
        make.right.equalTo(self.bgImageView).offset(-5);
        make.height.equalTo(@(self.bgImageView.image.size.height/2));
    }];
    
    [self.passWordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameTextField.mas_bottom);
        make.left.equalTo(self.bgImageView).offset(5);
        make.right.equalTo(self.bgImageView).offset(-5);
        make.height.equalTo(self.userNameTextField);
    }];
    
    if (self.type == BSLoginRegisterTypeLogin) {
        // 登录
        [self.loginRegisteButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgImageView);
            make.right.equalTo(self.bgImageView);
            make.top.equalTo(self.bgImageView.mas_bottom).offset(15);
            make.height.equalTo(@44);
        }];
        [self.fogotPasswordButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loginRegisteButton.mas_bottom).offset(15);
            make.right.equalTo(self.bgImageView);
            make.bottom.equalTo(self);
        }];
    } else  {
        // 注册
        [self.loginRegisteButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgImageView);
            make.right.equalTo(self.bgImageView);
            make.top.equalTo(self.bgImageView.mas_bottom).offset(15);
            make.height.equalTo(@44);
            make.bottom.equalTo(self);
        }];
    }
 
    [super updateConstraints];
}

#pragma mark - event

// 获得焦点
- (void)beginEditingTextField
{
            self.userNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[_contentData objectForKey:kBSLoginRegisterNamePlaceholderKey]
    
                                                                                  attributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor]}];// 当聚焦的时候可以修改这个值，使得placeholder高亮
}

// 失去焦点
- (void)endEditingTextField
{
    self.userNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[_contentData objectForKey:kBSLoginRegisterNamePlaceholderKey]
                                                    
                                                                                   attributes:@{ NSForegroundColorAttributeName:[UIColor lightGrayColor]}];// 当聚焦的时候可以修改这个值，使得placeholder高亮
}

- (void)buttonClicked:(UIButton *)button
{
    // NSMutableAttributedString
    /*
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 80)];
//    label.text = @"dddd";
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"今天天气不错\n呀ddd;jgd"];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:16.0]
     
                          range:NSMakeRange(2, 2)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor redColor]
     
                          range:NSMakeRange(2, 2)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor redColor]
     
                          range:NSMakeRange(7, 2)];
    
    label.attributedText = AttributedStr;
    label.numberOfLines = 0;
    [self addSubview:label];
     
     */
    
// 图文混排
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 80)];
    label.backgroundColor = [UIColor lightGrayColor];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] init];
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"wenzi"];
//    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"dd"];
    // 图片
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"loginBtnBg"];
//    textAttachment.bounds = CGRectMake(0, -5, 25, 25);
    textAttachment.bounds = CGRectMake(0, -5, label.font.lineHeight, label.font.lineHeight);
    NSAttributedString *str2 = [NSAttributedString attributedStringWithAttachment:textAttachment];
     NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:@"哈哈"];
    [AttributedStr appendAttributedString:str1];
    [AttributedStr appendAttributedString:str2];
    [AttributedStr appendAttributedString:str3];
    label.attributedText = AttributedStr;
    label.numberOfLines = 0;
    [self addSubview:label];
}

/*
 NSMutableAttributedString
 
 1.     实例化方法和使用方法
 
 实例化方法：
 
 使用字符串初始化
 - (id)initWithString:(NSString *)str;
 例：
 NSMutableAttributedString *AttributedStr = [[NSMutableAttributedStringalloc]initWithString:@"今天天气不错呀"];
 
 - (id)initWithString:(NSString *)str attributes:(NSDictionary *)attrs;
 
 字典中存放一些属性名和属性值，如：
 NSDictionary *attributeDict = [NSDictionarydictionaryWithObjectsAndKeys:
 [UIFontsystemFontOfSize:15.0],NSFontAttributeName,
 [UIColorredColor],NSForegroundColorAttributeName,
 NSUnderlineStyleAttributeName,NSUnderlineStyleSingle,nil];
 NSMutableAttributedString *AttributedStr = [[NSMutableAttributedStringalloc]initWithString:@"今天天气不错呀" attributes:attributeDict];
 - (id)initWithAttributedString:(NSAttributedString *)attester;
 使用NSAttributedString初始化，跟NSMutableString，NSString类似
 
 使用方法：
 为某一范围内文字设置多个属性
 - (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range;
 为某一范围内文字添加某个属性
 - (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;
 为某一范围内文字添加多个属性
 - (void)addAttributes:(NSDictionary *)attrs range:(NSRange)range;
 移除某范围内的某个属性
 - (void)removeAttribute:(NSString *)name range:(NSRange)range;
 2.     常见的属性及说明
 
 NSFontAttributeName
 字体
 NSParagraphStyleAttributeName
 段落格式
 NSForegroundColorAttributeName
 字体颜色
 NSBackgroundColorAttributeName
 背景颜色
 NSStrikethroughStyleAttributeName
 删除线格式
 NSUnderlineStyleAttributeName
 下划线格式
 NSStrokeColorAttributeName
 删除线颜色
 NSStrokeWidthAttributeName
 删除线宽度
 NSShadowAttributeName
 阴影
 
 */

@end
