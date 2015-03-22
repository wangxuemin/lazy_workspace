/* prog server */
#include <stdio.h>
#include <unistd.h>
#include <wait.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <ctime>
#include <arpa/inet.h>
#include <fcntl.h>

using namespace std;

#define MAXN_STR 40

/* server的端口号 */
int SERVER_PORT;

/* 随即生成端口号 */
int readport()
{
    srand(unsigned(time(NULL)));
    SERVER_PORT = 30000+rand()%10000;
    FILE* fout = fopen("port.in","w");
    fprintf(fout,"%d\n",SERVER_PORT);
    fclose(fout);
    return 0;
}

int main()
{
    int serverfd,connectionfd;
    int lenclient,lenserver;
    int cnt = 0;
    /* 定义服务器端和客户端的套接字 */
    struct sockaddr_in serveraddr;
    struct sockaddr_in clientaddr;
    char buff[MAXN_STR+1];

    /* server每次随机生成端口号，并且写入port.in文件供client读取 */
    readport();

    /* 创建一个套接字 & 初始化 */
    serverfd = socket(AF_INET, SOCK_STREAM, 0);
    memset(&serveraddr,0,sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
    serveraddr.sin_port = htons(SERVER_PORT);
    lenclient = sizeof(clientaddr);
    lenserver = sizeof(serveraddr);

    /* 对套接字进行本地命名 */
    bind(serverfd, (sockaddr*)&serveraddr, sizeof(serveraddr));
    //printf("Socket has been created!\n");
    printf("Server port : %d\n",SERVER_PORT);
    /* 对套接字进行监听 */
    listen(serverfd,1);
    //fcntl(serverfd, F_SETFL, O_NONBLOCK);

    while(true)
    {
        //printf("===== %d =====\n",cnt++);
        printf("Now listening...\n");
        /* 接受客户端申请的连接 */
        connectionfd = accept(serverfd,(struct sockaddr*)&clientaddr,(socklen_t*)&lenclient);
sleep(50);
        /* 如果client成功连接到server, 则执行 */
        if(connectionfd >= 0)
        {
            //printf("Now the link has been connected.\n");
            /* 从客户端的套接字中提取出IP地址 和其他信息*/
            int clientip = clientaddr.sin_addr.s_addr;
            printf("Client ip : %d.%d.%d.%d\n",clientip&255,(clientip>>8)&255,
                    (clientip>>16)&255,(clientip>>24)&255);
            printf("Client prot : %d\n",ntohs(clientaddr.sin_port));

            /* 使用send向client发送信息 */
            sprintf(buff,"THE SEND MSG");
            //printf("[SEND] Starting sending [send] msg ...\n");
            send(connectionfd, (void*)buff, strlen(buff),0);
            recv(connectionfd, (void*)buff, MAXN_STR, 0 );
            if(strlen(buff) > 0)
                printf("[SUCC] Sending succeed.\n");
            else
                printf("[FAIL] Sending failed.\n");
            /* 使用write向client发送消息 */
            sprintf(buff,"THE WRITE MSG");
            //printf("[SEND] starting sending [write] msg ...\n");
            write(connectionfd,buff, strlen(buff));
            recv(connectionfd, (void*)buff, MAXN_STR, 0 );
            if(strlen(buff) > 0)
                printf("[SUCC] Sending succeed.\n");
            else
                printf("[FAIL] Sending failed.\n");
            /* 关闭此连接 */
            close(connectionfd);
            printf("Disconnect the link.\n");
            /* 使用sendto向client发送消息(非连接) */
            /*
               sprintf(buff, "THE SENDTO MSG");
               printf("[SEND] Starting sending [sendto] msg ...\n");
             */
            /*
               sendto(serverfd, (void*)buff, strlen(buff), 0,
               (struct sockaddr*)&clientaddr, sizeof(clientaddr));
             */
        }
        else
        {
            /*  与client连接失败 */
            printf("ERROR: Failed while establish the link!\n");
        }
    }
    close(serverfd);
    return 0;
}
