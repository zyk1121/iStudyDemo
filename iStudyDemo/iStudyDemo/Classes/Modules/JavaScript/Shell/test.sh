#!/bin/bash

#http://www.runoob.com/linux/linux-shell-basic-operators.html

#chmod +x ./test.sh  #使脚本具有执行权限
#./test.sh  #执行脚本
#sh test.sh


echo "Hello World"

#变量
your_name="qinjx"
echo $your_name
echo ${your_name}
your_name="hello name"
echo $your_name
#中文
your_name="中文"
echo $your_name

for file in ada coffe action java; do
    echo $file
done

#只读变量
myURL="http://www.baidu.com"
readonly myURL
#myURL="dddd"

#删除变量
unset myURL
echo $myURL #没有任何输出

#字符串
#字符串是shell编程中最常用最有用的数据类型（除了数字和字符串，也没啥其它类型好用了），字符串可以用单引号，也可以用双引号，也可以不用引号。单双引号的区别跟PHP类似。
str='this is a string'
echo $str
str="Hello, I know your are \"$your_name\"! \n"
echo $str
#拼接字符串
greeting="hello, "$your_name" !"
greeting_1="hello, ${your_name} !"
echo $greeting $greeting_1

#获取字符串的长度
str="abcd"
echo ${#str}
#提取子字符串
str="runoob is a great site"
#从第2个位置开始的4个字符
echo ${str:1:4}
#Shell  数组，在Shell中，用括号来表示数组，数组元素用"空格"符号分割开。
#1
array_name=(value0 value1 value2)
#2
array_name=(
value0
value1
value2
)
#3
array_name[0]=value0
array_name[1]=value1
array_name[2]=value2
#读取数组：${数组名[下标]}
echo ${array_name[0]}
#数组中的所有元素
echo ${array_name[@]}
#获得数组中的长度
length=${#array_name[@]}
echo $length
length=${#array_name[*]}
echo $length
lengthn=${#array_name[0]}
echo $lengthn

#Shell 传递参数
echo "Shell 传递参数实例！";
echo "执行的文件名：$0";
echo "第一个参数为：$1";
echo "第二个参数为：$2";
echo "第三个参数为：$3";
echo "参数个数为：$#"
#$* 和$@
echo "-- \$* 演示 ---"
for i in "$*"; do
echo $i
done

echo "-- \$@ 演示 ---"
for i in "$@"; do
echo $i
done
#Shell 基本运算符
#原生bash不支持简单的数学运算，但是可以通过其他命令来实现，例如 awk 和 expr，expr 最常用。
#expr 是一款表达式计算工具，使用它能完成表达式的求值操作。
#例如，两个数相加(注意使用的是反引号 ` 而不是单引号 ')：
val=`expr   2 + 2    `
val=`expr 2 + 2`#注意+前后有空格
echo "两个数的和：$val"
a=10
b=20
val=`expr $a + $b`
echo "a + b : $val"
val=`expr $a - $b`
val=`expr $a \* $b`
echo "a * b : $val"
val=`expr $a / $b`
val=`expr $a % $b`

#注意空格
if [ $a == $b ]
then
    echo "a 等于 b"
fi
if [ $a != $b ]
then
    echo "a 不等于 b"
fi


#if then fi
#if then else fi

#运算符	说明	举例
#-eq	检测两个数是否相等，相等返回 true。	[ $a -eq $b ] 返回 false。
#-ne	检测两个数是否相等，不相等返回 true。	[ $a -ne $b ] 返回 true。
#-gt	检测左边的数是否大于右边的，如果是，则返回 true。	[ $a -gt $b ] 返回 false。
#-lt	检测左边的数是否小于右边的，如果是，则返回 true。	[ $a -lt $b ] 返回 true。
#-ge	检测左边的数是否大等于右边的，如果是，则返回 true。	[ $a -ge $b ] 返回 false。
#-le	检测左边的数是否小于等于右边的，如果是，则返回 true。	[ $a -le $b ] 返回 true。

if [ $a -gt $b ]
then
echo "$a -gt $b: a 大于 b"
else
echo "$a -gt $b: a 不大于 b"
fi
#字符串运算符
a="abc"
b="efg"

if [ $a = $b ]
then
echo "$a = $b : a 等于 b"
else
echo "$a = $b: a 不等于 b"
fi
if [ $a != $b ]
then
echo "$a != $b : a 不等于 b"
else
echo "$a != $b: a 等于 b"
fi
if [ -z $a ]
then
echo "-z $a : 字符串长度为 0"
else
echo "-z $a : 字符串长度不为 0"
fi
if [ -n $a ]
then
echo "-n $a : 字符串长度不为 0"
else
echo "-n $a : 字符串长度为 0"
fi
if [ $a ]
then
echo "$a : 字符串不为空"
else
echo "$a : 字符串为空"
fi

file="/Users/zhangyuanke/Desktop/Projects/Sh/test.sh"
if [ -r $file ]
then
echo "文件可读"
else
echo "文件不可读"
fi
if [ -w $file ]
then
echo "文件可写"
else
echo "文件不可写"
fi
if [ -x $file ]
then
echo "文件可执行"
else
echo "文件不可执行"
fi
if [ -f $file ]
then
echo "文件为普通文件"
else
echo "文件为特殊文件"
fi
if [ -d $file ]
then
echo "文件是个目录"
else
echo "文件不是个目录"
fi
if [ -s $file ]
then
echo "文件不为空"
else
echo "文件为空"
fi
if [ -e $file ]
then
echo "文件存在"
else
echo "文件不存在"
fi

#echo 显示转义字符
echo "\"It is a test\""
echo `date`

#printf
printf "Hello, Shell\n"

printf "%-10s %-8s %-4s\n" 姓名 性别 体重kg
printf "%-10s %-8s %-4.2f\n" 郭靖 男 66.1234
printf "%-10s %-8s %-4.2f\n" 杨过 男 48.6543
printf "%-10s %-8s %-4.2f\n" 郭芙 女 47.9876
#Shell test命令
#Shell中的 test 命令用于检查某个条件是否成立，它可以进行数值、字符和文件三个方面的测试。

#参数	说明
#-eq	等于则为真
#-ne	不等于则为真
#-gt	大于则为真
#-ge	大于等于则为真
#-lt	小于则为真
#-le	小于等于则为真

a=10
b=20
if [ $a == $b ]
then
echo "a 等于 b"
elif [ $a -gt $b ]
then
echo "a 大于 b"
elif [ $a -lt $b ]
then
echo "a 小于 b"
else
echo "没有符合的条件"
fi
#if [ $(ps -ef | grep -c "ssh") -gt 1 ]; then echo "true"; fi
for loop in 1 2 3 4 5
do
echo "The value is: $loop"
done

int=1
while(( $int<=5 ))
do
echo $int
let "int++"
done

#while true
#do
#command
#done

#Shell函数
demoFunc(){
    echo "这是第一个shell函数"
}
demoFunc


funWithReturn(){
echo "这个函数会对输入的两个数字进行相加运算..."
echo "输入第一个数字: "
read aNum
echo "输入第二个数字: "
read anotherNum
echo "两个数字分别为 $aNum 和 $anotherNum !"
return $(($aNum+$anotherNum))
}
#funWithReturn
echo "输入的两个数字之和为 $? !"


funWithParam(){
echo "第一个参数为 $1 !"
echo "第二个参数为 $2 !"
echo "第十个参数为 $10 !"
echo "第十个参数为 ${10} !"
echo "第十一个参数为 ${11} !"
echo "参数总数有 $# 个!"
echo "作为一个字符串输出所有参数 $* !"
}
funWithParam 1 2 3 4 5 6 7 8 9 34 73




#Shell 文件包含
#使用 . 号来引用test1.sh 文件
. ./test1.sh
# 或者使用以下包含文件代码
# source ./test1.sh
echo "url地址是:$urlTest"

echo `ls`
echo `pwd`

#files=(echo `ls`)
#for file in files; do
#echo $file
#done

#提取文件名
var=/a/b/c/dir/123.txt
echo $(basename $var)
#提取目录名
echo $(dirname $var)


#获取某一个路径下的所有文件名
path=/Users/zhangyuanke/Desktop/Projects
cd $path
for filename in `ls`
do
echo $filename
done

#当前已经不在原来的目录了
echo `pwd`

#bash 获取文件名和扩展名的例子
# 在bash中可以这么写
fullfile=/a/b/c/dir/123.txt
fullname=$(basename "$fullfile")
extension="${fullname##*.}"
filename="${fullname%.*}"
echo $fullname
echo $extension
echo $filename


