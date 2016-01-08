#!/bin/sh

device="/dev/sdn3"
runt=300
npre="hdd_"

# fio_test title mode block_size numjobs iodepth
function fio_test() {
	fio --rw=$2 --bs=$3 --filename=$device \
		--numjobs=$4 --iodepth=$5 --runtime=$runt \
		--group_reporting --direct=1 --ioengine=libaio \
		--name=$1 --output=$1".log" --rwmixread=70 \
		--write_bw_log=$1 --write_iops_log=$1 --write_lat_log=$1;
	printf "\n"
}

for mod in rw randrw; do
	for bs in 4K 8K 16K 32K 64K 128K 256K 512K 1M; do
		title=$npre$mod"_"$bs
		echo "hdd test with $mod $bs:"

		#reattach;
		nj=4
		iod=8
		fio_test $title $mod $bs $nj $iod
	done
done