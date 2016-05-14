#! /bin/bash

#xcodebuild -target "LDSearchSDK" -configuration Debug -sdk iphoneos
#xcodebuild -target "LDSearchSDK" -configuration Debug -sdk iphonesimulator

#xcodebuild -target "LDSearchSDK" -configuration Release -sdk iphoneos
#xcodebuild -target "LDSearchSDK" -configuration Release -sdk iphonesimulator

projectName="LDSearchSDK"

rm -rf build
rm -rf output
mkdir output
xcodebuild -target $projectName -configuration Release -sdk iphoneos
xcodebuild -target $projectName -configuration Release -sdk iphonesimulator

lib1='./build/Release-iphoneos/'$projectName'.framework'
lib2='./build/Release-iphonesimulator/'$projectName'.framework'
libout='./output/'$projectName'.framework'

cp -r $lib1 $libout

libSDKName1=$lib1'/'$projectName
libSDKName2=$lib2'/'$projectName
libSDKNameOut=$libout'/'$projectName
lipo -create $libSDKName1 $libSDKName2 -output $libSDKNameOut

rm -rf build

echo '\n\n最终生成的framework info:'
lipo -info $libSDKNameOut
