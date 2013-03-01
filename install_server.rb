require 'fileutils'
include FileUtils

$script_root = pwd()
if %x[uname].split("\n").first == 'Linux'
  cd "#{$script_root}/mongo/bin"  
  %x[sudo cp * /usr/sbin/]
  %x[sudo mkdir /data/db/]
  %x[sudo mkdir /data/db/]
  cd "#{$script_root}"  
  %x[sudo cp inits/mongo/mongodb /etc/init.d/]
  %x[sudo cp confs/mongo/mongodb.conf /etc/]

#redis
  cd "#{$script_root}/redis"
  %x[make]
  %x[sudo cp src/redis-server /usr/local/bin/]
  %x[sudo cp src/redis-cli /usr/local/bin/]
  cd "#{$script_root}"  
  %x[sudo cp inits/redis/redis_6379 /etc/init.d/]
  %x[sudo cp confs/redis/6379.conf /etc/redis/]
  
end # of linux

