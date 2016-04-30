var http = require('http')
// npm install express
// var express = require('express');
/*Node.js REPL(交互式解释器)
Node.js REPL(Read Eval Print Loop:交互式解释器) 表示一个电脑的环境，类似 Window 系统的终端或 Unix/Linux shell，我们可以在终端中输入命令，并接收系统的响应。
Node 自带了交互式解释器，可以执行以下任务：
读取 - 读取用户输入，解析输入了Javascript 数据结构并存储在内存中。
执行 - 执行输入的数据结构
打印 - 输出结果
循环 - 循环操作以上步骤直到用户两次按下 ctrl-c 按钮退出。
Node 的交互式解释器可以很好的调试 Javascript 代码。
开始学习 REPL
我们可以输入以下命令来启动 Node 的终端：
在终端输入:node


REPL 命令
ctrl + c - 退出当前终端。
ctrl + c 按下两次 - 退出 Node REPL。
ctrl + d - 退出 Node REPL.
向上/向下 键 - 查看输入的历史命令
tab 键 - 列出当前命令
.help - 列出使用命令
.break - 退出多行表达式
.clear - 退出多行表达式
.save filename - 保存当前的 Node REPL 会话到指定文件
.load filename - 载入当前 Node REPL 会话的文件内容。


*/

// http get 请求
/*
http.createServer(function (request, response) {
	response.writeHead(200,{'Content-Type':'text/plain'});
	response.end('Hello World!\n');
}).listen(8888);
console.log("Server running at http://127.0.0.1:8888")
*/


// 阻塞代码示例
/*
var fs = require("fs");

var data = fs.readFileSync('nodetest.txt');

console.log(data.toString());
console.log("程序执行结束!");
*/


// 非阻塞代码示例
/*
var fs = require("fs");

fs.readFile('nodetest.txt', function (err, data) {
    if (err) return console.error(err);
    console.log(data.toString());
});

console.log("程序执行结束!");
*/


/*

// 引入 events 模块
var events = require('events');
// 创建 eventEmitter 对象
var eventEmitter = new events.EventEmitter();

// 创建事件处理程序
var connectHandler = function connected() {
   console.log('连接成功。');
  
   // 触发 data_received 事件 
   eventEmitter.emit('data_received');
}

// 绑定 connection 事件处理程序
eventEmitter.on('connection', connectHandler);
 
// 使用匿名函数绑定 data_received 事件
eventEmitter.on('data_received', function(){
   console.log('数据接收成功。');
});

// 触发 connection 事件 
eventEmitter.emit('connection');

console.log("程序执行完毕。");

*/

// var EventEmitter = require('events').EventEmitter; 
// var event = new EventEmitter(); 
// event.on('some_event', function() { 
// 	console.log('some_event 事件触发'); 
// }); 
// setTimeout(function() { 
// 	event.emit('some_event'); 
// }, 1000); 


/*
buf = new Buffer(256);
len = buf.write("www.runoob.com");

console.log("写入字节数 : "+  len);

buf = new Buffer(26);
for (var i = 0 ; i < 26 ; i++) {
  buf[i] = i + 97;
}

console.log( buf.toString('ascii'));       // 输出: abcdefghijklmnopqrstuvwxyz
console.log( buf.toString('ascii',0,5));   // 输出: abcde
console.log( buf.toString('utf8',0,5));    // 输出: abcde
console.log( buf.toString(undefined,0,5)); // 使用 'utf8' 编码, 并输出: abcde
*/

/*
var buf = new Buffer('www.runoob.com');
var json = buf.toJSON(buf);

console.log(json);

*/

/*

function say(word) {
  console.log(word);
}

function execute(someFunction, value) {
  someFunction(value);
}

execute(say, "Hello");

*/

// var http = require("http");
/*
http.createServer(function(request, response) {
  response.writeHead(200, {"Content-Type": "text/plain"});
  response.write("Hello World");
  response.end();
}).listen(8888);
*/
/*

var http = require("http");
var url = require("url");

function start() {
  function onRequest(request, response) {
    var pathname = url.parse(request.url).pathname;
    console.log("Request for " + pathname + " received.");
    response.writeHead(200, {"Content-Type": "text/plain"});
    response.write("Hello World");
    response.end();
  }

  http.createServer(onRequest).listen(8888);
  console.log("Server has started.");
}

exports.start = start;

*/


// var http = require('http');

var url = require('url');
var util = require('util');

http.createServer(function(req, res){
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end(util.inspect(url.parse(req.url, true)));
}).listen(3000);

/*

var querystring = require('querystring');
var util = require('util');

http.createServer(function(req, res){
    var post = '';     //定义了一个post变量，用于暂存请求体的信息

    req.on('data', function(chunk){    //通过req的data事件监听函数，每当接受到请求体的数据，就累加到post变量中
        post += chunk;
    });

    req.on('end', function(){    //在end事件触发后，通过querystring.parse将post解析为真正的POST请求格式，然后向客户端返回。
        post = querystring.parse(post);
        res.end(util.inspect(post));
    });
}).listen(3000);
*/



