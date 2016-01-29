# bcache简析

## B+tree分析

对bcache来说B+tree是最重要的数结构，bcache通过B+tree组织cache结构，并根据应用特点进行了大量修改。

struct btree_keys_ops {}；

3.1 bucket
缓存设备会按照bucket大小划分成很多bucket，bucket的大小最好是设置成与缓存设备ssd的擦除大小一致，一般建议128k~2M+，默认是512k。每个bucket有个优先级编号（16 bit的priority），每次hit都会增加，然后所有的bucket的优先级编号都会周期性地减少，不常用的会被回收，这个优先级编号主要是用来实现lru替换的。bucket还有8bit的generation，用来invalidate bucket用的。
bucket内空间是追加分配的，只记录当前分配到哪个偏移了，下一次分配的时候从当前记录位置往后分配。另外在选择bucket来缓存数据时有两个优先原则：1）优先考虑io连续性，即使io可能来自于不同的生产者；2）其次考虑相关性，同一个进程产生的数据尽量缓存到相同的bucket里。

3.2 bkey
bucket的管理是使用b+树索引，而b+树节点中的关键结构就是bkey，bkey就是记录缓存设备缓存数据和后端设备数据的映射关系的，其结构如下。
struct bkey {
uint64_t high;
uint64_t low;
uint64_t ptr[];
}

其中：
KEY_INODE:表示一个后端设备的id编号（后端设备在cache set中一般以bdev0，bdev1这种方式出现）
KEY_SIZE：表示该bkey所对应缓存数据的大小
KEY_DIRTY：表示该块缓存数据是否是脏数据
KEY_PTRS：表示cache设备的个数（多个ptr是用来支持多个cache设备的，多个cache设备只对脏数据和元数据做镜像）
KEY_OFFSET：bkey所缓存的hdd上的那段数据区域的结束地址
PTR_DEV：cache设备
PTR_OFFSET：在缓存设备中缓存的数据的起始地址
PTR_GEN：对应cache的bucket的迭代数（版本）

3.3 bset
一个bset是一个bkey的数组，在内存中的bset是一段连续的内存，并且以bkey排序的（bkey之间进行比较的时候是先比较KEY_INODE，如果KEY_INODE相同，再比较KEY_OFFSET）。
bset在磁盘上（缓存设备）有很多，但是内存中一个btree node只有4个bset。

4. bcache中的b+树
4.1 btree结构
bcache中以b+tree来维护索引，一个btree node里包含4个bset，每个bset中是排序的bkey。
