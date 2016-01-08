#!/bin/sh

function help() {
	echo "bcache-status bcache<n> name-pre run-time"
	echo "    bcache<n>: bcache0, bcache1 ... ..."
	echo "    name-pre: file name's prefix"
	echo "    run-time: running time"
	exit 0;
}

function get_begain() {
	beg_time=`date +%s.%N`
	beg_s=`echo $beg_time | cut -d '.' -f 1`
	beg_ns=`echo $beg_time | cut -d '.' -f 2`
	beg_t=$(( 10#$beg_s*1000000 + 10#$beg_ns/1000 ))
	echo $beg_t
}

function get_interval() {
	start=$1
	end=`date +%s.%N`

	end_s=`echo $end | cut -d '.' -f 1`
	end_ns=`echo $end | cut -d '.' -f 2`

	tm_iv=$(( 10#$end_s*1000000 + 10#$end_ns/1000 - 10#$start))
	tm_iv=`expr $tm_iv/1000 | bc `

	echo $tm_iv
}

# waiting for 0.5s
function wait_for_scan() {
	begain_time=$1
	limit=$(( 10#$2*500 ))
	tm_iv=0

	until (( "$tm_iv" >= "$limit" )); do
		sleep 0.05
		tm_iv=$(get_interval $begain_time)
	done
}

function scan_bcache() {
	timer=$(( 10#$1*500 ))
	para=`cat /sys/block/$device/bcache/dirty_data`
	echo "$timer,$para,0,32768" >> $fname_dt

	para=`cat /sys/block/$device/bcache/stats_five_minute/cache_hit_ratio`
	echo "$timer,$para,0,32768" >> $fname_rat

	para=`cat /sys/block/$device/bcache/stats_five_minute/cache_hits`
	echo "$timer,$para,0,32768" >> $fname_hit

	para=`cat /sys/block/$device/bcache/stats_five_minute/bypassed`
	echo "$timer,$para,0,32768" >> $fname_by

	para=`cat /sys/block/$device/bcache/stats_five_minute/cache_bypass_hits`
	echo "$timer,$para,0,32768" >> $fname_bh

	para=`cat /sys/block/$device/bcache/stats_five_minute/cache_bypass_misses`
	echo "$timer,$para,0,32768" >> $fname_bm

	para=`cat /sys/block/$device/bcache/stats_five_minute/cache_misses`
	echo "$timer,$para,0,32768" >> $fname_miss

	para=`cat /sys/block/$device/bcache/stats_five_minute/cache_miss_collisions`
	echo "$timer,$para,0,32768" >> $fname_mc

	para=`cat /sys/block/$device/bcache/stats_five_minute/cache_readaheads`
	echo "$timer,$para,0,32768" >> $fname_ra
}

function init_file() {
	timer=0
	para=`cat /sys/block/$device/bcache/dirty_data`
	echo "$timer,$para,0,32768" > $fname_dt

	para=`cat /sys/block/$device/bcache/stats_five_minute/cache_hit_ratio`
	echo "$timer,$para,0,32768" > $fname_rat

	para=`cat /sys/block/$device/bcache/stats_five_minute/cache_hits`
	echo "$timer,$para,0,32768" > $fname_hit

	para=`cat /sys/block/$device/bcache/stats_five_minute/bypassed`
	echo "$timer,$para,0,32768" > $fname_by

	para=`cat /sys/block/$device/bcache/stats_five_minute/cache_bypass_hits`
	echo "$timer,$para,0,32768" > $fname_bh

	para=`cat /sys/block/$device/bcache/stats_five_minute/cache_bypass_misses`
	echo "$timer,$para,0,32768" > $fname_bm

	para=`cat /sys/block/$device/bcache/stats_five_minute/cache_misses`
	echo "$timer,$para,0,32768" > $fname_miss

	para=`cat /sys/block/$device/bcache/stats_five_minute/cache_miss_collisions`
	echo "$timer,$para,0,32768" > $fname_mc

	para=`cat /sys/block/$device/bcache/stats_five_minute/cache_readaheads`
	echo "$timer,$para,0,32768" > $fname_ra
}


if [[ $# -lt "3" ]]; then
	help;
fi

if [[ $1 == bcache* ]]; then
	help;
fi

device=$1
name_pre=$2
run_time=$3

fname_dt=$name_pre"_dirty.log"
fname_rat=$name_pre"_ratio.log"
fname_hit=$name_pre"_hit.log"
fname_by=$name_pre"_bypass.log"
fname_bh=$name_pre"_bypasshits.log"
fname_bm=$name_pre"_bypassmiss.log"
fname_miss=$name_pre"_miss.log"
fname_mc=$name_pre"_misscollision.log"
fname_ra=$name_pre"_readahead.log"

init_file;

total_loop=$(( 10#$run_time*2 ))
begain_time=$(get_begain);
# echo "begain_time = $begain_time"

for (( loops=1; loops<=$total_loop; loops++ )); do
	#echo "loops : "$loops
	printf "loops : %d\r" $loops
	wait_for_scan $begain_time $loops;
	scan_bcache $loops;
done
echo " "
