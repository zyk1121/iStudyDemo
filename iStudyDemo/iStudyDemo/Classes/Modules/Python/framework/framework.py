#!/usr/bin/python
# -*- coding: utf-8 -*-

import math
import os
import os.path
import shutil

# start

currentPath = os.path.abspath('.')
print("1.当前目录:" + currentPath)
frameworkPath = currentPath + "/framework"
print("2.framework目录:" + frameworkPath)
outputPath = currentPath + "/output"
# os.rmdir(outputPath)
os.system('rm -rf ' + outputPath)
# os.mkdir(outputPath)
# print("3.创建了output文件夹，用于存放生成的文件")
frameworks = os.listdir(frameworkPath)

f1 = ''# XXX1.framework
f2 = ''# XXX2.framework
fileName = ''# XXX.framework
if len(frameworks) == 2:
    # print(frameworks[0])
    # print(frameworks[1])
    # 合法性校验
    f1 = frameworks[0]
    f2 = frameworks[1]
    if f1[-10] == '.' and f1[-11] == '1' and f2[-10] == '.' and f2[-11] == '2':
        #拷贝文件
        # f.remove(-11)
        f = f1
        fileName = f[0:f.find('1.')] # name
        print('3.framework二进制的文件名为:' + fileName)
        shutil.copytree(frameworkPath + '/' + f1,outputPath + '/' + fileName + '.framework')  
        # os.system('cp ./framework/' + f1 './output/')
    else:
        print('./framework目录中只能存放XXX1.framework和XXX2.framework，文件命名错误')
        os.system('rm -rf ' + outputPath)
        quit();
        
else:
    print('./framework目录中只能存放XXX1.framework和XXX2.framework')
    os.system('rm -rf ' + outputPath)
    quit();    

#使用fileName
# os.system('lipo -info ' + frameworkPath + '/' + f1 + '/' + fileName)
lipostr =  'lipo -create ' + frameworkPath + '/' + f1 + '/' + fileName + ' ' + frameworkPath + '/' + f2 + '/' + fileName + ' ' + '-output ' + outputPath + '/' + fileName + '.framework'+ '/' + fileName;
os.system(lipostr)
print('4.最终的framework创建成功，请到output文件夹下查看，' + outputPath + '/' + fileName + '.framework');
print('5.目标架构为:')
os.system('lipo -info ' + outputPath + '/' + fileName + '.framework/' + fileName)

