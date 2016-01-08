#!/bin/sh

for mod in write read; do
#	for bs in 4K 8K 16K; do
#		echo "bcache test with $mod $bs, waiting for clean dirty data:"
#		#	--randrepeat=1 \
#		echo 1 > /sys/block/bcache1/bcache/clear_stats
#		fio --rw=$mod --bs=$bs --filename=/dev/bcache1 \
#			--size=16G --numjobs=8 --iodepth=8 --runtime=60 \
#			--name=$mod"_"$bs --direct=1 --ioengine=libaio \
#			--output=$mod"_"$bs".log" --group_reporting \
#			--write_bw_log=$mod"_"$bs --write_iops_log=$mod"_"$bs;
#		hitr=`cat /sys/block/bcache1/bcache/stats_total/cache_hit_ratio`
#		echo "cache hit ratio: $hitr" >> $mod"_"$bs".log"
#		echo -e "\n"
#		sleep 120
#	done

#	for bs in 32K 64K 128K; do
	for bs in 128K 128K 128K; do
		echo "bcache test with $mod $bs, waiting for clean dirty data:"
		echo 1 > /sys/block/bcache1/bcache/clear_stats
		fio --rw=$mod --bs=$bs --filename=/dev/bcache1 \
			--size=16G --numjobs=4 --iodepth=8 --runtime=60 \
			--name=$mod"_"$bs --direct=1 --ioengine=libaio \
			--output=$mod"_"$bs".log" --group_reporting \
			--write_bw_log=$mod"_"$bs --write_iops_log=$mod"_"$bs;
		hitr=`cat /sys/block/bcache1/bcache/stats_total/cache_hit_ratio`
		echo "cache hit ratio: $hitr" >> $mod"_"$bs".log"
		echo -e "\n"
		sleep 10
	done

#	for bs in 256K 512K 1M; do
#		echo "bcache test with $mod $bs, waiting for clean dirty data:"
#		echo 1 > /sys/block/bcache1/bcache/clear_stats
#		fio --rw=$mod --bs=$bs --filename=/dev/bcache1 \
#			--size=2G --numjobs=2 --iodepth=16 --runtime=60 \
#			--name=$mod"_"$bs --direct=1 --ioengine=libaio \
#			--output=$mod"_"$bs".log" --group_reporting \
#			--write_bw_log=$mod"_"$bs --write_iops_log=$mod"_"$bs;
#		hitr=`cat /sys/block/bcache1/bcache/stats_total/cache_hit_ratio`
#		echo "cache hit ratio: $hitr" >> $mod"_"$bs".log"
#		echo -e "\n"
#		sleep 120
#	done
done