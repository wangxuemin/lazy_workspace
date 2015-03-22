#include <sys/socket.h>
#include <arpa/inet.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <stdlib.h>
#include <wait.h>

#define MAXN_STR 360

/* server端口号 */
int SERVER_PORT;
int CLIENT_PORT;

/* 读取server端口 并且 随即打开client端口 */
int readport()
{
    srand(unsigned(time(NULL)));
    FILE* fout = fopen("port.in","r");
    fscanf(fout,"%d",&SERVER_PORT);
    fclose(fout);
    CLIENT_PORT = 40000 + rand()%10000;
    return 0;
}
int main()
{
    char buff[MAXN_STR];
    char succ[] = "succ";
    char fld[] = "fail";

    /* client的套接字 */
    int clientfd;
    /* server的套接字地址 */
    struct sockaddr_in serveraddr;
    struct sockaddr_in clientaddr;

    /* 读取server端口号 */
    readport();
    /* 创建client的套接字并且初始化server和client的套接字地址 */
    clientfd = socket(AF_INET, SOCK_STREAM, 0);
    memset(&serveraddr,0,sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    serveraddr.sin_port = htons(SERVER_PORT);
    serveraddr.sin_addr.s_addr = inet_addr("127.0.0.1");
    clientaddr.sin_family = AF_INET;
    clientaddr.sin_port = htons(CLIENT_PORT);
    clientaddr.sin_addr.s_addr = inet_addr("127.0.0.1");

    /* 绑定client套接字 */
    bind(clientfd, (struct sockaddr*)&clientaddr, sizeof(clientaddr));
    //printf("Socket has been created.\n");
    printf("Client port : %d\n",CLIENT_PORT);
    /* 向server请求服务 */
    //printf("Now require scv from server ...\n");
    int chk = connect(clientfd, (struct sockaddr*)&serveraddr, sizeof(serveraddr));

    /* 判断是否连接请求成功 */
    if(chk < 0)
    {
        printf("ERROR: Could not connect to the host!\n");
        return 0;
    }
    else
    {
        /* 连接成功，并且输出server的信息 */
        printf("connection established.\n");
        int serverip = serveraddr.sin_addr.s_addr;
        printf("Server ip : %d.%d.%d.%d\n",serverip&255,(serverip>>8)&255,
                (serverip>>16)&255,(serverip>>24)&255);
        printf("Server port : %d\n",ntohs(serveraddr.sin_port));
    }
    /* 使用recv从server接受数据 */
    printf("Starting RECV msg ...\n");
    int len = recv(clientfd,(void*)buff,MAXN_STR,0);
    buff[len] = 0;
    if(len > 0)
    {
        /* 如果client接受数据成功，则向server发送成功信号 */
        printf("[RECV] %s\n",buff);
        printf("[SUCC] Recviving succeed.\n");
        send(clientfd,(void*)succ,strlen(succ),0);
    }
    else
    {
        /* 否则，向server发送失败信号 */
        printf("[FAIL] Recviving failed.\n");
        send(clientfd,(void*)fld,strlen(fld),0);
    }
    /* 使用read从server读取数据 */
    printf("Starting READ msg ...\n");
    len = read(clientfd,buff,MAXN_STR);
    buff[len] = 0;
    if(len > 0)
    {
        /* 如果client接受数据成功，则向server发送成功信号 */
        printf("[RECV] %s\n",buff);
        printf("[SUCC] Recviving succeed.\n");
        send(clientfd,(void*)succ,strlen(succ),0);
    }
    else
    {
        /* 否则，向server发送失败信号 */
        printf("[FAIL] Recviving failed.\n");
        send(clientfd,(void*)fld,strlen(fld),0);
    }
    /* 断开与server的连接 */
    close(clientfd);
    printf("Now the connection has been broken\n");
    /* 使用recvfrom从server接受数据（非链接） */
    /*
       int serverlen = sizeof(serveraddr);
       printf("Starting RECVFROM msg ...\n");
       len = recvfrom(clientfd, (void*)buff, MAXN_STR, 0,
       (struct sockaddr*)&serveraddr, (socklen_t*)&serverlen);
       buff[len] = 0;
       if(len > 0)
       {
    // 如果client接受数据成功，则向server发送成功信号 
    printf("[RECV] %s\n",buff);
    printf("[SUCC] Recviving succeed.\n");
    }
    else
    {
    // 否则，向server发送失败信号 
    printf("[FAIL] Recviving failed.\n");
    }
     */
    close(clientfd);
    return 0;
}
