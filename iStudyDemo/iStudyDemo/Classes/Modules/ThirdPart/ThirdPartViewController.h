//
//  ThirdPartViewController.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/14.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 http://blog.csdn.net/paulluo0739/article/details/6843312
 
 
 如果两个静态库冲突的结构是相同的，可以考虑将两个静态库拆分出来进行合并。
 
 
 查看文件的架构有哪些
 $ lipo -info libzbar.a
 Architectures in the fat file: libzbar.a are: armv7 (cputype (12) cpusubtype (11)) i386
 
 将armv7解压出来
 lipo libzbar.a -thin armv7 -output libzbar-armv7.a
 
 新建立一个文件夹出来存放解压的(.o)文件
 $ mkdir armv7
 $ cd armv7
 
 将静态库中的文件解压
 $ ar -x ../libzbar-armv7.a
 
 
 然后将另一个静态库根据以上的步骤做一遍，然后观察连个解压的静态库中，有那些是一样的就合并在一起，不过注意的是两个静态库冲突的(.o)文件必须一致，否则也会出现错误。
 
 合并完后进行打包了
 $ libtool -static -o ../libnew-armv7.a *.o
 
 
 如果像在虚拟机也使用，进行相同的步骤后，将i386的架构合并再一起就可以了。
 
 合并静态库
 $ lipo -create -output lib.a libnew-armv76.a libi386.a
 
 */
@interface ThirdPartViewController : UIViewController

@end
