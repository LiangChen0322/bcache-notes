#!/bin/sh

device="/dev/bcache0"
dp="/sys/block/bcache0"
mod="randread"
sz=32G		# test total size
runt=60

# fio_test title mode block_size numjobs iodepth
function fio_test() {
	echo 1 > $dp/bcache/clear_stats
	fio --rw=$2 --bs=$3 --filename=$device \
		--size=$4 --numjobs=$4 --iodepth=$5 --runtime=$runt \
		--group_reporting --direct=1 --ioengine=libaio \
		--name=$1 --output=$1".log" \
		--write_bw_log=$1 --write_iops_log=$1;
	printf "\n"
	hitr=`cat $dp/bcache/stats_total/cache_hit_ratio`
	echo "cache hit ratio: $hitr" >> $title".log"
}

for bs in 4K 8K 16K; do
	title="bc_"$mod"_"$bs
	echo "bcache test with $mod $bs:"
	nj=8

	fio_test $title $mod $bs $nj $iod
done

for bs in 4K 8K 16K; do
	title="bc_"$mod"_"$bs
	echo "bcache test with $mod $bs:"

	echo 1 > /sys/block/bcache1/bcache/clear_stats
	fio --rw=$mod --bs=$bs --filename=$device \
		--size=32G --numjobs=8 --iodepth=8 --runtime=60 \
		--group_reporting --direct=1 --ioengine=libaio \
		--name=$title --output=$title".log" \
		--write_bw_log=$title --write_iops_log=$title ;
	echo -e "\n"
	hitr=`cat /sys/block/bcache1/bcache/stats_total/cache_hit_ratio`
	echo "cache hit ratio: $hitr" >> $title".log"
	sleep 20
done

for bs in 32K 64K 128K; do
	title="bc_"$mod"_"$bs
	echo "bcache test with $mod $bs:"
	echo 1 > /sys/block/bcache1/bcache/clear_stats
	fio --rw=$mod --bs=$bs --filename=$device \
		--size=32G --numjobs=4 --iodepth=8 --runtime=60 \
		--group_reporting --direct=1 --ioeng	ine=libaio \
		--name=$title --output=$title".log" \
		--write_bw_log=$title --write_iops_log=$title;
	hitr=`cat /sys/block/bcache1/bcache/stats_total/cache_hit_ratio`
	echo "cache hit ratio: $hitr" >> $title".log"
	echo -e "\n"
	sleep 20
done

for bs in 256K 512K 1M; do
	title="bc_"$mod"_"$bs
	echo "bcache test with $mod $bs:"

	echo 1 > /sys/block/bcache1/bcache/clear_stats
	fio --rw=$mod --bs=$bs --filename=$device \
		--size=32G --numjobs=4 --iodepth=8 --runtime=60 \
		--group_reporting --direct=1 --ioengine=libaio \
		--name=$title --output="./"$title".log" \
		--write_bw_log=$title --write_iops_log=$title;
	hitr=`cat /sys/block/bcache1/bcache/stats_total/cache_hit_ratio`
	echo "cache hit ratio: $hitr" >> $title".log"
	echo -e "\n"
	sleep 20
done