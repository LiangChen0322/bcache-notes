#!/bin/sh

device="/dev/bcache0"
dp="/sys/block/bcache0"
bdev="sdn1"
cdev="sdo1"
runt=900
npre="bc_"

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
	printf "stop caching device... ...\r"
	sleep 3
	echo 1 > /sys/fs/bcache/8b3c0faa-3b63-48bb-9786-1676197cf325/stop
	printf "\t\t\t\t\t\r"
	printf "clean caching device... ...\r"
	sleep 2
	wipefs -a /dev/$cdev
	printf "\t\t\t\t\t\r"
	echo "Re-attach caching device... ...\r"
	sleep 2
	echo 8b3c0faa-3b63-48bb-9786-1676197cf325 > /sys/block/sdn/$bdev/bcache/attach
	sleep 2
}

# fio_test title mode block_size numjobs iodepth
function fio_test() {
	fio --rw=$2 --bs=$3 --filename=$device \
		--numjobs=$4 --iodepth=$5 --runtime=$runt \
		--group_reporting --direct=1 --ioengine=libaio \
		--name=$1 --output=$1".log" --rwmixread=70 \
		--write_bw_log=$1 --write_iops_log=$1;	# --write_lat_log=$1
	printf "\n"
}

function fio_test_2() {
	fio --rw=$2 --bs=$3 --filename=$device \
		--numjobs=$4 --iodepth=$5 --runtime=$runt \
		--group_reporting --direct=1 --ioengine=libaio \
		--name=$1 --output=$1".log" --rwmixread=50 \
		--write_bw_log=$1 --write_iops_log=$1;	# --write_lat_log=$1
	printf "\n"
}

function fio_test_3() {
	fio --rw=$2 --bs=$3 --filename=$device \
		--numjobs=$4 --iodepth=$5 --runtime=$runt \
		--group_reporting --direct=1 --ioengine=libaio \
		--name=$1 --output=$1".log" --rwmixread=30 \
		--write_bw_log=$1 --write_iops_log=$1;	# --write_lat_log=$1
	printf "\n"
}

function monitor() {
	bcache_status $1 $2 $3
}


if (( $1 == "1" )); then
	for wb_delay in 10 20 30; do
		mkdir "de"$wb_delay"_read70"
		cd "de"$wb_delay"_read70"

		echo $wb_delay > /sys/block/bcache0/bcache/writeback_delay

		for mod in rw randrw; do
			#for bs in 4K 8K 16K 32K 64K 128K 256K 512K 1M; do
				for bs in 8K 16K; do
				title=$npre$mod"_"$bs
				echo "bcache test with $mod $bs:"

				reattach;
				nj=4
				iod=8
				monitor bcache0 $title $runt &
				fio_test $title $mod $bs $nj $iod
			done
		done
		cd ../
	done
fi

for wb_delay in 10 20 30; do
	mkdir "de"$wb_delay"_read50"
	cd "de"$wb_delay"_read50"

	echo $wb_delay > /sys/block/bcache0/bcache/writeback_delay

	for mod in rw randrw; do
		#for bs in 4K 8K 16K 32K 64K 128K 256K 512K 1M; do
		for bs in 4K 16K 32K 128K 1M; do
			title=$npre$mod"_"$bs
			echo "bcache test with $mod $bs:"

			reattach;
			nj=4
			iod=8
			monitor bcache0 $title $runt &
			fio_test_2 $title $mod $bs $nj $iod
		done
	done
	cd ../
done

for wb_delay in 10 20 30; do
	mkdir "de"$wb_delay"_read30"
	cd "de"$wb_delay"_read30"

	echo $wb_delay > /sys/block/bcache0/bcache/writeback_delay

	for mod in rw randrw; do
		#for bs in 4K 8K 16K 32K 64K 128K 256K 512K 1M; do
		for bs in 4K 16K 32K 128K 1M; do
			title=$npre$mod"_"$bs
			echo "bcache test with $mod $bs:"

			reattach;
			nj=4
			iod=8
			monitor bcache0 $title $runt &
			fio_test_3 $title $mod $bs $nj $iod
		done
	done
	cd ../
done
