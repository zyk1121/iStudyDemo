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

#echo "${SRCROOT}"
#1、第一行打印在你运行你的项目后的问佳佳路径，包含最后一个图标。
#2、第二行打印项目文件所在的文件夹路径。
IFS=$'\n'
#1
PATH=${PATH}:/usr/local/bin

function generateIcon () {
    BASE_IMAGE_NAME=$1
#2
TARGET_PATH="${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/${BASE_IMAGE_NAME}"
BASE_IMAGE_PATH=$(find ${SRCROOT} -name ${BASE_IMAGE_NAME})
WIDTH=$(identify -format %w ${BASE_IMAGE_PATH})
#3
convert IconBeta.png -resize $WIDTHx$WIDTH resizedIconBeta.png
#4
convert ${BASE_IMAGE_PATH} -fill red -font Times-Bold -pointsize 32 -gravity south -annotate 0 "Hello" - | composite resizedIconBeta.png - ${TARGET_PATH}
}
generateIcon "AppIcon60x60@2x.png"
#generateIcon "AppIcon60x60@3x.png"
#generateIcon "AppIcon76x76~ipad.png"
#generateIcon "AppIcon76x76@2x~ipad.png"
#generateIcon "AppIcon29x29.png"
#generateIcon "AppIcon29x29@2x.png"
#generateIcon "AppIcon29x29@3x.png"
#generateIcon "AppIcon40x40.png"
#generateIcon "AppIcon40x40@2x.png"
#generateIcon "AppIcon40x40@3x.png"

#rm resizedIconBeta.png

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
