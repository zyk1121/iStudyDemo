#!/usr/bin/python
# -*- coding: utf-8 -*-

import math
import os
import os.path

print("hello world!")

a = 100
if a > 0:
	print(a)
else:
	print(-a)

print(True and True)
print(True or False)
print(False and False)
print (True and False)
print("not False:" + str(not False))

print('包含中文的str')
#对于单个字符的编码，Python提供了ord()函数获取字符的整数表示，chr()函数把编码转换为对应的字符：
print(ord('A'))
# print(ord('中'))
print(chr(66))
# print(chr(25991))

print(len('strlen'))
#list
classmates = ['Michael', 'Bob', 'Tracy']
print(classmates)
print(classmates[0])
print(classmates[2])
print(classmates[-1])#最后一个元素
print(classmates[-2])#倒数第二个元素
classmates.append('addd')
print(classmates[-1])
classmates.pop()
print(classmates[-1])
classmates[0]='hello world';
print(classmates[0])
print(len(classmates))

#tuple
t = ('a','b',['A','B'])
print(t)
print(t[1])
print(t[2][1])

L = [
    ['Apple', 'Google', 'Microsoft'],
    ['Java', 'Python', 'Ruby', 'PHP'],
    ['Adam', 'Bart', 'Lisa']
]
print(L[0][0])


age = 3
if age > 18:
	print('your age is',age)
	print('adult')
else:
	print('your age is',age)
	print('tennager')
# 	if <条件判断1>:
#     <执行1>
# elif <条件判断2>:
#     <执行2>
# elif <条件判断3>:
#     <执行3>
# else:
#     <执行4>

for name in classmates:
	print(name)
	print('hello')


#空行的作用相当于分割代码块
sum = 0
for x in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]:
    sum = sum + x
print(sum)

#ython内置了字典：dict的支持，dict全称dictionary，在其他语言中也称为map，使用键-值（key-value）存储，具有极快的查找速度。

d = {'Michael':95,'Bob':75,'Tracy':85}
print(d['Michael'])
d['Tracy']=100
print(d['Tracy'])

d['keykey'] = 100

print(len(d))

#set 
s = set([1, 1, 2, 2, 3, 3])
print(s)
s.add(4)
print(s)
s.remove(3)
print(s)

"""
定义函数

阅读: 134624
在Python中，定义一个函数要使用def语句，依次写出函数名、括号、括号中的参数和冒号:，然后，在缩进块中编写函数体，函数的返回值用return语句返回。

我们以自定义一个求绝对值的my_abs函数为例
"""

'''
这是多行注释，使用单引号。
这是多行注释，使用单引号。
这是多行注释，使用单引号。
'''

"""
这是多行注释，使用双引号。
这是多行注释，使用双引号。
这是多行注释，使用双引号。
"""

def my_abs(x):
	# pass//pass语句什么都不做，那有什么用？实际上pass可以用来作为占位符，比如现在还没想好怎么写函数的代码，就可以先放一个pass，让代码能运行起来。
	if x >= 0:
		return x;
	else:
		return -x;

print(my_abs(10000))
print(my_abs(-10000))

def my_test(x,y):
	return (x,y)

print(my_test(10,20))


print(math.sqrt(2))


def calc(numbers):
    sum = 0
    for n in numbers:
        sum = sum + n * n
    return sum

x = calc([1,2,3,4])
print(x)


L = []
n = 1
while n <= 99:
    L.append(n)
    n = n + 2

print(L)
print(L[0:5])
print(L[1:2])# 一个元素
print(L[-10:])

# 高阶函数
def add(x, y, f):
    return f(x) + f(y)

print(add(10,-40,my_abs))


# 类 class
class Student(object):

    def __init__(self, name, score):
        self.name = name
        self.score = score

    def print_score(self):
        print('%s: %s' % (self.name, self.score))

s = Student('xuesheng',98)

s.print_score()


# 类内部访问 private

class Student2(object):

    def __init__(self, name, score):
        self.__name = name
        self.__score = score

    def print_score(self):
        print('%s: %s' % (self.__name, self.__score))

    def get_name(self):
        return self.__name

    def get_score(self):
        return self.__score

#继承
class Animal(object):
    def run(self):
        print('Animal is running...')


class Dog(Animal):

    def run(self):
        print('Dog is running...')

class Cat(Animal):

    def run(self):
        print('Cat is running...')


dog = Dog()
dog.run()

cat = Cat()
cat.run()



#操作文件和目录
print( os.path.abspath('.'))
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
"""
print(os.path.join('./'+'test'))
print(os.listdir('.'))

