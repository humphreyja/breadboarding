# Default cache store settings to be used by the Heroku add-on `memcachier:dev`.
# The MemCachier Developer add-on has a bucket size of 25 MB (2016-01-23)
CACHE_STORE_SETTINGS = {
  username:             ENV['MEMCACHIER_USERNAME'],
  password:             ENV['MEMCACHIER_PASSWORD'],
  failover:             true,
  socket_timeout:       1.5,
  socket_failure_delay: 0.2
}.freeze
