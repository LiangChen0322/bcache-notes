#!/bin/sh

if [ $# -lt 1 ]; then
	echo "need device name."
	exit 1;
fi

if [ -b "$1" ]; then
	device=$1
else
	echo "wrong path"
fi

mod="randread"
pre="bc_"

for bs in 4K 8K 16K; do
	title=$pre$mod"_"$bs
	echo "bcache test with $mod $bs:"

	echo 1 > /sys/block/bcache1/bcache/clear_stats
	fio --rw=$mod --bs=$bs --filename=$device \
		--size=32G --numjobs=8 --iodepth=8 --runtime=60 \
		--group_reporting --direct=1 --ioengine=libaio \
		--name=$title --output=$title".log" \
		--write_bw_log=$title --write_iops_log=$title ;
	hitr=`cat /sys/block/bcache1/bcache/stats_total/cache_hit_ratio`
	echo "cache hit ratio: $hitr" >> $title".log"
	echo -e "\n"
	sleep 20
done

for bs in 32K 64K 128K; do
	title="bc_"$mod"_"$bs
	echo "bcache test with $mod $bs:"
	echo 1 > /sys/block/bcache1/bcache/clear_stats
	fio --rw=$mod --bs=$bs --filename=$device \
		--size=32G --numjobs=4 --iodepth=8 --runtime=60 \
		--name=$title --direct=1 --ioengine=libaio \
		--output=$title".log" --group_reporting \
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
		--name=$title --direct=1 --ioengine=libaio \
		--output="./"$title".log" --group_reporting \
		--write_bw_log=$title --write_iops_log=$title;
	hitr=`cat /sys/block/bcache1/bcache/stats_total/cache_hit_ratio`
	echo "cache hit ratio: $hitr" >> $title".log"
	echo -e "\n"
	sleep 20
done