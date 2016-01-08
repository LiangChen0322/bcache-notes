#!/bin/sh

for mod in read write; do
	for bs in 4K 8K 16K; do
		echo "hdd test with $mod $bs:"
		fio --rw=$mod --bs=$bs --filename=/dev/sdn3 \
			--size=16G --numjobs=8 --iodepth=8 --runtime=60 \
			--name="hdd_"$mod"_"$bs --direct=1 --ioengine=libaio \
			--output="hdd_"$mod"_"$bs".log" --group_reporting \
			--write_bw_log=$mod"_"$bs --write_iops_log=$mod"_"$bs;
		echo -e "\n"
		sleep 10
	done

	for bs in 32K 64K 128K; do
		echo "hdd test with $mod $bs:"
		fio --rw=$mod --bs=$bs --filename=/dev/sdn3 \
			--size=16G --numjobs=4 --iodepth=8 --runtime=60 \
			--name="hdd_"$mod"_"$bs --direct=1 --ioengine=libaio \
			--output="hdd_"$mod"_"$bs".log" --group_reporting \
			--write_bw_log=$mod"_"$bs --write_iops_log=$mod"_"$bs;
		echo -e "\n"
		sleep 10
	done

	for bs in 256K 512K 1M; do
		echo "hdd test with $mod $bs:"
		fio --rw=$mod --bs=$bs --filename=/dev/sdn3 \
			--size=16G --numjobs=2 --iodepth=16 --runtime=60 \
			--name="hdd_"$mod"_"$bs --direct=1 --ioengine=libaio \
			--output="hdd_"$mod"_"$bs".log" --group_reporting \
			--write_bw_log=$mod"_"$bs --write_iops_log=$mod"_"$bs;
		echo -e "\n"
		sleep 10
	done
done