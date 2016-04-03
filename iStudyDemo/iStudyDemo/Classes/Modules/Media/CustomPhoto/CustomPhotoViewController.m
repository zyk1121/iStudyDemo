//
//  CustomPhotoViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/29.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "CustomPhotoViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"

// 打开自定义相机 可以实现连拍，但是支持的功能比较少，如果想实现的好一点，可以用AVFoundation  http://www.objccn.io/issue-21-3/

@interface CustomPhotoViewController ()<UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImagePickerController *picker ;

@end

@implementation CustomPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.button1 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
        [button setTitle:@"打开自定义相机" forState:UIControlStateNormal];
        [button setTitle:@"打开自定义相机" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    self.imageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        imageView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
        [self.view addSubview:imageView];
        imageView;
    });
}

#pragma mark - event

- (void)button1Click:(UIButton *)button
{
    // 打开自定义相机
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        
        self.picker = picker;
        
        picker.delegate = self;
        //设置拍照后的图片可被编辑
//        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        
//                使用imagepicker.cameraViewTransform = CGAffineTransformMakeScale(1.5, 1.5);全屏的效果，同时imagepicker.showsCameraControls  =NO;隐藏工具栏：
        
        picker.cameraViewTransform = CGAffineTransformMakeScale(1, 1.5);
        
        picker.showsCameraControls = NO;
        
        UIToolbar* tool = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-55, self.view.frame.size.width, 55)];
        tool.barStyle = UIBarStyleBlackTranslucent;
        UIBarButtonItem* cancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelCamera)];
        UIBarButtonItem* add = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePhoto)];
        [tool setItems:[NSArray arrayWithObjects:cancel,add, nil]];
        //把自定义的view设置到imagepickercontroller的overlay属性中
        picker.cameraOverlayView = tool;
//        NSArray* vvv = [picker.cameraOverlayView subviews];
        
        [self presentViewController:picker animated:YES completion:^{
            
        }];
        
        //        [self presentModalViewController:picker animated:YES];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}




#pragma mark - delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //        NSData *data;
        //        if (UIImagePNGRepresentation(image) == nil)
        //        {
        //            data = UIImageJPEGRepresentation(image, 1.0);
        //        }
        //        else
        //        {
        //            data = UIImagePNGRepresentation(image);
        //        }
        //
        //        //图片保存的路径
        //        //这里将图片放在沙盒的documents文件夹中
        //        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        //
        //        //文件管理器
        //        NSFileManager *fileManager = [NSFileManager defaultManager];
        //
        //        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        //        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        //        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        //
        //        //得到选择后沙盒中图片的完整路径
        //        NSString * filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        //
        //        [data writeToFile:filePath atomically:YES];
        //
        
        //关闭相册界面(不关闭可以实现连拍)
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
        
//        [[[picker.view subviews] lastObject] removeFromSuperview];
    
        //        [picker dismissModalViewControllerAnimated:YES];
        
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        self.imageView.image = image;
        //加在视图中
        //        [self.view addSubview:smallimage];
        
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void)cancelCamera{
    [self.picker dismissModalViewControllerAnimated:YES];
}
-(void)savePhoto{
    //拍照，会自动回调- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info，对于自定义照相机界面，拍照后回调可以不退出实现连续拍照效果
    [self.picker takePicture];
}

/*
 http://blog.csdn.net/m372897500/article/details/41548319
 
 5.UIImagePickerController是继承UINavigationController,所以可以push和pop一些viewcontroller进行导航效果。例如，自定义照相机画面的时候可以在拍摄完后push一个viewcontroller用于对照片进行编辑。
 */


@end
