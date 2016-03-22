//
//  QQMainViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/16.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "QQMainViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "UIView+SHCZExt.h"
#import "PopViewLikeQQView.h"
#import "QQTabbarViewController.h"
#import "QQSideBarViewController.h"
#import "QQSettingViewController.h"

@interface QQMainViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation QQMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupData];
    [self setupUI];
    [self.view updateConstraintsIfNeeded];
}


- (void)viewDidAppear:(BOOL)animated
{
//    [self setHidesBottomBarWhenPushed:YES];
    [self.tabbarVC.sidebarVC addPanGesture];
}

- (void)viewDidDisappear:(BOOL)animated
{
     [self.tabbarVC.sidebarVC removePanGesture];
//    [self setHidesBottomBarWhenPushed:NO];
}

#pragma mark - masonry

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - private method

- (void)setupUI
{
    self.navigationController.navigationBar.backgroundColor = [UIColor lightGrayColor];
    // titleview
    //    分段控件
    UISegmentedControl *segmentC = [[UISegmentedControl alloc]initWithItems:@[@"消息",@"电话"]];
    segmentC.w = 120;
    segmentC.selectedSegmentIndex = 0;
    [segmentC addTarget:self action:@selector(segmentCClicked:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = segmentC;
    // right buttonitem
//    UIButton *cancelBtn=[UIButton buttonWithType:UIBarButtonSystemItemCancel];
////    [searchBtn setImage:[UIImage imageNamed:@"sample.png"] forState:UIControlStateNormal];
////    UIButton *timeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
////    [timeBtn  setImage:[UIImage imageNamed:@"sample.png"] forState:UIControlStateNormal];
//    UIButton *moreBtn=[UIButton buttonWithType:UIBarButtonSystemItemDone];
////    [moreBtn setImage:[UIImage imageNamed:@"sample.png"] forState:UIControlStateNormal];
    UIBarButtonItem *bardoneBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(bardoneBtnClicked)];
    UIBarButtonItem *barcancelBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(barcancelBtnClicked)];
    NSArray *rightBtns=[NSArray arrayWithObjects:bardoneBtn,barcancelBtn, nil];
    self.navigationItem.rightBarButtonItems=rightBtns;
    
    // left buttom item
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        leftView.layer.cornerRadius = 20;
        leftView.image = [UIImage imageNamed:@"hcw.png"];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"hcw.png"] forState:UIControlStateNormal];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"hcw.png"] forState:UIControlStateHighlighted];
    backButton.layer.cornerRadius = 20;
    [backButton addSubview:leftView];
    [backButton addTarget:self action:@selector(doClickBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    _tableView = ({
        UITableView *tableview = [[UITableView alloc] init];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        tableview;
    });
    [self.view addSubview:_tableView];
    
    //  搜索框,可以做成一个特殊的cell
    UISearchBar *sB=[[UISearchBar alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,44)];
    [sB setPlaceholder:@"搜索"];
    self.searchBar = sB;
    [self.tableView addSubview:sB];
    
    //
//    //    添加拖拽
//    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanEvent:)];
//    
//    
//    [self.navigationController.view addGestureRecognizer:pan];
}

- (void)setupData
{
    
}

#pragma mark - event

- (void)segmentCClicked:(UISegmentedControl *)segmentC
{
    NSLog(@"%@",[segmentC titleForSegmentAtIndex:segmentC.selectedSegmentIndex]);
}

- (void)bardoneBtnClicked
{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:@"message" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertView show];
    
    CGPoint point = CGPointMake(1, 0);
    [PopViewLikeQQView configCustomPopViewWithFrame:CGRectMake(200, 100, 150, 200) imagesArr:@[@"saoyisao.png",@"jiahaoyou.png",@"taolun.png",@"diannao.png",@"diannao.png",@"shouqian.png"] dataSourceArr:@[@"扫一扫",@"加好友",@"创建讨论组",@"发送到电脑",@"面对面快传",@"收钱"] anchorPoint:point seletedRowForIndex:^(NSInteger index) {
        NSLog(@"%ld", index + 1);
    } animation:YES timeForCome:0.3 timeForGo:0.3];
}

- (void)barcancelBtnClicked
{
////    NSLog(@"点击了取消");
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
    [self.tabbarVC.sidebarVC dissmissVC];
}

- (void)doClickBackAction:(UIButton *)button
{
    [self.tabbarVC.sidebarVC maskViewClicked];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    QQSettingViewController *vc = [[QQSettingViewController alloc] init];
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 第一个特殊的cell可以专门设计
    static NSString *reuseIdetify = @"tableViewCellIdetify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showsReorderControl = YES;
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = @"hello";
    //    cell.detailTextLabel.text = [self.listData objectForKey:[self.listData allKeys][indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}



//实现拖拽
-(void)didPanEvent:(UIPanGestureRecognizer *)recognizer{
    
    // 1. 获取手指拖拽的时候, 平移的值
    CGPoint translation = [recognizer translationInView:recognizer.view];
    
    // 2. 让当前控件做响应的平移
    recognizer.view.transform = CGAffineTransformTranslate(recognizer.view.transform, translation.x, 0);
//    UINavigationBar *navBar = self.navigationController.navigationBar;
//    CGPoint ttt = [recognizer translationInView:navBar];
//    navBar.transform = CGAffineTransformTranslate(recognizer.view.transform, ttt.x, 0);
    // ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    
    [[[UIApplication sharedApplication].delegate window].subviews objectAtIndex:1].ttx=recognizer.view.ttx/3;
    //    NSLog(@"%f",translation.x/5);
    // ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    // 3. 每次平移手势识别完毕后, 让平移的值不要累加
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
    
    //    NSLog(@"%f",recognizer.view.transform.tx);
    //    NSLog(@"%f",translation.x);
    //    NSLog(@"====================");
    //
    
    //获取最右边范围
    CGAffineTransform  rightScopeTransform=CGAffineTransformTranslate([[UIApplication sharedApplication].delegate window].transform,[UIScreen mainScreen].bounds.size.width*0.75, 0);
    
    //    当移动到右边极限时
    if (recognizer.view.transform.tx>rightScopeTransform.tx) {
        
        //        限制最右边的范围
        recognizer.view.transform=rightScopeTransform;
        //        限制透明view最右边的范围
        [[[UIApplication sharedApplication].delegate window].subviews objectAtIndex:1].ttx=recognizer.view.ttx/3;
        
        //        当移动到左边极限时
    }else if (recognizer.view.transform.tx<0.0){
        
        //        限制最左边的范围
        recognizer.view.transform=CGAffineTransformTranslate([[UIApplication sharedApplication].delegate window].transform,0, 0);
        //    限制透明view最左边的范围
        [[[UIApplication sharedApplication].delegate window].subviews objectAtIndex:1].ttx=recognizer.view.ttx/3;
        
    }
    //    当托拽手势结束时执行
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            if (recognizer.view.x >[UIScreen mainScreen].bounds.size.width*0.5) {
                
                recognizer.view.transform=rightScopeTransform;
                
                [[[UIApplication sharedApplication].delegate window].subviews objectAtIndex:1].ttx=recognizer.view.ttx/3;
                
            }else{
                
                recognizer.view.transform = CGAffineTransformIdentity;
                
                [[[UIApplication sharedApplication].delegate window].subviews objectAtIndex:1].ttx=recognizer.view.ttx/3;
            }
        }];
    }
}

- (void)dealloc
{
    NSLog(@"QQMainViewController dealloc");
}

@end
