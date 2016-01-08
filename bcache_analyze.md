##writeback设置

writeback策略的设置

1. delay较大适合反复修改某部分的数据的情况；
2. delay较小适合对一致性要求较高的情况，读多写少的情况；

writeback_delay

  When dirty data is written to the cache and it previously did not contain any, waits some number of seconds before initiating writeback. Defaults to 30.

writeback_percent

  If nonzero, bcache tries to keep around this percentage of the cache dirty by throttling background writeback and using a PD controller to smoothly adjust the rate.

writeback_rate

  Rate in sectors per second - if writeback_percent is nonzero, background writeback is throttled to this rate. Continuously adjusted by bcache but may also be set by the user.

writeback_running

  If off, writeback of dirty data will not take place at all. Dirty data will still be added to the cache until it is mostly full; only meant for benchmarking. Defaults to on.

是Cache大小的选择
