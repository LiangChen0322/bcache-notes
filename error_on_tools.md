## 配置工具错误

1. 磁盘取出后，由于设备的注册信息，包括主次设备号被更改，原有的配置会被打乱，甚至出现bcache1、bcacha2等没有配置过的节点；
2. 博客错误：`echo UUID > /sys/block/bcache0/bcache/attach`；

##设备注册失败问题

```
# echo /dev/sdo1 > /sys/fs/bcache/register
-bash: echo: write error: Invalid argument
```

这个错误可以忽略，可能是由于bcache-tools或者内核版本的问题，分区格式化为bcache分区以后会自动进行注册，并且设备重启以后会自动注册，但是不保证其他内核内核或bcache-tools版本必须执行次步骤。通过dmesg查看内核信息会发现bcache打印出设备已经注册的信息，说明设备已经注册完成，因此执行上面的命令会提示错误。
```
[ 2949.084297] bcache: register_cache() registered cache device sdo2
... ...
[ 3054.091888] bcache: register_bcache() error opening /dev/sdo2: device already registered
```

##设备绑定失败

执行设备绑定命令以后应当可以在设备绑定完成以后在slaves目录下面看到两个设备名称，并且通过lsblk可以看到两个设备都与对应的bcache设备号绑定。但在使用命令将sdo1作为cache绑定到sdn1时，绑定多次以后发下sdo1始终无法绑定到sdn1。

```
# echo <UUID> > /sys/block/bcache0/bcache/attach

# ls /sys/block/bcache0/slaves/
sdn2

# lsblk
sdn               8:208  0 558.9G  0 disk  
├─sdn1            8:209  0    64G  0 part  
├─sdn2            8:210  0   128G  0 part  
│ └─bcache0     252:0    0   128G  0 disk  
└─sdn3            8:211  0 366.9G  0 part  
sdo               8:224  0 745.2G  0 disk  
├─sdo1            8:225  0    64G  0 part   
├─sdo2            8:226  0   128G  0 part  
└─sdo3            8:227  0 553.2G  0 part
```

通过dmesg检查bcache的信息：

```
[  394.693476] bcache: bch_cached_dev_attach() Couldn't attach sdn1: block size less than set's block size
[  394.693556] bcache: __cached_dev_store() Can't attach 3e67aad6-366d-47ec-aa3d-82990c18f9a1
```

原因分析：bcache设备初始化时，通过`--block 4k`或者`-w4k`设置block size，这个数值不能大于backing device的block size。

##dirty data刷新时间长短设置

dirty data何时刷新主要有


##顺序读性能低于随机读性能

bcache默认跳过顺序

##重要参数

cache_mode

模式主要有三种，

命中与不明中的情况下avrt

writeback_delay： dirty data产生后写会磁盘的延迟时间，如果会对某块区域反复修改，则设置较大的数值，

writeback_percent

writeback_rate

/sys/block/bcache0/bcache/writeback_percent
/sys/block/bcache0/bcache/writeback_delay
/sys/block/bcache0/bcache/writeback_percent

#问题记录

dirty data写回以前，是否会影响数据的一致性。

##改进方案

1. 细化不同状态下的性能对比，更改配置比较性能变化；

包括在cache无dirty-data和缓存的情况下，也就是cache冷的情况下； 提前读取或写入相同内容后的测试，避免命中率的极端；

2. 不同cache大小绑定相同HDD下的性能简单对比；
3. 不同压力下与bcache配置的优化，避免bcache负载过高，造成性能降低；
4. 重新测试AVRT。

明确本次目标是找出针对不同I/O情景制定bcache配置方案的思路。

长期计划：

1. 搭建应用场景进行测试和改进；
2. 从代码和提交信息进行深入分析；
3. 观察长时间运行后SSD坏块情况。
