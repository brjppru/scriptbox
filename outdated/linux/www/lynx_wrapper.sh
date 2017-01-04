#!/bin/zsh
#
# Mid layer wrapper for lynx.


/usr/local/bin/real/lynx -anonymous -restrictions=download,exec,exec_frozen,inside_ftp,inside_telnet,outside_ftp,shell,suspend,useragent -homepage="http://www.arbornet.org" -rlogin -useragent="Lynx/2.8.4rel.1 libwww-FM/2.14 $USER@arbornet.org" "$@"


