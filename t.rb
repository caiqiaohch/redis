# 20140117, redis_test.rb

#!/usr/bin/ruby -w
# -*- coding: UTF-8 -*-

require 'rubygems'
require 'redis'

redis=Redis.new(:host => "127.0.0.1", :port => 6379)
redis.select(6)
redis2=Redis.new(:host => "127.0.0.1", :port => 6379)
redis2.select(7)
puts "TEST REDIS LIST"
redis.lpush:"list1",3
redis.lpush:"list1",2
redis.lpush:"list1",1
redis.rpush:"list1",4
redis2.rpush:"list1",5
p redis.lrange:"list1",0,-1
p redis.llen:"list1"
redis.ltrim:"list1",0,2
p redis.lrange:"list1",0,-1
p redis.lindex:"list1",1
puts "TEST " + (redis.type:"list1") + " END"
#redis.del:"list1"

puts "TEST REDIS STRING"
redis.set:"str1","1234567890"
p redis.get:"str1"
puts "TEST " + (redis.type:"str1") + " END"
#redis.del:"str1"

puts "TEST REDIS SET"
redis.sadd:"set1","222"
redis.sadd:"set1","111"
redis.sadd:"set1","333"
p redis.scard:"set1"
p redis.smembers:"set1"
redis.sadd:"set2","444"
redis.sadd:"set2","333"
redis.sadd:"set2","555"
p redis.sunion:"set1","set2"
p redis.sinter:"set1","set2"
puts "TEST " + (redis.type:"set1") + " END"
#redis.del:"set1"
#redis.del:"set2"

puts "TEST REDIS ZSET"
redis.zadd:"sort1",2,"222"
redis.zadd:"sort1",1,"111"
redis.zadd:"sort1",3,"333"
p redis.zrange:"sort1",0,-1
p redis.zrangebyscore:"sort1",2,3
p redis.zrangebyscore:"sort1",2,-1
puts "TEST " + (redis.type:"sort1") + " END"
redis.del:"sort1"

puts "TEST REDIS HASH TABLE"
redis.hset:"hash1","key1",1
redis.hset:"hash1","key2",2
redis.hset:"hash1","key3",3
p redis.hget:"hash1","key2"
p redis.hkeys:"hash1"
p redis.hexists:"hash1","key4"
redis.hdel:"hash1","key2"
p redis.hget:"hash1","key2"
p redis.hkeys:"hash1"
puts "TEST " + (redis.type:"hash1") + " END"
#redis.del:"hash1"

p redis.keys
