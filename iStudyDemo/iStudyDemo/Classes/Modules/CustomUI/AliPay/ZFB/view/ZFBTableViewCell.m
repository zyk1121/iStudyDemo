//
//  ZFBTableViewCell.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/24.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "ZFBTableViewCell.h"
#import "UIKitMacros.h"

#import "ZFBCollectionViewCell.h"

@interface ZFBTableViewCell ()<UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *icons;
@property (nonatomic, strong) NSMutableArray *cells;

@end

@implementation ZFBTableViewCell

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        _cellHeight = SCREEN_WIDTH;
//        self.backgroundColor = [UIColor whiteColor];
//        [self setupUI];
//    }
//    return self;
//}

- (instancetype)initWithIcons:(NSArray *)icons
{
    self = [super init];
    if (self) {
        _cellHeight = SCREEN_WIDTH - 60;
        self.backgroundColor = [UIColor whiteColor];
        self.icons = icons;
        self.icons = @[@"09999976.png",@"09999988.png",@"09999998.png",@"09999999.png",@"10000002.png",@"10000003.png",@"10000004.png",@"10000006.png",@"10000007.png",@"10000008.png",@"10000009.png",@""];
        self.cells = [[NSMutableArray alloc] init];
        [self.icons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *temp = (NSString *)obj;
            ZFBCollectionViewCell *cel = [[ZFBCollectionViewCell alloc] init];
            cel.iconImage = [UIImage imageNamed:temp];
            cel.title = @"name";
            [self.cells addObject:cel];
        }];
        [self setupUI];
    }
    return self;

}

//
- (void)setupUI
{
    //先实例化一个层
    
    UICollectionViewFlowLayout *layout=[[ UICollectionViewFlowLayout alloc ] init ];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    
    //创建一屏的视图大小
    
    UICollectionView *collectionView=[[ UICollectionView alloc ] initWithFrame : CGRectMake(0, 0, SCREEN_WIDTH,_cellHeight) collectionViewLayout:layout];
    
    
    
    [collectionView registerClass :[ ZFBCollectionViewCell class ] forCellWithReuseIdentifier :@"_CELL" ];
    
    collectionView.backgroundColor =[ UIColor whiteColor ];
    
    collectionView.delegate = self;
    
    collectionView.dataSource = self;
    
    
    
    [self addSubview :collectionView];
}

#pragma mark --UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数

-( NSInteger )collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section
{
    
    return self.icons.count;
    
}

//定义展示的Section的个数

-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView
{
    return 1 ;
}

//每个UICollectionView展示的内容

-( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath

{
    ZFBCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier : @"_CELL" forIndexPath :indexPath];
    
    
   
    [cell setupUI ];
    
    cell.iconImage = [UIImage imageNamed:self.icons[indexPath.row]];
    
    cell.title = @"name";
    if (indexPath.row == 11) {
        cell.title = nil;
    }
    
    
    return cell;
    
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法

-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.title = @"测试vc";
    vc.hidesBottomBarWhenPushed = YES;
    [self.vc.navigationController pushViewController:vc animated:YES];
//    UICollectionViewCell * cell = ( UICollectionViewCell *)[collectionView cellForItemAtIndexPath :indexPath];
//    
//    cell. backgroundColor = [ UIColor colorWithRed :(( arc4random ()% 255 )/ 255.0 ) green :(( arc4random ()% 255 )/ 255.0 ) blue :(( arc4random ()% 255 )/ 255.0 ) alpha : 1.0f ];
    
}

//返回这个UICollectionViewCell是否可以被选择
-( BOOL )collectionView:( UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
    
    return YES ;
    
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小

- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath

{
    CGFloat w = SCREEN_WIDTH;
    CGFloat sizeW,sizeH;
    if (w >= 320) {
        sizeW = w  / 4.0;
        sizeH = sizeW;
    } else {
        sizeW = w  / 3.0;
        sizeH = sizeW;
    }
    
    return CGSizeMake(sizeW,sizeH);
    
}

//定义每个UICollectionView 的边距

-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section

{
    
//    return UIEdgeInsetsMake ( 10 , 10 , 10 , 10 );
    return UIEdgeInsetsZero;
    
}

@end
