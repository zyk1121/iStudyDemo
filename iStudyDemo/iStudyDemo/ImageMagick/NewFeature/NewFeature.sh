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

