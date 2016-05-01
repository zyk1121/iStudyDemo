#!/usr/bin/python
# -*- coding: utf-8 -*-

import math
import os
import os.path
import shutil





# pathOpen = os.popen('pwd')
# path = pathOpen.read()
# # os.system('pwd')
# print(path)


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




#操作文件和目录
# print( os.path.abspath('.'))
"""
# 在某个目录下创建一个新目录，首先把新目录的完整路径表示出来:
>>> os.path.join('/Users/michael', 'testdir')
'/Users/michael/testdir'
# 然后创建一个目录:
>>> os.mkdir('/Users/michael/testdir')
# 删掉一个目录:
>>> os.rmdir('/Users/michael/testdir')
# 对文件重命名:
>>> os.rename('test.txt', 'test.py')
# 删掉文件:
>>> os.remove('test.py')

最后看看如何利用Python的特性来过滤文件。比如我们要列出当前目录下的所有目录，只需要一行代码：
[x for x in os.listdir('.') if os.path.isdir(x)]

要列出所有的.py文件，也只需一行代码：
[x for x in os.listdir('.') if os.path.isfile(x) and os.path.splitext(x)[1]=='.py']

同样的道理，要拆分路径时，也不要直接去拆字符串，而要通过os.path.split()函数，这样可以把一个路径拆分为两部分，后一部分总是最后级别的目录或文件名：

>>> os.path.split('/Users/michael/testdir/file.txt')
('/Users/michael/testdir', 'file.txt')
os.path.splitext()可以直接让你得到文件扩展名，很多时候非常方便：

>>> os.path.splitext('/path/to/file.txt')
('/path/to/file', '.txt')
#coding=gbk    
import sys, shutil, os, string  
mp3List = "F:\\My Documents\\mp3list\\默认精选.m3u"  
destDir = "G:\\POP\\默认精选"  
  
def cpFile(srcPath):  
    fileName = os.path.basename(srcPath)  
    destPath = destDir + os.path.sep + fileName  
    if os.path.exists(srcPath) and not os.path.exists(destPath):  
        print 'cp %s %s' % (srcPath,destPath)  
        shutil.copy(srcPath,destPath)  
  
if __name__ == '__main__':  
    f = file(mp3List, 'r')  
    lists = f.readlines()  
    for i in lists:  
        cpFile(string.strip(i))  
          
    f.close()  

附录：
Python中对文件、文件夹（文件操作函数）的操作需要涉及到os模块和shutil模块。

得到当前工作目录，即当前Python脚本工作的目录路径: os.getcwd()

返回指定目录下的所有文件和目录名:os.listdir()

函数用来删除一个文件:os.remove()

删除多个目录：os.removedirs（r“c：\python”）

检验给出的路径是否是一个文件：os.path.isfile()

检验给出的路径是否是一个目录：os.path.isdir()

判断是否是绝对路径：os.path.isabs()

检验给出的路径是否真地存:os.path.exists()

返回一个路径的目录名和文件名:os.path.split()     eg os.path.split('/home/swaroop/byte/code/poem.txt') 结果：('/home/swaroop/byte/code', 'poem.txt') 
分离扩展名：os.path.splitext()

获取路径名：os.path.dirname()

获取文件名：os.path.basename()

运行shell命令: os.system()

读取和设置环境变量:os.getenv() 与os.putenv()

给出当前平台使用的行终止符:os.linesep    Windows使用'\r\n'，Linux使用'\n'而Mac使用'\r'

指示你正在使用的平台：os.name       对于Windows，它是'nt'，而对于Linux/Unix用户，它是'posix'

重命名：os.rename（old， new）

创建多级目录：os.makedirs（r“c：\python\test”）

创建单个目录：os.mkdir（“test”）

获取文件属性：os.stat（file）

修改文件权限与时间戳：os.chmod（file）

终止当前进程：os.exit（）

获取文件大小：os.path.getsize（filename）


"""
# print(os.path.join('./'+'test'))
# print(os.listdir('.'))

