#!/bin/sh

for mod in read write; do
	for bs in 4K 8K 16K; do
		echo "ssd test with $mod $bs:"
		#	--randrepeat=1 \
		fio --rw=$mod --bs=$bs --filename=/dev/sdo3 \
			--size=32G --numjobs=8 --iodepth=8 --runtime=60 \
			--name="ssd_"$mod"_"$bs --direct=1 --ioengine=libaio \
			--output="ssd_"$mod"_"$bs".log" --group_reporting \
			--write_bw_log="ssd_"$mod"_"$bs --write_iops_log="ssd_"$mod"_"$bs;
		echo -e "\n"
		sleep 10
	done

	for bs in 32K 64K 128K; do
		echo "ssd test with $mod $bs:"
		fio --rw=$mod --bs=$bs --filename=/dev/sdo3 \
			--size=32G --numjobs=4 --iodepth=8 --runtime=60 \
			--name="ssd_"$mod"_"$bs --direct=1 --ioengine=libaio \
			--output="ssd_"$mod"_"$bs".log" --group_reporting \
			--write_bw_log="ssd_"$mod"_"$bs --write_iops_log="ssd_"$mod"_"$bs;
		echo -e "\n"
		sleep 10
	done

	for bs in 256K 512K 1M; do
		echo "bcache test with $mod $bs:"
		fio --rw=$mod --bs=$bs --filename=/dev/sdo3 \
			--size=32G --numjobs=2 --iodepth=16 --runtime=60 \
			--name="ssd_"$mod"_"$bs --direct=1 --ioengine=libaio \
			--output="ssd_"$mod"_"$bs".log" --group_reporting \
			--write_bw_log="ssd_"$mod"_"$bs --write_iops_log="ssd_"$mod"_"$bs;
		echo -e "\n"
		sleep 10
	done
done