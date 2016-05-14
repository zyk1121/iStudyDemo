执行sh Icon.sh



#! /bin/bash

mkdir output
convert Icon.png -resize 120x120! output/Icon-60@2x.png
convert Icon.png -resize 180x180! output/Icon-60@3x.png
convert Icon.png -resize 76x76! output/Icon-76.png
convert Icon.png -resize 152x152! output/Icon-76@2x.png
convert Icon.png -resize 40x40! output/Icon-Small-40.png
convert Icon.png -resize 80x80! output/Icon-Small-40@2x.png
convert Icon.png -resize 120x120! output/Icon-Small-40@3x.png
convert Icon.png -resize 29x29! output/Icon-Small.png
convert Icon.png -resize 58x58! output/Icon-Small@2x.png
convert Icon.png -resize 87x87! output/Icon-Small@3x.png
echo 'Icon生成成功！'



1242*2208

#! /bin/bash

mkdir output

#1、针对竖屏启动模式下
#
#iPhone：
#1242*2208(iPhone6 plus 启用高分辨率模式)
#750*1334(iPhone6 启用高分辨率模式)
#640*1136
#640*960
#320*480

convert LaunchImage.png -resize 320x480! output/LaunchImage.png
convert LaunchImage.png -resize 640x960! output/LaunchImage@2x.png
convert LaunchImage.png -resize 640x1136! output/LaunchImage-568h@2x.png
convert LaunchImage.png -resize 750x1334! output/LaunchImage-667h@2x.png
convert LaunchImage.png -resize 1242x2208! output/LaunchImage-736h@3x.png


#2、针对横屏启动模式下
#iPhone:
#2208*1242(iPhone6 plus)

convert LaunchImage.png -resize 1242x2208! LaunchImageTest.png
#翻转
convert -rotate -90 LaunchImageTest.png output/LaunchImage-736v@3x.png
rm LaunchImageTest.png

echo 'LaunchImage生成成功！'


#! /bin/bash

mkdir output

#
#iPhone：
#1242*2208(iPhone6 plus 启用高分辨率模式)
#750*1334(iPhone6 启用高分辨率模式)
#640*1136
#640*960
#320*480

convert NewFeature.jpg -resize 320x480! output/NewFeature_320x480_1.jpg
convert NewFeature.jpg -resize 640x960! output/NewFeature_640x960_1.jpg
convert NewFeature.jpg -resize 640x1136! output/NewFeature_640x1136_1.jpg
convert NewFeature.jpg -resize 750x1334! output/NewFeature_750x1334_1.jpg
convert NewFeature.jpg -resize 1242x2208! output/NewFeature_1242x2208_1.jpg


echo 'NewFeature生成成功！'




http://www.jianshu.com/p/2a04e278133a




http://www.charry.org/docs/linux/ImageMagick/ImageMagick.html
http://www.netingcn.com/category/imagemagick


brew install ImageMagick


接下来，你也需要安装Ghostscript，因为你将使用的ImageMagick会依赖它。Ghostscript是一个软件套件用于呈现PDF和PS文件。你需要它是因为它提供了支持ImageMagick的字体。

安装Ghostscript通过运行下面的命令：

1
brew install ghostscript
如果中间发生错误，运行这个命令：

1
brew doctor
如果安装失败，你会得到一个消息，并告诉你如何去修复它。

这些是所有你需要安装的，以在本教程中使用。



convert Icon.png -fill black -font Times-Bold -pointsize 28 -gravity south -annotate 0 "iStudyDemo" test.png


我将会逐一分解这行命令，因此你将会明白它做了写什么：

1、AppIcon60x60@2x.png 是输入图片的名字;

2、fill white 设置文本为白色;

3、font Times-Bold 告诉ImageMagick使用什么字体;

4、pointsize 18 设置字体的大小为18;

5、gravity south 文本与图片的底部对齐

6、annotate 0 "Hello World" 告诉ImageMagick使带有"Hello World"文本注释的图片旋转的度数为0度；

7、test.png 输出的文件名，并且ImageMagick将会覆盖掉已经存在的文件。



convert Beta.png -resize 500x500 BetaOK.png
convert Beta.png -resize 500x500! BetaOK.png

➜  Flower convert Beta.png -resize 500x500! BetaOK.png
➜  Flower open .
➜  Flower composite Test.png BetaOK.png TestBeta.png
➜  Flower open .
➜  Flower convert Beta.png -resize 512x512! BetaOK.png
➜  Flower composite Test.png BetaOK.png TestBeta.png
➜  Flower composite BetaOK.png Test.png TestBeta.png

http://www.jianshu.com/p/2a04e278133a

http://www.uupoop.com/
