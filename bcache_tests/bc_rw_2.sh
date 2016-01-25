#!/bin/sh

device="/dev/bcache0"
dp="/sys/block/bcache0"
bdev="sdn1"
cdev="sdo1"
runt=900
npre="bc_"

# fio --rw=rw --bs=16k --filename=/dev/bcache0 --numjobs=4 --iodepth=16 --runtime=20 -group_reporting --direct=1 --ioengine=libaio --name=test --rwmixread=100
# fio --rw=write --bs=16k --filename=/dev/bcache0 --numjobs=4 --iodepth=16 --runtime=20 -group_reporting --direct=1 --ioengine=libaio --name=test 

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
	# printf "stop caching device... ...\r"
	# sleep 3
	# echo 1 > /sys/fs/bcache/8b3c0faa-3b63-48bb-9786-1676197cf325/stop
	# printf "\t\t\t\t\t\r"
	# printf "clean caching device... ...\r"
	# sleep 2
	# wipefs -a /dev/$cdev
	# printf "\t\t\t\t\t\r"
	echo "Re-attach caching device... ..."
	sleep 2
	echo 8b3c0faa-3b63-48bb-9786-1676197cf325 > /sys/block/sdn/$bdev/bcache/attach
	sleep 2
}

# fio_test title mode block_size numjobs iodepth
function fio_test() {
	rrat=$6
	fio --rw=$2 --bs=$3 --filename=$device \
		--numjobs=$4 --iodepth=$5 --runtime=$runt \
		--group_reporting --direct=1 --ioengine=libaio \
		--name=$1 --output=$1".log" --rwmixread=$rrat \
		--write_bw_log=$1 --write_iops_log=$1;	# --write_lat_log=$1
	printf "\n"
}

function fio_test0() {
	fio --rw=$2 --bs=$3 --filename=$device \
		--numjobs=$4 --iodepth=$5 --runtime=$runt \
		--group_reporting --direct=1 --ioengine=libaio \
		--name=$1 --output=$1".log" --rwmixread=100 \
		--write_bw_log=$1 --write_iops_log=$1;	# --write_lat_log=$1
	printf "\n"
}

function fio_test0() {
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

function fio_test_4() {
	fio --rw=$2 --bs=$3 --filename=$device \
		--numjobs=$4 --iodepth=$5 --runtime=$runt \
		--group_reporting --direct=1 --ioengine=libaio \
		--name=$1 --output=$1".log" --rwmixread=0 \
		--write_bw_log=$1 --write_iops_log=$1;	# --write_lat_log=$1
	printf "\n"
}

function monitor() {
	bcache_status $1 $2 $3
}


fun=(fio_test0 fio_test1 fio_test2 fio_test3 fio_test4)
#0 
rratlist=(100 70 50 30 0)

for mod in randrw rw; do
	for bs in 8K 16K; do
		title=$npre$mod"_"$bs
		echo "bcache test with $mod $bs:"

		for testnum in {0..4}; do
			testfun=${fun[$testnum]}
			readrat=${rratlist[$testnum]}

			for wb_delay in 30; do
				if [ -d "de"$wb_delay"_read"$readrat ]; then
					cd "de"$wb_delay"_read"$readrat
				else
					mkdir "de"$wb_delay"_read"$readrat
					cd "de"$wb_delay"_read"$readrat
				fi

				echo "de"$wb_delay"_read"$readrat
				echo $wb_delay > /sys/block/bcache0/bcache/writeback_delay
				sleep 1

				reattach;
				nj=4
				iod=16
				monitor bcache0 $title $runt &
				$testfun $title $mod $bs $nj $iod $readrat
				cd ../
			done
		done
	done
done

# for testnum in {0..4}; do
# 	testfun=${fun[$testnum]}
# 	readrat=${rratlist[$testnum]}
# 	for wb_delay in 30; do
# 		mkdir "de"$wb_delay"_read"$readrat
# 		cd "de"$wb_delay"_read"$readrat

# 		echo "de"$wb_delay"_read"$readrat
# 		echo $wb_delay > /sys/block/bcache0/bcache/writeback_delay
# 		sleep 1

# 		for mod in randrw rw; do
# 			for bs in 8K 16K; do
# 				title=$npre$mod"_"$bs
# 				echo "bcache test with $mod $bs:"

# 				reattach;
# 				nj=4
# 				iod=16
# 				monitor bcache0 $title $runt &
# 				fio_test $title $mod $bs $nj $iod $readrat
# 			done
# 		done
# 		cd ../
# 	done
# done
