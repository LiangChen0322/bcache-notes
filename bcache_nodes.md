```
[root@localhost ~]# ll /sys/fs/bcache/8b3c0faa-3b63-48bb-9786-1676197cf325/internal/
total 0
-r--r--r--. 1 root root 4096 1月   5 01:35 active_journal_entries
-r--r--r--. 1 root root 4096 1月   5 01:35 bset_tree_stats
-r--r--r--. 1 root root 4096 1月   5 01:35 btree_cache_max_chain
-r--r--r--. 1 root root 4096 1月   5 01:35 btree_gc_average_duration_ms
-r--r--r--. 1 root root 4096 1月   5 01:35 btree_gc_average_frequency_sec
-r--r--r--. 1 root root 4096 1月   5 01:35 btree_gc_last_sec
-r--r--r--. 1 root root 4096 1月   5 01:35 btree_gc_max_duration_ms
-r--r--r--. 1 root root 4096 1月   5 01:35 btree_nodes
-r--r--r--. 1 root root 4096 1月   5 01:35 btree_read_average_duration_us
-r--r--r--. 1 root root 4096 1月   5 01:35 btree_read_average_frequency_ms
-r--r--r--. 1 root root 4096 1月   5 01:35 btree_read_last_ms
-r--r--r--. 1 root root 4096 1月   5 01:35 btree_read_max_duration_us
-rw-r--r--. 1 root root 4096 1月   5 01:35 btree_shrinker_disabled
-r--r--r--. 1 root root 4096 1月   5 01:35 btree_sort_average_duration_us
-r--r--r--. 1 root root 4096 1月   5 01:35 btree_sort_average_frequency_ms
-r--r--r--. 1 root root 4096 1月   5 01:35 btree_sort_last_ms
-r--r--r--. 1 root root 4096 1月   5 01:35 btree_sort_max_duration_us
-r--r--r--. 1 root root 4096 1月   5 01:35 btree_split_average_duration_us
-r--r--r--. 1 root root 4096 1月   5 01:35 btree_split_average_frequency_sec
-r--r--r--. 1 root root 4096 1月   5 01:35 btree_split_last_sec
-r--r--r--. 1 root root 4096 1月   5 01:35 btree_split_max_duration_us
-r--r--r--. 1 root root 4096 1月   5 01:35 btree_used_percent
-r--r--r--. 1 root root 4096 1月   5 01:35 cache_read_races
-rw-r--r--. 1 root root 4096 1月   5 01:35 copy_gc_enabled
-rw-r--r--. 1 root root 4096 1月   5 01:35 gc_always_rewrite
--w-------. 1 root root 4096 1月   5 01:35 prune_cache
--w-------. 1 root root 4096 1月   5 01:35 trigger_gc
-r--r--r--. 1 root root 4096 1月   5 01:35 writeback_keys_done
-r--r--r--. 1 root root 4096 1月   5 01:35 writeback_keys_failed
```

```
[root@localhost ~]# ll /sys/block/bcache0/bcache/
total 0
--w-------. 1 root root 4096 1月   3 22:30 attach
lrwxrwxrwx. 1 root root    0 1月   3 22:30 cache -> ../../../../../../../../../../../../../../../fs/bcache/8b3c0faa-3b63-48bb-9786-1676197cf325
-rw-r--r--. 1 root root 4096 1月   3 22:30 cache_mode
--w-------. 1 root root 4096 1月   3 22:30 clear_stats
--w-------. 1 root root 4096 1月   3 22:30 detach
lrwxrwxrwx. 1 root root    0 1月   3 22:30 dev -> ../../../../../../../../../../../../../../virtual/block/bcache0
-r--r--r--. 1 root root 4096 1月   3 22:30 dirty_data
-rw-r--r--. 1 root root 4096 1月   3 22:30 label
-r--r--r--. 1 root root 4096 1月   3 22:30 partial_stripes_expensive
-rw-r--r--. 1 root root 4096 1月   3 22:30 readahead
-rw-r--r--. 1 root root 4096 1月   3 22:30 running
-rw-r--r--. 1 root root 4096 1月   3 22:30 sequential_cutoff
-r--r--r--. 1 root root 4096 1月   3 22:30 state
drwxr-xr-x. 2 root root    0 1月   5 01:29 stats_day
drwxr-xr-x. 2 root root    0 1月   5 01:29 stats_five_minute
drwxr-xr-x. 2 root root    0 1月   5 01:29 stats_hour
drwxr-xr-x. 2 root root    0 1月   5 01:29 stats_total
--w-------. 1 root root 4096 1月   3 22:30 stop
-r--r--r--. 1 root root 4096 1月   3 22:30 stripe_size
-rw-r--r--. 1 root root 4096 1月   3 22:30 writeback_delay
-rw-r--r--. 1 root root 4096 1月   3 22:30 writeback_metadata
-rw-r--r--. 1 root root 4096 1月   3 22:30 writeback_percent
-rw-r--r--. 1 root root 4096 1月   3 22:30 writeback_rate
-r--r--r--. 1 root root 4096 1月   3 22:30 writeback_rate_debug
-rw-r--r--. 1 root root 4096 1月   3 22:30 writeback_rate_d_term
-rw-r--r--. 1 root root 4096 1月   3 22:30 writeback_rate_p_term_inverse
-rw-r--r--. 1 root root 4096 1月   3 22:30 writeback_rate_update_seconds
-rw-r--r--. 1 root root 4096 1月   3 22:30 writeback_running
```

```
# cat /sys/block/sdn/sdn2/bcache/running

# echo 1 > /sys/block/sda/sdn2/bcache/running

# cat /sys/block/bcache0/bcache/state

# ls /sys/fs/bcache/
```

卸载
```
# echo e6143ca3-a9ed-4862-becc-e49436a7fd10 > /sys/block/sdn/sdn1/bcache/detach

# echo 1 > /sys/fs/bcache/e6143ca3-a9ed-4862-becc-e49436a7fd10/stop


```
重新设置
```
# echo 8b3c0faa-3b63-48bb-9786-1676197cf325 > /sys/block/bcache0/bcache/detach

# echo 1 > /sys/fs/bcache/8b3c0faa-3b63-48bb-9786-1676197cf325/stop

# wipefs -a /dev/sdo1

# echo 8b3c0faa-3b63-48bb-9786-1676197cf325 > /sys/block/sdn/sdn2/bcache/attach

```