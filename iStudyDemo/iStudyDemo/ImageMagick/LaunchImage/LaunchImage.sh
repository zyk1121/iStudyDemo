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

