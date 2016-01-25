
http://os.51cto.com/art/201205/334274.htm

http://blog.sina.com.cn/s/blog_4485748101019r72.html

https://www.linux.com/learn/tutorials/754674-using-bcache-to-soup-up-your-sata-drives

https://wiki.archlinux.org/index.php/Bcache

http://pommi.nethuis.nl/linux-bcache-ssd-caching-statistics-using-collectd/?utm_source=tuicool&utm_medium=referral

http://blog.heimsbakk.net/posts/2014/2014-12-15-fio.html

https://github.com/axboe/fio/blob/master/tools/plot/fio2gnuplot.manpage

http://blog.csdn.net/heiyeshuwu/article/details/44181345

http://blog.csdn.net/liumangxiong/article/details/18090043

http://www.raid6.com.au/posts/SSD_caching/

http://blog.itpub.net/25618347/viewspace-713869/

https://github.com/radii/fio

http://www.helplib.net/s/linux.die/65_919/man-1-fio.shtml

http://blogs.rdoproject.org/6110/adding-new-3rd-party-tools-in-fio

https://www.linux.com/learn/tutorials/442451-inspecting-disk-io-performance-with-fio/


##注意事项

###设备注册

http://bcache.evilpiepirate.org/FAQ/

完成分区格式化以后进行设备注册时，官方手册中提供的注册方式会失败，并提示以下错误：

```
# echo /dev/sdo2 > /sys/fs/bcache/register
-bash: echo: write error: Invalid argument
```

通过dmesg查看内核日志，发现以下两条信息：

```
[ 2949.084297] bcache: register_cache() registered cache device sdo2
... ...
[ 3054.091888] bcache: register_bcache() error opening /dev/sdo2: device already registered
```

原因分析：在使用`make-bcache`命令格式化分区时，就完成了设备注册，只需要进行绑定就可以。

###设备绑定失败

完成绑定后的设备必须将backing和cache设备进行绑定，绑定方法如下

如果绑定成功可以通过以下方式查看完成绑定的设备：


```
[  394.693476] bcache: bch_cached_dev_attach() Couldn't attach sdn1: block size less than set's block size
[  394.693556] bcache: __cached_dev_store() Can't attach 3e67aad6-366d-47ec-aa3d-82990c18f9a1
```
block size

33556480
100667392
```
[root@localhost bcache]# make-bcache -B /dev/sdq
UUID:			55d95b33-0736-4650-8fc0-c498c34c0feb
Set UUID:		d62afd66-1f24-490b-985f-21176037e0ed
version:		1
block_size:		1
data_offset:		16

[root@localhost bcache]# make-bcache -C /dev/sdr1
UUID: 			f5ec37ac-2a74-48e0-85ed-1ae23810a4d2
Set UUID:		529b2734-5e08-4724-9893-f28b37735ad6
version:		0
nbuckets:		32768
block_size:		1
bucket_size:		1024
nr_in_set:		1
nr_this_dev:		0
first_bucket:		1
```

```
[root@localhost bcache]# make-bcache -B /dev/sdq --wipe-bcache
UUID:			8a5e23be-dd8d-49ae-9b62-a1615ed38ffe
Set UUID:		e67928d5-6d37-4f47-9c75-8b6e82bedefa
version:		1
block_size:		1
data_offset:		16

[root@localhost bcache]# make-bcache -C /dev/sdr1 --wipe-bcache
UUID:			6b3d3056-1aaa-4381-89fc-742b40249383
Set UUID:		1a7a9dcc-e981-428b-b3a2-284b16417f7a
version:		0
nbuckets:		32768
block_size:		1
bucket_size:		1024
nr_in_set:		1
nr_this_dev:		0
first_bucket:		1
```

sdq              65:0    0 558.9G  0 disk
└─bcache0       252:0    0 558.9G  0 disk
sdr              65:16   0 745.2G  0 disk
└─sdr1           65:17   0    16G  0 part
  └─bcache0     252:0    0 558.9G  0 disk
