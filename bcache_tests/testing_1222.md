fio --filename=/dev/bcache1 --direct=1 --rw=read --bs=8K --size=10G --numjobs=4 --iodepth=8 --runtime=10 --group_reporting --name=bwrite
fio --filename=/dev/sdu1 --direct=1 --rw=write --bs=256K --size=30G \
--numjobs=4 --iodepth=8 --group_reporting --name=test-write

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
g++ -c `pkg-config --cflags glib-2.0` testme2.c
g++ -o testme2 testme.o `pkg-config --libs glib-2.0`

./x86_64-linux-gnu/glib-2.0/include/glibconfig.h
解决No package ‘gtk+-2.0′ found 
http://blog.chinaunix.net/uid-24948934-id-59806.html


http://bcache.evilpiepirate.org/FAQ/

[   14.337429] bcache: register_bdev() registered backing device sdn1
[   14.386871] bcache: bch_journal_replay() journal replay done, 0 keys in 1 entries, seq 1
[   14.388688] bcache: register_cache() registered cache device sdo1
[  394.693476] bcache: bch_cached_dev_attach() Couldn't attach sdn1: block size less than set's block size
[  394.693556] bcache: __cached_dev_store() Can't attach 3e67aad6-366d-47ec-aa3d-82990c18f9a1
[  765.020123] bcache: cache_set_free() Cache set 3e67aad6-366d-47ec-aa3d-82990c18f9a1 unregistered
[ 1039.941618] bcache: bcache_device_free() bcache0 stopped
[ 1219.613339] bcache: bch_journal_replay() journal replay done, 0 keys in 1 entries, seq 2
[ 1219.615032] bcache: register_cache() registered cache device sdo1
[ 1219.643806] bcache: register_bcache() error opening /dev/sdo1: device already registered
[ 1276.719700] bcache: register_bdev() registered backing device sdn1
[ 1276.744890] bcache: register_bcache() error opening /dev/sdn1: device already registered
[ 2922.415396] bcache: register_bdev() registered backing device sdn2
[ 2949.068059] bcache: run_cache_set() invalidating existing data
[ 2949.084297] bcache: register_cache() registered cache device sdo2
[ 3045.912767] bcache: register_bcache() error opening /dev/sdn2: device already registered
[ 3054.091888] bcache: register_bcache() error opening /dev/sdo2: device already registered


http://comments.gmane.org/gmane.linux.kernel.bcache.devel/1737


## Write_back

[root@localhost ~]# fio --filename=/dev/bcache0 --direct=1 --rw=write --bs=8K --size=10G --numjobs=4 --runtime=10 --group_reporting --name=test-read
test-read: (g=0): rw=write, bs=8K-8K/8K-8K/8K-8K, ioengine=sync, iodepth=1
...
fio-2.2.9
Starting 4 processes
Jobs: 4 (f=4): [W(4)] [100.0% done] [0KB/338.3MB/0KB /s] [0/43.3K/0 iops] [eta 00m:00s]
test-read: (groupid=0, jobs=4): err= 0: pid=14614: Tue Dec 22 02:55:45 2015
  write: io=3386.6MB, bw=346744KB/s, iops=43342, runt= 10001msec
    clat (usec): min=60, max=4298, avg=90.62, stdev=51.45
     lat (usec): min=60, max=4298, avg=90.82, stdev=51.45
    clat percentiles (usec):
     |  1.00th=[   79],  5.00th=[   85], 10.00th=[   86], 20.00th=[   86],
     | 30.00th=[   86], 40.00th=[   87], 50.00th=[   87], 60.00th=[   87],
     | 70.00th=[   87], 80.00th=[   87], 90.00th=[   89], 95.00th=[   97],
     | 99.00th=[  149], 99.50th=[  153], 99.90th=[  556], 99.95th=[ 1064],
     | 99.99th=[ 2288]
    bw (KB  /s): min=85376, max=87792, per=25.01%, avg=86727.62, stdev=583.07
    lat (usec) : 100=95.26%, 250=4.61%, 500=0.03%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.06%, 4=0.02%, 10=0.01%
  cpu          : usr=2.63%, sys=9.98%, ctx=433494, majf=0, minf=110
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=433473/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: io=3386.6MB, aggrb=346743KB/s, minb=346743KB/s, maxb=346743KB/s, mint=10001msec, maxt=10001msec

Disk stats (read/write):
    bcache0: ios=0/428541, merge=0/0, ticks=0/35801, in_queue=1214964, util=100.00%, aggrios=89/217031, aggrmerge=0/29, aggrticks=38/16423, aggrin_queue=16450, aggrutil=99.05%
  sdq: ios=0/11, merge=0/0, ticks=0/21, in_queue=21, util=0.21%
  sdr: ios=179/434051, merge=0/58, ticks=77/32825, in_queue=32880, util=99.05%




[root@localhost ~]# fio --filename=/dev/bcache0 --direct=1 --rw=write --bs=8K --size=10G --numjobs=4 --group_reporting --name=test-readcleartest-readclear: (g=0): rw=write, bs=8K-8K/8K-8K/8K-8K, ioengine=sync, iodepth=1
...
fio-2.2.9
Starting 4 processes
Jobs: 1 (f=1): [_(3),W(1)] [100.0% done] [0KB/52275KB/0KB /s] [0/6534/0 iops] [eta 00m:00s]
test-readclear: (groupid=0, jobs=4): err= 0: pid=14803: Tue Dec 22 03:06:14 2015
  write: io=40960MB, bw=290718KB/s, iops=36339, runt=144274msec
    clat (usec): min=62, max=14032, avg=102.77, stdev=213.78
     lat (usec): min=62, max=14032, avg=103.03, stdev=213.78
    clat percentiles (usec):
     |  1.00th=[   74],  5.00th=[   81], 10.00th=[   85], 20.00th=[   86],
     | 30.00th=[   87], 40.00th=[   87], 50.00th=[   87], 60.00th=[   88],
     | 70.00th=[   90], 80.00th=[   99], 90.00th=[  115], 95.00th=[  141],
     | 99.00th=[  179], 99.50th=[  201], 99.90th=[ 3696], 99.95th=[ 5664],
     | 99.99th=[ 9024]
    bw (KB  /s): min=39984, max=87216, per=26.33%, avg=76532.03, stdev=9251.51
    lat (usec) : 100=80.90%, 250=18.78%, 500=0.05%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.10%, 4=0.06%, 10=0.08%, 20=0.01%
  cpu          : usr=2.79%, sys=10.34%, ctx=5261975, majf=0, minf=953
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=5242880/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: io=40960MB, aggrb=290717KB/s, minb=290717KB/s, maxb=290717KB/s, mint=144274msec, maxt=144274msec

Disk stats (read/write):
    bcache0: ios=163/5242657, merge=0/0, ticks=21/493951, in_queue=17537331, util=100.00%, aggrios=6898/2631415, aggrmerge=0/78, aggrticks=21426/246037, aggrin_queue=267520, aggrutil=97.95%
  sdq: ios=0/13471, merge=0/0, ticks=0/51183, in_queue=51166, util=8.12%
  sdr: ios=13797/5249359, merge=0/157, ticks=42852/440891, in_queue=483874, util=97.95%


[root@localhost ~]# fio --filename=/dev/bcache0 --direct=1 --rw=write --bs=8K --size=32G --numjobs=4 --group_reporting --name=test-write
test-write: (g=0): rw=write, bs=8K-8K/8K-8K/8K-8K, ioengine=sync, iodepth=1
...
fio-2.2.9
Starting 4 processes
Jobs: 2 (f=2): [_(1),W(2),_(1)] [100.0% done] [0KB/165.6MB/0KB /s] [0/21.2K/0 iops] [eta 00m:00s]
test-write: (groupid=0, jobs=4): err= 0: pid=14934: Tue Dec 22 03:17:07 2015
  write: io=131072MB, bw=281382KB/s, iops=35172, runt=476995msec
    clat (usec): min=62, max=21229, avg=111.49, stdev=402.31
     lat (usec): min=62, max=21229, avg=111.73, stdev=402.31
    clat percentiles (usec):
     |  1.00th=[   76],  5.00th=[   84], 10.00th=[   86], 20.00th=[   87],
     | 30.00th=[   87], 40.00th=[   87], 50.00th=[   87], 60.00th=[   88],
     | 70.00th=[   88], 80.00th=[   90], 90.00th=[  102], 95.00th=[  125],
     | 99.00th=[  165], 99.50th=[  203], 99.90th=[ 8384], 99.95th=[10560],
     | 99.99th=[12352]
    bw (KB  /s): min=38256, max=87200, per=25.13%, avg=70716.85, stdev=6853.03
    lat (usec) : 100=88.15%, 250=11.44%, 500=0.04%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.09%, 4=0.06%, 10=0.14%, 20=0.06%, 50=0.01%
  cpu          : usr=2.44%, sys=8.24%, ctx=16837625, majf=0, minf=2312
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=16777216/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: io=131072MB, aggrb=281381KB/s, minb=281381KB/s, maxb=281381KB/s, mint=476995msec, maxt=476995msec

Disk stats (read/write):
    bcache0: ios=59/16777157, merge=0/0, ticks=150/1742351, in_queue=58076500, util=100.00%, aggrios=33506/8432527, aggrmerge=0/41, aggrticks=206853/911772, aggrin_queue=1119307, aggrutil=100.00%
  sdq: ios=59/66896, merge=0/0, ticks=147/223235, in_queue=223287, util=22.03%
  sdr: ios=66954/16798158, merge=1/83, ticks=413560/1600310, in_queue=2015328, util=100.00%


[root@localhost ~]# fio --filename=/dev/bcache0 --direct=1 --rw=write --bs=8K --size=64G --numjobs=4 --group_reporting --name=test-write
test-write: (g=0): rw=write, bs=8K-8K/8K-8K/8K-8K, ioengine=sync, iodepth=1
...
fio-2.2.9
Starting 4 processes
Jobs: 1 (f=1): [_(1),W(1),_(2)] [100.0% done] [0KB/38457KB/0KB /s] [0/4807/0 iops] [eta 00m:00s]
test-write: (groupid=0, jobs=4): err= 0: pid=15093: Tue Dec 22 03:38:55 2015
  write: io=262144MB, bw=234315KB/s, iops=29289, runt=1145620msec
    clat (usec): min=62, max=26859, avg=129.35, stdev=652.62
     lat (usec): min=62, max=26860, avg=129.60, stdev=652.62
    clat percentiles (usec):
     |  1.00th=[   75],  5.00th=[   81], 10.00th=[   86], 20.00th=[   86],
     | 30.00th=[   87], 40.00th=[   87], 50.00th=[   87], 60.00th=[   88],
     | 70.00th=[   89], 80.00th=[   98], 90.00th=[  113], 95.00th=[  143],
     | 99.00th=[  189], 99.50th=[  294], 99.90th=[13504], 99.95th=[15424],
     | 99.99th=[18304]
    bw (KB  /s): min=29183, max=84928, per=26.05%, avg=61035.88, stdev=7373.82
    lat (usec) : 100=81.45%, 250=18.03%, 500=0.07%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.10%, 4=0.07%, 10=0.08%, 20=0.19%, 50=0.01%
  cpu          : usr=2.24%, sys=8.19%, ctx=33739524, majf=0, minf=5997
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=33554432/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: io=262144MB, aggrb=234314KB/s, minb=234314KB/s, maxb=234314KB/s, mint=1145620msec, maxt=1145620msec

Disk stats (read/write):
    bcache0: ios=59/33554156, merge=0/0, ticks=538/4049315, in_queue=139332163, util=100.00%, aggrios=131589/16930805, aggrmerge=1/26, aggrticks=1113244/2709346, aggrin_queue=3821563, aggrutil=98.31%
  sdq: ios=59/263065, merge=0/0, ticks=538/1665946, in_queue=1665962, util=45.34%
  sdr: ios=263120/33598546, merge=3/53, ticks=2225951/3752746, in_queue=5977164, util=98.31%


[root@localhost ~]# fio --filename=/dev/bcache0 --direct=1 --rw=write --bs=8K --size=128G --numjobs=4 --group_reporting --name=test-write
test-write: (g=0): rw=write, bs=8K-8K/8K-8K/8K-8K, ioengine=sync, iodepth=1
...
fio-2.2.9
Starting 4 processes
Jobs: 1 (f=1): [W(1),_(3)] [100.0% done] [0KB/43868KB/0KB /s] [0/5483/0 iops] [eta 00m:00s]     
test-write: (groupid=0, jobs=4): err= 0: pid=17836: Tue Dec 22 04:13:49 2015
  write: io=524288MB, bw=284915KB/s, iops=35614, runt=1884318msec
    clat (usec): min=62, max=32199, avg=110.50, stdev=428.50
     lat (usec): min=62, max=32200, avg=110.74, stdev=428.50
    clat percentiles (usec):
     |  1.00th=[   81],  5.00th=[   86], 10.00th=[   86], 20.00th=[   87],
     | 30.00th=[   87], 40.00th=[   87], 50.00th=[   87], 60.00th=[   88],
     | 70.00th=[   88], 80.00th=[   88], 90.00th=[   94], 95.00th=[  116],
     | 99.00th=[  153], 99.50th=[  191], 99.90th=[ 8896], 99.95th=[11328],
     | 99.99th=[14656]
    bw (KB  /s): min=34528, max=87744, per=25.05%, avg=71380.18, stdev=8071.61
    lat (usec) : 100=92.36%, 250=7.25%, 500=0.04%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.09%, 4=0.05%, 10=0.11%, 20=0.08%, 50=0.01%
  cpu          : usr=2.46%, sys=7.64%, ctx=67363638, majf=0, minf=2195
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=67108864/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: io=524288MB, aggrb=284915KB/s, minb=284915KB/s, maxb=284915KB/s, mint=1884318msec, maxt=1884318msec

Disk stats (read/write):
    bcache0: ios=59/67108122, merge=0/0, ticks=224/6939219, in_queue=229350447, util=100.00%, aggrios=147338/33746025, aggrmerge=1/205, aggrticks=943230/3950384, aggrin_queue=4895219, aggrutil=100.00%
  sdq: ios=59/294562, merge=0/0, ticks=223/1452269, in_queue=1452110, util=24.82%
  sdr: ios=294617/67197489, merge=3/410, ticks=1886238/6448499, in_queue=8338329, util=100.00%






[root@localhost ~]# fio --filename=/dev/bcache0 --direct=1 --rw=read --bs=8K --size=128G --numjobs=4 --group_reporting --name=read
read: (g=0): rw=read, bs=8K-8K/8K-8K/8K-8K, ioengine=sync, iodepth=1
...
fio-2.2.9
Starting 4 processes
^Cbs: 4 (f=4): [R(4)] [2.1% done] [12931KB/0KB/0KB /s] [1616/0/0 iops] [eta 11h:43m:09s]    
fio: terminating on signal 2

read: (groupid=0, jobs=4): err= 0: pid=19123: Tue Dec 22 05:03:36 2015
  read : io=13284MB, bw=15053KB/s, iops=1881, runt=903661msec
    clat (usec): min=45, max=1460.4K, avg=2121.38, stdev=12441.14
     lat (usec): min=45, max=1460.4K, avg=2121.78, stdev=12441.16
    clat percentiles (usec):
     |  1.00th=[   49],  5.00th=[   53], 10.00th=[   56], 20.00th=[   65],
     | 30.00th=[   73], 40.00th=[  131], 50.00th=[  173], 60.00th=[  213],
     | 70.00th=[  258], 80.00th=[  490], 90.00th=[ 5472], 95.00th=[15680],
     | 99.00th=[24960], 99.50th=[29824], 99.90th=[56576], 99.95th=[82432],
     | 99.99th=[288768]
    bw (KB  /s): min=    5, max=87552, per=25.79%, avg=3882.08, stdev=7726.29
    lat (usec) : 50=1.03%, 100=32.96%, 250=34.53%, 500=11.53%, 750=1.17%
    lat (usec) : 1000=1.59%
    lat (msec) : 2=2.32%, 4=2.18%, 10=4.77%, 20=5.45%, 50=2.34%
    lat (msec) : 100=0.09%, 250=0.02%, 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2000=0.01%
  cpu          : usr=0.40%, sys=1.83%, ctx=1700413, majf=0, minf=783
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=1700380/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: io=13284MB, aggrb=15053KB/s, minb=15053KB/s, maxb=15053KB/s, mint=903661msec, maxt=903661msec

Disk stats (read/write):
    bcache0: ios=1700235/0, merge=0/0, ticks=3553400/0, in_queue=110216169, util=100.00%, aggrios=899339/49108, aggrmerge=0/0, aggrticks=1778820/1666224, aggrin_queue=3443832, aggrutil=100.00%
  sdq: ios=1543678/97577, merge=0/0, ticks=3512938/3332384, in_queue=6843108, util=100.00%
  sdr: ios=255001/639, merge=0/0, ticks=44702/65, in_queue=44557, util=3.93%


  