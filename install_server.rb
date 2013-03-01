require 'fileutils'
include FileUtils

$script_root = pwd()
if %x[uname].split("\n").first == 'Linux'

#mongo
  cd "#{$script_root}/mongo/bin"  
  %x[sudo cp * /usr/sbin/]
  %x[sudo mkdir -p /data/db/]
  cd "#{$script_root}"  
  %x[sudo cp inits/mongo/mongodb /etc/init.d/]
  %x[sudo cp confs/mongo/mongodb.conf /etc/]
  %x[sudo update-rc.d mongodb defaults]

#redis
  cd "#{$script_root}/redis"
  %x[make]
  %x[sudo cp src/redis-server /usr/local/bin/]
  %x[sudo cp src/redis-cli /usr/local/bin/]
  cd "#{$script_root}"  
  %x[sudo cp inits/redis/redis_6379 /etc/init.d/]
  %x[sudo mkdir -p /etc/redis/]
  %x[sudo cp confs/redis/6379.conf /etc/redis/]
  %x[sudo update-rc.d redis_6379 defaults]
#pcre
  cd "#{$script_root}/pcre"
  %x[tar -xvjpf pcre-8.32.tar.bz2]
  cd  "pcre-8.32"
  %x[./configure] 
  %x[make] 
  %x[sudo make install] 
  %x[sudo ldconfig]

#nginx
  cd "#{$script_root}/nginx"
  puts "END OF SCRIPT"

#varnish

end # of linux

