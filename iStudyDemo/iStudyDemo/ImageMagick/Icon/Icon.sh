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

