#!/bin/sh

device="/dev/bcache1"

for mod in randread; do
	for bs in 4K 8K 16K; do
		title="bc_"$mod"_"$bs

		echo "bcache test with $mod $bs:"
#		dirty="1M"
#		until [ "$dirty" = "0" ]; do
#			dirty=`cat /sys/block/bcache1/bcache/dirty_data`
#			#echo $dirty
#		done
		#	--randrepeat=1 \
		echo 1 > /sys/block/bcache1/bcache/clear_stats
		fio --rw=$mod --bs=$bs --filename=$device \
			--size=32G --numjobs=8 --iodepth=8 --runtime=60 \
			--name=$title --direct=1 --ioengine=libaio \
			--output=$title".log" --group_reporting \
			--write_bw_log=$title --write_iops_log=$title ;
		hitr=`cat /sys/block/bcache1/bcache/stats_total/cache_hit_ratio`
		echo "cache hit ratio: $hitr" >> $title".log"
		echo -e "\n"
		sleep 20
	done

	for bs in 32K 64K 128K; do
		title="bc_"$mod"_"$bs

		echo "bcache test with $mod $bs, waiting for clean dirty data:"
#		dirty="1M"
#		until [ "$dirty" = "0" ]; do
#			dirty=`cat /sys/block/bcache1/bcache/dirty_data`
#			#echo $dirty
#		done
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

		echo "bcache test with $mod $bs, waiting for clean dirty data:"
#		dirty="1M"
#		until [ "$dirty" = "0" ]; do
#			dirty=`cat /sys/block/bcache1/bcache/dirty_data`
#			#echo $dirty
#		done
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
done