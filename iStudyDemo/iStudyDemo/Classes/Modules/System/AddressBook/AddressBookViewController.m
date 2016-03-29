//
//  AddressBookViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/27.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "AddressBookViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import <AddressBook/AddressBook.h>

// http://www.jianshu.com/p/6acad14cf3c9
// http://blog.csdn.net/yu413854285/article/details/36941475

@interface AddressBookViewController () <UITableViewDataSource, UITableViewDelegate>
{
    ABAddressBookRef addressBook;
    NSArray *myContacts;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *listViewControllers;

//@property (nonatomic, copy) NSArray *myContacts;

@end

@implementation AddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupData];
    [self setupUI];
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - masonry

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView reloadData];
}

#pragma mark - private method

- (void)setupUI
{
    _tableView = ({
        UITableView *tableview = [[UITableView alloc] init];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        tableview;
    });
    [self.view addSubview:_tableView];
    
}

- (void)setupData
{
    addressBook = ABAddressBookCreate();
    
    _listData = [[NSMutableArray alloc] init];
    
    if (nil == myContacts)
    {
        addressBook = ABAddressBookCreate();
        
        //注册通讯录更新回调
        ABAddressBookRegisterExternalChangeCallback(addressBook, addressBookChanged, (__bridge void *)(self));
        
        if ([self checkAddressBookAuthorizationStatus:_tableView])
            myContacts = [NSArray arrayWithArray:(__bridge_transfer NSArray*)
                          ABAddressBookCopyArrayOfAllPeople(addressBook)];
        [self copyAddressBook:addressBook];
    }
    

//    _listViewControllers = [[NSMutableArray alloc] init];
    
//    // 1.二维码扫描
//    [_listData addObject:@"二维码扫描"];
//    QRCodeScanViewController *thirdShareViewController = [[QRCodeScanViewController alloc] init];
//    [_listViewControllers addObject:thirdShareViewController];
//    // 2.二维码生成
//    [_listData addObject:@"二维码生成"];
//    QRCodeCreateViewController *qrcodeViewController = [[QRCodeCreateViewController alloc] init];
//    [_listViewControllers addObject:qrcodeViewController];
    
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.listData.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UIViewController *vc = [self.listViewControllers objectAtIndex:indexPath.row];
//    vc.title = [self.listData objectAtIndex:indexPath.row];
//     [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdetify = @"tableViewCellIdetify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showsReorderControl = YES;
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [self.listData objectAtIndex:indexPath.row];
    //    cell.detailTextLabel.text = [self.listData objectForKey:[self.listData allKeys][indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


#pragma mark - AddressBook

void addressBookChanged(ABAddressBookRef addressBook, CFDictionaryRef info, void* context)
{
    NSLog(@"Address Book Changed");
    //__bridge               arc显式转换。 与__unsafe_unretained 关键字一样 只是引用。被代入对象的所有者需要明确对象生命周期的管理，不要出现异常访问的问题
    //__bridge_retained      类型被转换时，其对象的所有权也将被变换后变量所持有
    //__bridge_transfer      本来拥有对象所有权的变量，在类型转换后，让其释放原先所有权 就相当于__bridge_retained后，原对像执行了release操作
//    UIViewController *viewController = objc_unretainedObject(context);
//    //更新通讯录
//    [viewController updateAddressBook];
    
    //注销通讯录更新回调
    //    ABAddressBookUnregisterExternalChangeCallback(addressBook, addressBookChanged, context);
}

-(bool)checkAddressBookAuthorizationStatus:(UITableView*)tableView
{
    //取得授权状态
    ABAuthorizationStatus authStatus =
    ABAddressBookGetAuthorizationStatus();
    
    if (authStatus != kABAuthorizationStatusAuthorized)
    {
        ABAddressBookRequestAccessWithCompletion
        (addressBook, ^(bool granted, CFErrorRef error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (error)
                     NSLog(@"Error: %@", (__bridge NSError *)error);
                 else if (!granted) {
                     UIAlertView *av = [[UIAlertView alloc]
                                        initWithTitle:@"Authorization Denied"
                                        message:@"Set permissions in Settings>General>Privacy."
                                        delegate:nil
                                        cancelButtonTitle:nil
                                        otherButtonTitles:@"OK", nil];
                     [av show];
                 }
                 else
                 {
                     //还原 ABAddressBookRef
                     ABAddressBookRevert(addressBook);
                     myContacts = [NSArray arrayWithArray:
                                   (__bridge_transfer NSArray*)
                                   ABAddressBookCopyArrayOfAllPeople(addressBook)];
//                     [self copyAddressBook:addressBook];
                     [tableView reloadData];  //
                 }
             });  
         });  
    }
    return YES;
}


- (void)copyAddressBook:(ABAddressBookRef)addressBook
{
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for ( int i = 0; i < numberOfPeople; i++){
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        
        NSString *name = [NSString stringWithFormat:@"%@%@",lastName,firstName];
//        [_listData addObject:name];
        
        //读取middlename
        NSString *middlename = (__bridge NSString*)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
        //读取prefix前缀
        NSString *prefix = (__bridge NSString*)ABRecordCopyValue(person, kABPersonPrefixProperty);
        //读取suffix后缀
        NSString *suffix = (__bridge NSString*)ABRecordCopyValue(person, kABPersonSuffixProperty);
        //读取nickname呢称
        NSString *nickname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonNicknameProperty);
        //读取firstname拼音音标
        NSString *firstnamePhonetic = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty);
        //读取lastname拼音音标
        NSString *lastnamePhonetic = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty);
        //读取middlename拼音音标
        NSString *middlenamePhonetic = (__bridge NSString*)ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty);
        //读取organization公司
        NSString *organization = (__bridge NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);
        //读取jobtitle工作
        NSString *jobtitle = (__bridge NSString*)ABRecordCopyValue(person, kABPersonJobTitleProperty);
        //读取department部门
        NSString *department = (__bridge NSString*)ABRecordCopyValue(person, kABPersonDepartmentProperty);
        //读取birthday生日
        NSDate *birthday = (__bridge NSDate*)ABRecordCopyValue(person, kABPersonBirthdayProperty);
        //读取note备忘录
        NSString *note = (__bridge NSString*)ABRecordCopyValue(person, kABPersonNoteProperty);
        //第一次添加该条记录的时间
        NSString *firstknow = (__bridge NSString*)ABRecordCopyValue(person, kABPersonCreationDateProperty);
        NSLog(@"第一次添加该条记录的时间%@\n",firstknow);
        //最后一次修改該条记录的时间
        NSString *lastknow = (__bridge NSString*)ABRecordCopyValue(person, kABPersonModificationDateProperty);
        NSLog(@"最后一次修改該条记录的时间%@\n",lastknow);
        
        //获取email多值
        ABMultiValueRef email = ABRecordCopyValue(person, kABPersonEmailProperty);
        int emailcount = ABMultiValueGetCount(email);
        for (int x = 0; x < emailcount; x++)
        {
            //获取email Label
            NSString* emailLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(email, x));
            //获取email值
            NSString* emailContent = (__bridge NSString*)ABMultiValueCopyValueAtIndex(email, x);
        }
        //读取地址多值
        ABMultiValueRef address = ABRecordCopyValue(person, kABPersonAddressProperty);
        int count = ABMultiValueGetCount(address);
        
        for(int j = 0; j < count; j++)
        {
            //获取地址Label
            NSString* addressLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(address, j);
            //获取該label下的地址6属性
            NSDictionary* personaddress =(__bridge NSDictionary*) ABMultiValueCopyValueAtIndex(address, j);
            NSString* country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
            NSString* city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
            NSString* state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
            NSString* street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
            NSString* zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
            NSString* coutntrycode = [personaddress valueForKey:(NSString *)kABPersonAddressCountryCodeKey];
        }
        
        //获取dates多值
        ABMultiValueRef dates = ABRecordCopyValue(person, kABPersonDateProperty);
        int datescount = ABMultiValueGetCount(dates);
        for (int y = 0; y < datescount; y++)
        {
            //获取dates Label
            NSString* datesLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(dates, y));
            //获取dates值
            NSString* datesContent = (__bridge NSString*)ABMultiValueCopyValueAtIndex(dates, y);
        }
        //获取kind值
        CFNumberRef recordType = ABRecordCopyValue(person, kABPersonKindProperty);
        if (recordType == kABPersonKindOrganization) {
            // it's a company
            NSLog(@"it's a company\n");
        } else {
            // it's a person, resource, or room
            NSLog(@"it's a person, resource, or room\n");
        }
        
        
        //获取IM多值
        ABMultiValueRef instantMessage = ABRecordCopyValue(person, kABPersonInstantMessageProperty);
        for (int l = 1; l < ABMultiValueGetCount(instantMessage); l++)
        {
            //获取IM Label
            NSString* instantMessageLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(instantMessage, l);
            //获取該label下的2属性
            NSDictionary* instantMessageContent =(__bridge NSDictionary*) ABMultiValueCopyValueAtIndex(instantMessage, l);
            NSString* username = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageUsernameKey];
            
            NSString* service = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageServiceKey];
        }
        
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            //获取电话Label
            NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            //获取該Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            [_listData addObject:[NSString stringWithFormat:@"%@:%@",name,personPhone]];
            
        }
        
        //获取URL多值
        ABMultiValueRef url = ABRecordCopyValue(person, kABPersonURLProperty);
        for (int m = 0; m < ABMultiValueGetCount(url); m++)
        {
            //获取电话Label
            NSString * urlLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(url, m));
            //获取該Label下的电话值
            NSString * urlContent = (__bridge NSString*)ABMultiValueCopyValueAtIndex(url,m);
        }
        
        //读取照片
        NSData *image = (__bridge NSData*)ABPersonCopyImageData(person);
        
    }
}

@end