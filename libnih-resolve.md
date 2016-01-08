##编译libnih
下载libnih代码包：

配置：
```
# ./configure CC=gcc
```
使用make命令进行编译，出错。
```
configure: error: Package requirements (dbus-1 >= 1.2.16) were not met:
No package 'dbus-1' found

# yum install dbus-devel.x86_64 -y
```

```
configure: error: expat library not found

# yum install expat-devel.x86_64 -y
```

configure通过，编译libnih通过。

##编译bcache-tools
```
bcacheadm.c:23:19: fatal error: blkid.h: No such file or directory
 #include <blkid.h>

# yum install libblkid-devel.x86_64 libblkid-devel.i686 -y
```

修改bcacheadm.c文件
```
#include <blkid.h>

#include <blkid/blkid.h>
```
