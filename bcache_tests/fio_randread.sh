#!/bin/sh

#device="/dev/bcache0"
device="/root/test/test"
dp="/sys/block/bcache0"
bdev="sdn1"
cdev="sdo1"
bsize=128k
size=32G
njob=4
iodep=8
mod=randread

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
	printf "clean caching device... ...\r"
	sleep 2
	wipefs -a /dev/$cdev
	printf "\t\t\t\t\t\r"
	echo "Re-attach caching device... ...\r"
	sleep 2
	echo 8b3c0faa-3b63-48bb-9786-1676197cf325 > /sys/block/sdn/$bdev/bcache/attach
	sleep 2
}

function monitor() {
	bcache_status $1 $2 $3
}

function help() {
	echo "fio_randrw [reattach]"
	echo "    with the \"reattach\" it will try to reattach caching device"
	exit 0;
}

if [[ "$#" -eq "1" ]]; then
	if [ "$1"x == "reattach"x ]; then
		reattach
	else
		help
	fi
elif [[ $# -gt "1" ]]; then
	help
fi

logname="seqwrite_"$bsize

monitor bcache0 $logname 600 &

fio --rw=$mod --bs=$bsize --filename=$device \
	--numjobs=$njob --iodepth=$iodep --size=$size \
	--group_reporting --direct=1 --ioengine=libaio \
	--name=$logname --output=$logname".log" \
	--randrepeat=1 \
	--write_bw_log=$logname --write_iops_log=$logname;	# --write_lat_log=$1 --runtime=$runt
printf "\n"

# fio --rw=write --bs=128k --filename=/root/test/test \
# 	--numjobs=4 --iodepth=8 --size=32G \
# 	--group_reporting --direct=1 --ioengine=libaio \
# 	--name=seq_test --output="seq_test.log" \
# 	--write_bw_log="seq_test" --write_iops_log="seq_test";
