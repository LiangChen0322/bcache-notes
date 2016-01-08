#!/bin/sh

# device name and path
device="/dev/bcache0"
# bcache block device path
dp="/sys/block/bcache0"
runt=30

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

function reattach() {
	echo "Re-attach device. Waiting for several seconds."
	echo 8b3c0faa-3b63-48bb-9786-1676197cf325 > /sys/block/bcache0/bcache/detach
	dirty="1M"
	until [ "$dirty" = "0" ]; do
		dirty=`cat $dp/bcache/dirty_data`
		printf "dirty data size: %-6s \r" $dirty
		sleep 1
	done
	printf "\n"
	echo "stop caching device ... ..."
	sleep 3
	echo 1 > /sys/fs/bcache/8b3c0faa-3b63-48bb-9786-1676197cf325/stop
	echo "clean device ... ..."
	sleep 2
	wipefs -a /dev/sdo1
	echo "reattach device ... ..."
	sleep 2
	echo 8b3c0faa-3b63-48bb-9786-1676197cf325 > /sys/block/sdn/sdn2/bcache/attach
	sleep 2
}

reattach;

for mod in read randread write randwrite; do
	for bs in 4K 8K 16K 32K 64K 128K 256K 512K 1M; do
		echo "bcache avrt test with $mod $bs:"
		title="bcache_avrt_"$mod"_"$bs

		nj=1
		iod=1
		fio_test $title $mod $bs $nj $iod

		reattach;
	done
done
