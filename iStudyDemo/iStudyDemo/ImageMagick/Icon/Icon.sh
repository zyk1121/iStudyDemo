#! /bin/bash

mkdir output
convert Icon.png -resize 120x120! output/AppIcon60x60@2x.png
convert Icon.png -resize 180x180! output/AppIcon60x60@3x.png
convert Icon.png -resize 76x76! output/AppIcon76x76~iPad.png
convert Icon.png -resize 152x152! output/AppIcon76x76~iPad@2x.png
convert Icon.png -resize 40x40! output/AppIcon40x40.png
convert Icon.png -resize 80x80! output/AppIcon40x40@2x.png
convert Icon.png -resize 120x120! output/AppIcon40x40@3x.png
convert Icon.png -resize 29x29! output/AppIcon29x29.png
convert Icon.png -resize 58x58! output/AppIcon29x29@2x.png
convert Icon.png -resize 87x87! output/AppIcon29x29@3x.png
echo 'Icon生成成功！'

