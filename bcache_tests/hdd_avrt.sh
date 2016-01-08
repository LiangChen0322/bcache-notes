#!/bin/sh

device="/dev/sdn3"

for mod in randread randwrite; do
	for bs in 4K 8K 16K 32K 64K 128K 256K 512K 1M; do

		echo "hdd avrt test with $mod $bs:"
		title="hdd_avrt_"$mod"_"$bs

		fio --rw=$mod --bs=$bs --filename=$device \
			--size=16G --numjobs=1 --iodepth=1 --runtime=60 \
			--group_reporting --direct=1 --ioengine=libaio \
			--name=$title --output=$title".log" \
			--write_bw_log=$title  --write_iops_log=$title;

		echo -e "\n"
		sleep 10
	done
done