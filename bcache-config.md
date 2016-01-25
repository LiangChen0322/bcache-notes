#bcache Notes
官方文档：

##1. 配置bcache
###系统环境要求
bcache是在3.10以后的版本加入mainline的，因此需要3.10以上的内核版本，但是在3.10.0的内核上进行配置时，发现无法生成相应的配置文件节点，测试过程中使用4.30。

###安装bcache-tools
####代码安装：
配置bcache需要使用bcache-tools工具，代码可以从github或官方网站上获取，但是master的代码版本非常老，dev branch的代码比较新但却是面向Ubuntu开发的，很多依赖库也是面向Ubuntu开发的，在Centos上编译非常麻烦。
```
git clone https://github.com/g2p/bcache-tools.git

```
也可以从官方网站上获取：

编译bcache-tools:
```
# cd bcache-tools/
# make & make install
```

####1.3 编译和安装过程中问题记录。
问题 1：
blkid.h: No such file
解决方法：
```
yum install libblkid-devel
```
问题 2：
Package blkid was not found in the pkg-config search path.
解决方法：
```
yum install pkg-config
```
**问题3：**
No package 'libnih' found

http://dl.fedoraproject.org/pub/fedora/linux/development/rawhide/source/SRPMS/l/libnih-1.0.2-12.fc23.src.rpm
```
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/

/usr/bin/ld: cannot find -luuid
/usr/bin/ld: cannot find -lblkid
/usr/bin/ld: cannot find -lc
yum install -y uuid-devel.x86_64

ln -sv lib/libuuid.so.1 bin/libuuid.so

yum install glibc-static
```

1.3 配置方法
以下配置方法介绍中sdc表示cache device，也就是SSD的盘符，使用sdb表示backing device，也就是HDD的盘符。

1.3.1 格式化硬盘分区
应用硬盘到bcache模式之前需要将目标分区格式化，这一步会破坏磁盘分区中所有数据。
```
#make-bcache -B /dev/sdb
#make-bcache -C /dev/sdc -w4k -b1M --writeback
```
参数意义：
```
-B: 设置backing device
-C: 设置cache device
-w: block size (hard sector size of SSD)，默认是2K，可使用--block=4K代替
-b: bucket size，可以使用--bucket=1M代替
```
可能遇到问题 1: device is busy。
问题原因: a.目标分区需要在使用前卸载并擦除文件系统；b.目标分区已经被其他bcache占用。
对于第一种情况，先擦除目标分区的文件系统，再进行链接。
```
#wipefs -a /dev/sd*
```
对于第二种情况，先注销原有的bcache解除占用再进行格式化，如果注销后仍然提示错误，可以通过--wipe-bcache参数强行格式化。
```
#make-bcache -C /dev/sdc --writeback --wipe-bcache
```

1.3.2 设备注册
格式化完成后需要完成设备的注册，使内核获取设备：
```
# echo /dev/sdb > /sys/fs/bcache/register
#echo /dev/sdc > /sys/fs/bcache/register
```
也可以通过下面的方式实现设备自动注册：
```
echo /dev/sd* > /sys/fs/bcache/register_quiet
```
可能由于内核版本的问题，在实际配置中发现，以上注册命令无需执行就可以完成注册，甚至会报错，无法向register节点写入信息，但是并不影响是使用。
完成注册以后会产生相应的系统节点：
/dev/bcache/
/dev/bcache<N>
/sys/block/bcache0/
/sys/fs/bcache/

1.3.3 设备绑定
完成注册的backing device需要在使用之前绑定到bchache<N>，否则功能无法启用。首先找到完成注册的backing device设备的<UUID>
```
#ls /sys/fs/bcache/
60fbcc3b-4f8e-485b-9f3c-c258c157d614  register  register_quiet
```
那么<UUID>=60fbcc3b-4f8e-485b-9f3c-c258c157d614。
```
#echo <UUID> > /sys/block/<sdb>/bcache/attach
```
重新启动系统，完成配置。
实际配置后的磁盘情况，其中使用sdr作为backing device，sds是SSD硬盘，单独建立一个16G分区作为cache。
```
#lsblk -o NAME,MAJ:MIN,RM,SIZE,TYPE,FSTYPE,MOUNTPOINT,UUID,PARTUUID
NAME            MAJ:MIN RM   SIZE TYPE FSTYPE            MOUNTPOINT UUID                                   PARTUUID
sdq        65:0    0 433.5G disk
sdr        65:16   0 558.9G disk bcache               0bb0de96-f7df-4fed-9280-b6e0615718da
└─bcache0 251:0    0 558.9G disk
sds        65:32   0 745.2G disk
└─sds1     65:33   0    16G part bcache               00a196c4-2af9-41b5-a450-e130ab1389e4
sdt        65:48   0 745.2G disk LVM2_memb            KnqL6f-Wa14-0kfr-G2pN-1bqL-pjut-cAOPSn
sdu        65:64   0 558.9G disk LVM2_memb            Z5vnpa-zXcq-2Ln9-Ll3g-QCB4-DTUc-q3AKio
└─vg2-test0
```

[root@localhost ~]# ls /sys/block/sdq/bcache/dev/slaves/
sdq  sdr1

[root@localhost bcache]# cat cache/cache0/set/block_size
512

1.3.4 设置文件系统和挂载
/dev/bcache<N>可以当做普通盘符直接格式化所需的文件系统挂载：
```
#mkfs.ext4 /dev/bcache0
#mount /dev/bcache0 /mnt
```
1.3.5 停用设备
注销设备：
```
echo 1 >/sys/fs/bcache/<UUID>/unregister
```
停用bcache：
```
echo 1 >/sys/block/bcache0/bcache/stop
```
擦除磁盘残留数据：
```
sudo wipefs -a /dev/sdc
sudo wipefs -a /dev/sdb
```

1.3.6 工作模式
bcache有四种不同工作模式：
####writethrough:

The most performant caching mode.

Data written to the device is first written on the ssd, and then copied on the backing device asynchronously, write is considered complete at the end of the copy on SSD. For security purpose, the mechanism here always ensure that no data is considered safe until it has been completely written to the backing device (dirty pages), so if a power outage happened while data are still on the SSD, at next boot, data will be pushed back to the backing device. The goal here was to be as secure with bcache and software Linux Raid as with a hardware Raid device with BBUs.

####writeback:

Secure caching mode.

Data written to the device is copied on the ssd and the HDD at the same time, write is considered complete at the end of write on the HDD. So this tend to be more secure than “writeback”, but will lack of some of the performance gain.

###writearouond

Read-only caching mode.

Data written to the device goes directly to the HDD, it is not written to SSD at all, so you don't benefit of any write gain like writethrough; also the first time this data is read, it will be read from HDD. The advantage of this is to have more space for caching reads, and to reduce the wear on the SSD. ight now there is no split between write cache and read cache as there can be on some filesystem (say ZFS), to handle particularities of the technologies behind ssd (slc, mlc, etc..).
none:
De-activate completely caching capability ( but the /dev/bcache# device is still available )
工作模式切换：
echo writeback > /sys/block/sdr/bcache/cache_mode

1.3.7 bcache device状态查看
```
# bcache-super-show -f /dev/sdr
sb.magic ok
sb.first_sector 8 [match]
sb.csum 532A75DDACA80EC8 [match]
sb.version 1 [backing device]

dev.label (empty)
dev.uuid 0bb0de96-f7df-4fed-9280-b6e0615718da
dev.sectors_per_block 1
dev.sectors_per_bucket 1024
dev.data.first_sector 16
dev.data.cache_mode 1 [writeback]
dev.data.cache_state 0 [detached]

cset.uuid 538edd49-6d68-4fb0-8471-49a3346fae90
```
```
# bcache-super-show -f /dev/sds1
sb.magic ok
sb.first_sector 8 [match]
sb.csum 18DA32EC2B332BE2 [match]
sb.version 3 [cache device]

dev.label (empty)
dev.uuid 00a196c4-2af9-41b5-a450-e130ab1389e4
dev.sectors_per_block 8
dev.sectors_per_bucket 2048
dev.cache.first_sector 2048
dev.cache.cache_sectors 33552384
dev.cache.total_sectors 33554432
dev.cache.ordered yes
dev.cache.discard no
dev.cache.pos 0
dev.cache.replacement 0 [lru]

cset.uuid 60fbcc3b-4f8e-485b-9f3c-c258c157d614
```
1.3.7 配置运行问题
根据用户手册中的介绍，bcache配置完成以后，通过下面的命令可以强制启动bcache，但在实际操作时会造成系统当机。
```
echo 1 > /sys/block/sdb/bcache/running
```
