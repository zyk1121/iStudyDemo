//
//  DataStorageViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/8.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "DataStorageViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import <Foundation/Foundation.h>
#import "TestDomainObject.h"
#import <sqlite3.h>
#import "FMDB.h"
#import <CoreData/CoreData.h>
#import "User.h"
#import "ObjectManager/ObjectStorageManager.h"

@interface DataStorageViewController ()

@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property(strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIButton *button4;
@property (nonatomic, strong) UIButton *button5;



@end

@implementation DataStorageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - masonry

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    //
    [self.button1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(80);
    }];
    
    [self.button2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.button1.mas_bottom).offset(20);
    }];
    
    [self.button3 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.button2.mas_bottom).offset(20);
    }];
    
    [self.button4 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.button3.mas_bottom).offset(20);
    }];
    
    [self.button5 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.button4.mas_bottom).offset(20);
    }];
}

#pragma mark - private method

- (void)setupUI
{
    self.button1 = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"NSUserDefaults" forState:UIControlStateNormal];
        [button setTitle:@"NSUserDefaults" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button setBackgroundColor:[UIColor grayColor]];
        [button addTarget:self action:@selector(button1Clicked) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:self.button1];
    
    self.button2 = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"NSKeyedArchiver" forState:UIControlStateNormal];
        [button setTitle:@"NSKeyedArchiver" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button setBackgroundColor:[UIColor grayColor]];
        [button addTarget:self action:@selector(button2Clicked) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:self.button2];
    
    self.button3 = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"文件读写" forState:UIControlStateNormal];
        [button setTitle:@"文件读写" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button setBackgroundColor:[UIColor grayColor]];
        [button addTarget:self action:@selector(button3Clicked) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:self.button3];
    
    self.button4 = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"数据库操作" forState:UIControlStateNormal];
        [button setTitle:@"数据库操作" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button setBackgroundColor:[UIColor grayColor]];
        [button addTarget:self action:@selector(button4Clicked) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:self.button4];
    
    self.button5 = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"自定义操作" forState:UIControlStateNormal];
        [button setTitle:@"自定义操作" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button setBackgroundColor:[UIColor grayColor]];
        [button addTarget:self action:@selector(button5Clicked) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:self.button5];
}

#pragma mark - event

// NSUserDefaults
- (void)button1Clicked
{
    [[NSUserDefaults standardUserDefaults] setObject:@"12345" forKey:@"keyValue"];
    id data = [[NSUserDefaults standardUserDefaults] objectForKey:@"keyValue"];
    NSLog(@"%@", data);
    // NSUserDefaults支持的数据格式有：NSNumber，NSString，NSDate，NSArray，NSDictionary类型。
}

// NSKeyedArchiver
- (void)button2Clicked
{
    /*NSKeyedArchiver：采用归档的形式来保存数据，该数据对象需要遵守NSCoding协议，并且该对象对应的类必须提供encodeWithCoder:和initWithCoder:方法。前一个方法告诉系统怎么对对象进行编码，而后一个方法则是告诉系统怎么对对象进行解码。*/
    // 继承自LEDDomainObject的都支持NSCopying协议
    TestDomainObject *test = [[TestDomainObject alloc] init];
    test.amount = 23.44;
    test.bankName = @"china";
    test.iconURL = [NSURL URLWithString:@"http://www.baidu.com"];
    
    
    //写入
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString *documentDirectory =[documentPaths objectAtIndex:0];
    NSString *filepath = [documentDirectory stringByAppendingPathComponent:@"123.dat"];//fileName就是保存文件的文件名
    [NSKeyedArchiver archiveRootObject:test toFile:filepath];
    
    //读取
    
    id data = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
    
    NSLog(@"%@", data);
    
}

// 文件读写
- (void)button3Clicked
{
    //写入
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString *documentDirectory =[documentPaths objectAtIndex:0];
    NSString *filepath = [documentDirectory stringByAppendingPathComponent:@"file.dat"];//fileName就是保存文件的文件名
    
    
    /*
     // 字符串转Data
     NSString *str =@"jesfds";
     NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
     //NSData 转NSString
     NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     
     //data 转char
     NSData *data;
     char *test=[data bytes];
     
     // char 转data
     byte* tempData = malloc(sizeof(byte)*16);
     NSData *content=[NSData dataWithBytes:tempData length:16];
     */
    // NSData 可以直接写入
    NSString *data = @"abcdefg";
    [data writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    id dddata = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"%@",dddata);
    [NSData dataWithContentsOfFile:filepath];
}

#pragma mark - 数据库操作

- (void)sqliteTest
{
    // 初始化数据库要保存的地方，如果存在则删除
    NSString* strSQLiteFilePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"sqlite.sqlite"];
    
    BOOL bIsDir = FALSE;
    if ([[NSFileManager defaultManager] fileExistsAtPath:strSQLiteFilePath isDirectory:&bIsDir]) {
        [[NSFileManager defaultManager] removeItemAtPath:strSQLiteFilePath error:nil];
    }
    
    sqlite3* sqlite = NULL;
    
    // 首先打开数据库路径，如果不存在则创建
    if (SQLITE_OK != sqlite3_open([strSQLiteFilePath UTF8String], &sqlite)) {
        NSLog(@"sqlite3: open error...");
    }
    
    // create table
    // 创建表，主要就是sql语句
    NSString* strCreateTable = @"CREATE TABLE TESTCOREDATA(intType INTEGER, floatType FLOAT, doubleType DOUBLE, stringType VARCHAR(256))";
    if (sqlite3_exec(sqlite, [strCreateTable UTF8String], nil, nil, nil) != SQLITE_OK) {
        NSLog(@"sqlite Create table error...");
    }
    
    // 接下来是生成10w条测试数据
//    NSArray* arrayTest = [self arrayWithData:100000];
    NSLog(@"Before save...");
    // !!!这里很重要，将所有的insert操作作为一个transaction操作，这样避免每次insert的时候都去写文件，导致IO时间拖慢整个数据插入操作
    NSString* strBegin = @"BEGIN TRANSACTION";
    sqlite3_exec(sqlite, [strBegin UTF8String], NULL, NULL, NULL);
    // 遍历数据并插入，就是普通的sql语句操作
    for (int i = 0; i < 10; i++)
    {
        int intdata = i;
        float floatdata = i;
        double doubledata = i;
        NSString *ddd = [NSString stringWithFormat:@"%d",i];
        
        NSString* strSQLInsert = [NSString stringWithFormat:@"INSERT INTO TESTCOREDATA(intType, floatType, doubleType, stringType) values(%d, %f, %lf, '%@')", intdata, floatdata, doubledata, ddd];
        
        if (SQLITE_OK != sqlite3_exec(sqlite, [strSQLInsert UTF8String], NULL, NULL, NULL))
        {
//            const char* errormsg = sqlite3_errmsg(sqlite);
            NSLog(@"exec Error...");
        }
    }
    
    // 提交所有的插入操作
    NSString* strEnd = @"COMMIT";
    sqlite3_exec(sqlite, [strEnd UTF8String], NULL, NULL, NULL);
    
    NSLog(@"End Save...");
    
    
    // 不使用的时候关闭即可
    sqlite3_close(sqlite);
    sqlite = NULL;
}

// http://blog.csdn.net/xyz_lmn/article/details/9312837
- (void)FMDBTest
{
      NSString* strSQLiteFilePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"fmdb.sqlite"];
    BOOL bIsDir = FALSE;
    if ([[NSFileManager defaultManager] fileExistsAtPath:strSQLiteFilePath isDirectory:&bIsDir]) {
        [[NSFileManager defaultManager] removeItemAtPath:strSQLiteFilePath error:nil];
    }
    
    FMDatabase* db = [FMDatabase databaseWithPath:strSQLiteFilePath];
    
    if (![db open]) {
        NSLog(@"db Open Error...");
    }
    
    NSString* strCreateTable = @"CREATE TABLE TESTCOREDATA(intType INTEGER, floatType FLOAT, doubleType DOUBLE, stringType VARCHAR(256))";
    
    [db executeUpdate:strCreateTable];
    
    NSLog(@"begin ");
    [db beginTransaction];
    
//    NSArray* arrayTest = [self arrayWithData:100000];
    
    // 遍历数据并插入，就是普通的sql语句操作
    for (int i = 0; i < 10; i++)
    {
        int intdata = i;
        float floatdata = i;
        double doubledata = i;
        NSString *ddd = [NSString stringWithFormat:@"%d",i];
        
        NSString* strSQLInsert = [NSString stringWithFormat:@"INSERT INTO TESTCOREDATA(intType, floatType, doubleType, stringType) values(%d, %f, %lf, '%@')", intdata, floatdata, doubledata, ddd];
        [db executeUpdate:strSQLInsert];
    }
    
    [db commit];
    NSLog(@"end...");
    
    [db close];
    db = nil;
}

- (void)CoreDataTest
{
    // initilize
    NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"coreData" withExtension:@"momd"];
     NSManagedObjectModel *coreDataModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    我们可以理解为，coreDataModel就代表了该模型。
//    接下来，我们需要考虑，有了模型后，数据最终应该存在哪里?答案是：文件。接下来我们有另外一个类来管理模型跟文件之间的对应关系：
    NSString* strInfoPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"coreData.sqlite"];
    NSPersistentStoreCoordinator *coreDataCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:coreDataModel];
    
    [coreDataCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:strInfoPath] options:nil error:nil];


    // 对context进行操作
    NSManagedObjectContext *coreDataContext = [[NSManagedObjectContext alloc] init];
    [coreDataContext setPersistentStoreCoordinator:coreDataCoordinator];
    
    NSManagedObject* object = [NSEntityDescription insertNewObjectForEntityForName:@"TestCoreData" inManagedObjectContext:coreDataContext];
    
    [object setValue:[NSNumber numberWithInt:1] forKey:@"intType"];
    [object setValue:[NSNumber numberWithFloat:2.3] forKey:@"floatType"];
    [object setValue:[NSNumber numberWithDouble:3.45] forKey:@"doubleType"];
    [object setValue:[NSString stringWithUTF8String:"345abc"] forKey:@"stringType"];
    
    // http://blog.csdn.net/chen505358119/article/details/9334831
}

// coredata
// http://blog.csdn.net/chen505358119/article/details/9334831
/*
 （1）NSManagedObjectModel(被管理的对象模型)
 相当于实体，不过它包含 了实体间的关系
 (2)NSManagedObjectContext(被管理的对象上下文)
 操作实际内容
 作用：插入数据  查询  更新  删除
 （3）NSPersistentStoreCoordinator(持久化存储助理)
 相当于数据库的连接器
 (4)NSFetchRequest(获取数据的请求)
 相当于查询语句
 (5)NSPredicate(相当于查询条件)
 (6)NSEntityDescription(实体结构)
 (7)后缀名为.xcdatamodel的包
 里面的.xcdatamodel文件，用数据模型编辑器编辑
 编译后为.momd或.mom文件，这就是为什么文件中没有这个东西，而我们的程序中用到这个东西而不会报错的原因
 */
#pragma mark - coredata
//托管对象
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

// 托管对象上下文
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType
        ];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// 持久化存储协调器
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSURL *storeURL = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"CoreDataUser.sqlite"]];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {         NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    return _persistentStoreCoordinator;
}

// 插入数据
- (void)addIntoDataSource
{
    User *user = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[self managedObjectContext]];
    [user setName:@"cyy"];
    [user setAge:@21];
    [user setSex:@"girl"];
    NSError *error = nil;
    BOOL isSaveSuccess = [self.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
    } else {
        NSLog(@"Save successful");
    }
}
// 查询
- (void)query
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *user = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:user];
    NSError *error = nil;
    NSMutableArray *mutableFetchRequest = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchRequest == nil) {
        NSLog(@"ERror:%@",error);
    }
    for (User *user in mutableFetchRequest) {
        NSLog(@"name:%@,age:%@,sex:%@",user.name,user.age,user.sex);
    }
}
// 更新
- (void)update
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *user = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:user];
    // 查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name==%@",@"cyy"];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSMutableArray *arrayQequest = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (arrayQequest != nil) {
        NSLog(@"error:%@",error);
    }
    // 更新age后要进行保存,否则更新失败
    for (User *user in arrayQequest) {
        [user setAge:[NSNumber numberWithInt:25]];
    }
    [self.managedObjectContext save:&error];
}
// 删除
- (void)del
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *user = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:user];
    // 查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name==%@",@"cyy"];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSMutableArray *arrayQequest = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (arrayQequest != nil) {
        NSLog(@"error:%@",error);
    }
    // 删除后要进行保存,否则删除失败
    for (User *user in arrayQequest) {
        [self.managedObjectContext deleteObject:user];
    }
    [self.managedObjectContext save:&error];
}

- (void)CoreDataTest2
{
    [self addIntoDataSource];
//    [self update];
    [self del];
    [self query];
}

// 数据库操作
// http://www.cocoachina.com/bbs/read.php?tid=182227
- (void)button4Clicked
{
    // sqlite
//    [self sqliteTest];
    // FMDB
    
//    [self FMDBTest];
    // CoreData
//    [self CoreDataTest];
    [self CoreDataTest2];
    
}

// 自定义操作

- (void)button5Clicked
{
    [[ObjectStorageManager sharedObjectManager] saveObject:@"23456bac" forKey:@"abc"];
    id ddd = [[ObjectStorageManager sharedObjectManager] objectForKey:@"abc"];
    NSLog(@"%@",ddd);
    [[ObjectStorageManager sharedObjectManager] cleanCache];
}

@end

