#! /bin/bash

#xcodebuild -target "LDSearchSDK" -configuration Debug -sdk iphoneos
#xcodebuild -target "LDSearchSDK" -configuration Debug -sdk iphonesimulator

#xcodebuild -target "LDSearchSDK" -configuration Release -sdk iphoneos
#xcodebuild -target "LDSearchSDK" -configuration Release -sdk iphonesimulator

projectName="LDTBTKit"

rm -rf build
rm -rf output
mkdir output
xcodebuild -target $projectName -configuration Release -sdk iphoneos
xcodebuild -target $projectName -configuration Release -sdk iphonesimulator

lib1='./build/Release-iphoneos/lib'$projectName'.a'
lib2='./build/Release-iphonesimulator/lib'$projectName'.a'
libout='./output/lib'$projectName'.a'

lipo -create $lib1 $lib2 -output $libout

rm -rf build

echo '\n\n最终生成的lib info:'
lipo -info $libout
