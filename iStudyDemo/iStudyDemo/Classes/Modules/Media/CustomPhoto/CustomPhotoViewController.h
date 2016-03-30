//
//  CustomPhotoViewController.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/29.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 //适用获取所有媒体资源，只需判断资源类型
 - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
 NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
 //判断资源类型
 if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
 //如果是图片
 self.imageView.image = info[UIImagePickerControllerEditedImage];
 //压缩图片
 NSData *fileData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
 //保存图片至相册
 UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
 //上传图片
 [self uploadImageWithData:fileData];
 
 }else{
 //如果是视频
 NSURL *url = info[UIImagePickerControllerMediaURL];
 //播放视频
 _moviePlayer.contentURL = url;
 [_moviePlayer play];
 //保存视频至相册（异步线程）
 NSString *urlStr = [url path];
 
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
 
 UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
 }
 });
 NSData *videoData = [NSData dataWithContentsOfURL:url];
 //视频上传
 [self uploadVideoWithData:videoData];
 }
 [self dismissViewControllerAnimated:YES completion:nil];
 }
 */

@interface CustomPhotoViewController : UIViewController

@end
