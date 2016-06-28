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

- (void)buttonClicked:(UIButton *)button
{
    NSLog(@"button  clicked");
}

@end
