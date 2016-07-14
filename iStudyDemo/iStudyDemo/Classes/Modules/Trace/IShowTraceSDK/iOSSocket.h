https://github.com/robbiehanson/CocoaAsyncSocket
http://my.oschina.net/u/1378445/blog/340206

socket简介

首先让我们通过一张图知道socket在哪里？

Socket是应用层与TCP/IP协议族通信的中间软件抽象层，它是一组接口。

tcp和udp的区别

在这里就必须讲一下udp和tcp的区别了

TCP：面向连接、传输可靠(保证数据正确性,保证数据顺序)、用于传输大量数据(流模式)、速度慢，建立连接需要开销较多(时间，系统资源)。

UDP：面向非连接、传输不可靠、用于传输少量数据(数据包模式)、速度快。

关于TCP是一种流模式的协议，UDP是一种数据报模式的协议，这里要说明一下，TCP是面向连接的，也就是说，在连接持续的过程中，socket中收到的数据都是由同一台主机发出的（劫持什么的不考虑），因此，知道保证数据是有序的到达就行了，至于每次读取多少数据自己看着办。

而UDP是无连接的协议，也就是说，只要知道接收端的IP和端口，且网络是可达的，任何主机都可以向接收端发送数据。这时候，如果一次能读取超过一个报文的数据，则会乱套。比如，主机A向发送了报文P1，主机B发送了报文P2，如果能够读取超过一个报文的数据，那么就会将P1和P2的数据合并在了一起，这样的数据是没有意义的。

TCP三次握手和四次挥手

相对于SOCKET开发者，TCP创建过程和连接拆除过程是由TCP/IP协议栈自动创建的。因此开发者并不需要控制这个过程。但是对于理解TCP底层运作机制，相当有帮助。

因此在这里详细解释一下这两个过程。

TCP三次握手

所谓三次握手(Three-way Handshake)，是指建立一个TCP连接时，需要客户端和服务器总共发送3个包。

三次握手的目的是连接服务器指定端口，建立TCP连接,并同步连接双方的序列号和确认号并交换 TCP 窗口大小信息.在socket编程中，客户端执行connect()时。将触发三次握手。

首先了解一下几个标志，SYN（synchronous），同步标志，ACK (Acknowledgement），即确认标志，seq应该是Sequence Number，序列号的意思，另外还有四次握手的fin，应该是final，表示结束标志。
                                      
                                      第一次握手：客户端发送一个TCP的SYN标志位置1的包指明客户打算连接的服务器的端口，以及初始序号X,保存在包头的序列号(Sequence Number)字段里。
                                      
                                      第二次握手：服务器发回确认包(ACK)应答。即SYN标志位和ACK标志位均为1同时，将确认序号(Acknowledgement Number)设置为客户的序列号加1以，即X+1。
                                      
                                      第三次握手：客户端再次发送确认包(ACK) SYN标志位为0，ACK标志位为1。并且把服务器发来ACK的序号字段+1，放在确定字段中发送给对方.并且在数据段放写序列号的+1。
                                      
                                      tcp四次挥手
                                      
                                      TCP的连接的拆除需要发送四个包，因此称为四次挥手(four-way handshake)。客户端或服务器均可主动发起挥手动作，在socket
                                      
                                      编程中，任何一方执行close()操作即可产生挥手操作。
                                      
                                      其实有个问题，为什么连接的时候是三次握手，关闭的时候却是四次挥手？
                                      
                                      因为当Server端收到Client端的SYN连接请求报文后，可以直接发送SYN+ACK报文。其中ACK报文是用来应答的，SYN报文是用来同步的。但是关闭连接时，当Server端收到FIN报文时，很可能并不会立即关闭SOCKET，所以只能先回复一个ACK报文，告诉Client端，"你发的FIN报文我收到了"。只有等到我Server端所有的报文都发送完了，我才能发送FIN报文，因此不能一起发送。故需要四步握手。
                                      
                                      tcpsocket和udpsocket的具体实现
                                      
                                      讲了这么久，终于要开始讲socket的具体实现了，iOS提供了Socket网络编程的接口CFSocket，不过这里使用BSD Socket。
                                      
                                      tcp和udp的socket是有区别的，这里给出这两种的设计框架
                                      
                                      基本TCP客户—服务器程序设计基本框架
                                      
                                      
                                      
                                      基本UDP客户—服务器程序设计基本框架流程图
                                      
                                      
                                      
                                      常用的Socket类型有两种：流式Socket（SOCK_STREAM）和数据报式Socket（SOCK_DGRAM）。流式是一种面向连接的Socket，针对于面向连接的TCP服务应用；数据报式Socket是一种无连接的Socket，对应于无连接的UDP服务应用。
                                      
                                      1、socket调用库函数主要有：
                                      
                                      创建套接字
                                      
                                      Socket(af,type,protocol)
                                      建立地址和套接字的联系
                                      
                                      bind(sockid, local addr, addrlen)
                                      服务器端侦听客户端的请求
                                      
                                      listen( Sockid ,quenlen)
                                      建立服务器/客户端的连接 (面向连接TCP）
                                                    
                                                    客户端请求连接
                                                    
                                                    Connect(sockid, destaddr, addrlen)
                                                    服务器端等待从编号为Sockid的Socket上接收客户连接请求
                                                    
                                                    newsockid=accept(Sockid，Clientaddr, paddrlen)
                                                    发送/接收数据
                                                    
                                                    面向连接：
                                                    
                                                    send(sockid, buff, bufflen)
                                                    recv( )
                                                    面向无连接：
                                                    
                                                    sendto(sockid,buff,…,addrlen)
                                                    recvfrom( )
                                                    释放套接字
                                                    
                                                    close(sockid)
                                                    tcpsocket的具体实现
                                                    
                                                    服务器的工作流程：首先调用socket函数创建一个Socket，然后调用bind函数将其与本机地址以及一个本地端口号绑定，然后调用listen在相应的socket上监听，当accpet接收到一个连接服务请求时，将生成一个新的socket。服务器显示该客户机的IP地址，并通过新的socket向客户端发送字符串" hi,I am server!"。最后关闭该socket。
                                                    
#import <Foundation/Foundation.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
                                                    int main(int argc, const char * argv[])
{
    @autoreleasepool {
        //        1
        int err;
        int fd=socket(AF_INET, SOCK_STREAM  , 0);
        BOOL success=(fd!=-1);
        //        1
        //   2
        if (success) {
            NSLog(@"socket success");
            struct sockaddr_in addr;
            memset(&addr, 0, sizeof(addr));
            addr.sin_len=sizeof(addr);
            addr.sin_family=AF_INET;
            //            =======================================================================
            addr.sin_port=htons(1024);
            //        ============================================================================
            addr.sin_addr.s_addr=INADDR_ANY;
            err=bind(fd, (const struct sockaddr *)&addr, sizeof(addr));
            success=(err==0);
        }
        //   2
        //        ============================================================================
        if (success) {
            NSLog(@"bind(绑定) success");
            err=listen(fd, 5);//开始监听
            success=(err==0);
        }
        //    ============================================================================
        //3
        if (success) {
            NSLog(@"listen success");
            while (true) {
                struct sockaddr_in peeraddr;
                int peerfd;
                socklen_t addrLen;
                addrLen=sizeof(peeraddr);
                NSLog(@"prepare accept");
                peerfd=accept(fd, (struct sockaddr *)&peeraddr, &addrLen);
                success=(peerfd!=-1);
                //    ============================================================================
                if (success) {
                    NSLog(@"accept success,remote address:%s,port:%d",inet_ntoa(peeraddr.sin_addr),ntohs(peeraddr.sin_port));
                    char buf[1024];
                    ssize_t count;
                    size_t len=sizeof(buf);
                    do {
                        count=recv(peerfd, buf, len, 0);
                        NSString* str = [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
                        NSLog(@"%@",str);
                    } while (strcmp(buf, "exit")!=0);
                }
                //    ============================================================================
                close(peerfd);
            }
        }
        //3
    }
    return 0;
}
                                                    客户端的工作流程：首先调用socket函数创建一个Socket，然后调用bind函数将其与本机地址以及一个本地端口号绑定，请求连接服务器，通过新的socket向客户端发送字符串" hi,I am client!"。最后关闭该socket。
                                                    
                                                    //
                                                    //  main.m
                                                    //  kewai_SocketClient
                                                    //
#import <Foundation/Foundation.h>
#include <sys/socket.h>
#include <netinet/in.h>
#import <arpa/inet.h>
                                                    int main(int argc, const char * argv[])
{
    @autoreleasepool {
        //        1
        int err;
        int fd=socket(AF_INET, SOCK_STREAM, 0);
        BOOL success=(fd!=-1);
        struct sockaddr_in addr;
        //        1
        //   2
        if (success) {
            NSLog(@"socket success");
            memset(&addr, 0, sizeof(addr));
            addr.sin_len=sizeof(addr);
            addr.sin_family=AF_INET;
            addr.sin_addr.s_addr=INADDR_ANY;
            err=bind(fd, (const struct sockaddr *)&addr, sizeof(addr));
            success=(err==0);
        }
        //   2
        //3
        if (success) {
            //============================================================================
            struct sockaddr_in peeraddr;
            memset(&peeraddr, 0, sizeof(peeraddr));
            peeraddr.sin_len=sizeof(peeraddr);
            peeraddr.sin_family=AF_INET;
            peeraddr.sin_port=htons(1024);
            //            peeraddr.sin_addr.s_addr=INADDR_ANY;
            peeraddr.sin_addr.s_addr=inet_addr("172.16.10.120");
            //            这个地址是服务器的地址，
            socklen_t addrLen;
            addrLen =sizeof(peeraddr);
            NSLog(@"connecting");
            err=connect(fd, (struct sockaddr *)&peeraddr, addrLen);
            success=(err==0);
            if (success) {
                //                struct sockaddr_in addr;
                err =getsockname(fd, (struct sockaddr *)&addr, &addrLen);
                success=(err==0);
                //============================================================================
                //============================================================================
                if (success) {
                    NSLog(@"connect success,local address:%s,port:%d",inet_ntoa(addr.sin_addr),ntohs(addr.sin_port));
                    char buf[1024];
                    do {
                        printf("input message:");
                        scanf("%s",buf);
                        send(fd, buf, 1024, 0);
                    } while (strcmp(buf, "exit")!=0);
                }
            }
            else{
                NSLog(@"connect failed");
            }
        }
        //    ============================================================================
        //3
    }
    return 0;
}
                                                    udpsocket的具体实现
                                                    
                                                    下面是udpsocket的具体实现
                                                    
                                                    服务器的工作流程：首先调用socket函数创建一个Socket，然后调用bind函数将其与本机地址以及一个本地端口号绑定，接收到一个客户端时，服务器显示该客户端的IP地址，并将字串返回给客户端。 
                                                    
/*
 *UDP/IP应用编程接口（API）
 *服务器的工作流程：首先调用socket函数创建一个Socket，然后调用bind函数将其与本机
 *地址以及一个本地端口号绑定，接收到一个客户端时，服务器显示该客户端的IP地址，并将字串
 *返回给客户端。
 */
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<errno.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#import <arpa/inet.h>
                                                    int main(int argc,char **argv)
{
    int ser_sockfd;
    int len;
    //int addrlen;
    socklen_t addrlen;
    char seraddr[100];
    struct sockaddr_in ser_addr;
    /*建立socket*/
    ser_sockfd=socket(AF_INET,SOCK_DGRAM,0);
    if(ser_sockfd<0)
    { 
        printf("I cannot socket success\n");
        return 1;
    }
    /*填写sockaddr_in 结构*/
    addrlen=sizeof(struct sockaddr_in);
    bzero(&ser_addr,addrlen);
    ser_addr.sin_family=AF_INET;
    ser_addr.sin_addr.s_addr=htonl(INADDR_ANY);
    ser_addr.sin_port=htons(1024);
    /*绑定客户端*/
    if(bind(ser_sockfd,(struct sockaddr *)&ser_addr,addrlen)<0)
    {
        printf("connect");
        return 1;
    }
    while(1)
    {
        bzero(seraddr,sizeof(seraddr));
        len=recvfrom(ser_sockfd,seraddr,sizeof(seraddr),0,(struct sockaddr*)&ser_addr,&addrlen);
        /*显示client端的网络地址*/
        printf("receive from %s\n",inet_ntoa(ser_addr.sin_addr));
        /*显示客户端发来的字串*/ 
        printf("recevce:%s",seraddr);
        /*将字串返回给client端*/
        sendto(ser_sockfd,seraddr,len,0,(struct sockaddr*)&ser_addr,addrlen);
    }
}
                                                    客户端的工作流程：首先调用socket函数创建一个Socket，填写服务器地址及端口号，从标准输入设备中取得字符串，将字符串传送给服务器端，并接收服务器端返回的字符串。最后关闭该socket。
                                                    
/*
 *UDP/IP应用编程接口（API）
 *客户端的工作流程：首先调用socket函数创建一个Socket，填写服务器地址及端口号，
 *从标准输入设备中取得字符串，将字符串传送给服务器端，并接收服务器端返回的字
 *符串。最后关闭该socket。
 */
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<errno.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include <netinet/in.h>
#import <arpa/inet.h>
                                                    int GetServerAddr(char * addrname)
{
    printf("please input server addr:");
    scanf("%s",addrname);
    return 1; 
}
                                                    int main(int argc,char **argv)
{
    int cli_sockfd;
    int len;
    socklen_t addrlen;
    char seraddr[14];
    struct sockaddr_in cli_addr;
    char buffer[256];
    GetServerAddr(seraddr);
    /* 建立socket*/
    cli_sockfd=socket(AF_INET,SOCK_DGRAM,0);
    if(cli_sockfd<0)   
    {  
        printf("I cannot socket success\n"); 
        return 1; 
    }
    /* 填写sockaddr_in*/
    addrlen=sizeof(struct sockaddr_in);
    bzero(&cli_addr,addrlen);
    cli_addr.sin_family=AF_INET;
    cli_addr.sin_addr.s_addr=inet_addr(seraddr);
    //cli_addr.sin_addr.s_addr=htonl(INADDR_ANY);
    cli_addr.sin_port=htons(1024);
    bzero(buffer,sizeof(buffer));
    /* 从标准输入设备取得字符串*/
    len=read(STDIN_FILENO,buffer,sizeof(buffer));
    /* 将字符串传送给server端*/
    sendto(cli_sockfd,buffer,len,0,(struct sockaddr*)&cli_addr,addrlen);
    /* 接收server端返回的字符串*/
    len=recvfrom(cli_sockfd,buffer,sizeof(buffer),0,(struct sockaddr*)&cli_addr,&addrlen);
    //printf("receive from %s\n",inet_ntoa(cli_addr.sin_addr));
    printf("receive: %s",buffer);
    close(cli_sockfd); 
}
                                                    
                                                    
                                                    
                                                    最后，整篇文章只能用一句话形容，懒婆娘的裹脚布，又长又臭，不过本文的作用是让我们了解socket的一些原理以及底层基本的结构，其实iOS的socket实现是特别简单的，我一直都在用github的开源类库cocoaasyncsocket，地址是https://github.com/robbiehanson/CocoaAsyncSocket，cocoaasyncsocket是支持tcp和udp的，具体操作方法就不介绍了。