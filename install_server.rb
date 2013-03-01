require 'fileutils'
include FileUtils

$script_root = pwd()
$gem_home = ENV["GEM_HOME"]
$user_home = ENV["HOME"]
if %x[uname].split("\n").first == 'Linux'

#mongo
  cd "#{$script_root}/mongo/bin"  
  `sudo cp * /usr/sbin/`
  `sudo mkdir -p /data/db/`
  cd "#{$script_root}"  
  `sudo cp inits/mongo/mongodb /etc/init.d/`
  `sudo cp confs/mongo/mongodb.conf /etc/`
  `sudo update-rc.d mongodb defaults`

#redis
  cd "#{$script_root}/redis"
  `make`
  `sudo cp src/redis-server /usr/local/bin/`
  `sudo cp src/redis-cli /usr/local/bin/`
  cd "#{$script_root}"  
  `sudo mkdir -p /var/redis/6379`
  `sudo cp inits/redis/redis_6379 /etc/init.d/`
  `sudo mkdir -p /etc/redis/`
  `sudo cp confs/redis/6379.conf /etc/redis/`
  `sudo update-rc.d redis_6379 defaults`
#pcre
  cd "#{$script_root}/pcre"
  `tar -xvjpf pcre-8.32.tar.bz2`
  cd  "pcre-8.32"
  `./configure`
  `make`
  `sudo make install`
  `sudo ldconfig`

#nginx
  `gem install passenger`
  cd "#{$script_root}/nginx"
  `./auto/configure --add-module=#{$script_root}/plugins/nginx-gridfs.git --add-module=#{$gem_home}/gems/passenger-3.0.19/ext/nginx --prefix=#{$user_home}/nginx`
  `sudo cp #{$script_root}/inits/nginx/nginx /etc/init.d/`
  `sudo cp #{$script_root}/conf/nginx/nginx.conf #{$user_home}/nginx/conf/`
    puts 'Please edit nginc conf for detial'
  `sudo update-rc.d nginx defaults`
#varnish

end # of linux

