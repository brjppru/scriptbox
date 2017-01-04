//
// http://brj.pp.ru/, Roman Y. Bogdanov port knocker for noxp[ucl]
//

#include <winsock2.h>
#include <stdio.h>

int main(int argc, char * argv[])
{
   if (argc < 4)
   {
      puts("usage: knock <src_ip> <dest_ip> <dest_port1> {dest_port2} ...");
      return 1;
   }

   WSADATA wsadata;
   WSAStartup(0x0202, &wsadata);

   SOCKADDR_IN laddr;
   laddr.sin_family = AF_INET;
   if (strcmp(argv[1], "0.0.0.0") == 0) laddr.sin_addr.s_addr = INADDR_ANY;
   else laddr.sin_addr.s_addr = inet_addr(argv[1]);
   laddr.sin_port = htons(0);

   SOCKADDR_IN raddr;
   raddr.sin_family = AF_INET;
   raddr.sin_addr.s_addr = inet_addr(argv[2]);

   int i;
   for (i = 3; i < argc; i++)
   {
      SOCKET sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

      unsigned long argp = 1;
      ioctlsocket(sock, FIONBIO, &argp);

      bind(sock, (SOCKADDR *) &laddr, sizeof laddr);

      raddr.sin_port = htons((unsigned short) atoi(argv[i]));

      connect(sock, (SOCKADDR *) &raddr, sizeof raddr);

      Sleep(100);
   }

   WSACleanup();

   return 0;
}
