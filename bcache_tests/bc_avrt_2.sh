#!/bin/sh

# device name and path
device="/dev/bcache0"
# bcache block device path
dp="/sys/block/bcache0"

runt=30

function fill_disk() {
	echo "pre-read the cache ... ..."
	fio --rw=read --bs=256K --filename=$device \
		--numjobs=4 --iodepth=8 --size=32G \
		--group_reporting --direct=1 --ioengine=libaio \
		--name=fill --output="temp.log";
	printf "\n"
}

# fio_test title mode block_size numjobs iodepth
function fio_test() {
	echo 1 > $dp/bcache/clear_stats

	fio --rw=$2 --bs=$3 --filename=$device \
		--numjobs=$4 --iodepth=$5 --runtime=$runt \
		--group_reporting --direct=1 --ioengine=libaio \
		--name=$1 --output=$1".log" \
		--write_bw_log=$1 --write_iops_log=$1 --write_lat_log=$1;
	printf "\n"

	hitr=`cat $dp/bcache/stats_total/cache_hit_ratio`
	echo "cache hit ratio: $hitr" >> $1".log"
}

fill_disk

for mod in read randread; do
	for bs in 4K 8K 16K 32K 64K 128K 256K 512K 1M; do
		echo "bcache avrt test with $mod $bs:"
		title="bcache_avrt_"$mod"_"$bs

		nj=1
		iod=1
		fio_test $title $mod $bs $nj $iod
	done
done