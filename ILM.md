# Index Lifecycle Management
- similar to logrotate
- all data nodes (organized by data age and system performance colder is slower)

#Storage tiers
-can be based on time or disk size among other options.
## hot
- active in use (less than 30 days)
- 1P, 1R shard
- NVMe SSD recommended
## warm
- 1P shard
- takes up less space than hot
`https://www.elastic.co/guide/en/elasticsearch/reference/7.8/indices-shrink-index.html#indices-shrink-index`

A shrink operation:

1. Creates a new target index with the same definition as the source index, but with a smaller number of primary shards.
2. Hard-links segments from the source index into the target index. (If the file system doesn’t support hard-linking, then all segments are copied into the new index, which is a much more time consuming process. Also if using multiple data paths, shards on different data paths require a full copy of segment files if they are not on the same disk since hardlinks don’t work across disks)
3. Recovers the target index as though it were a closed index which had just been re-opened.
- SSD storage recommended
## cold
- spinning disk storage
- keyword purging to reduce size of index further
## frozen
- minimal keywords, likely just 5tuple and timestamp
- archival storage.
