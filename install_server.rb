require 'fileutils'
include FileUtils

$script_root = pwd()
$gem_home = ENV["GEM_HOME"]
$user_home = ENV["HOME"]
$caller_project_folder = nil

ARGV.each_with_index do |argv,index|
  case argv
  when "-p" #project
    $caller_project_folder = ARGV[index + 1]
  when "-f" #config
    $caller_config_file = ARGV[index + 1]
  when '-r' #root
    $caller_script_root = ARGV[index + 1]
  end
end

print "Enter project folder location...."
project_loc = gets.chomp 

print "Need Mysql for connecting LDAP?( Y/default No)......."
install_musql = gets.chomp

print "Need God for delay and routine job?( Y/default No)......."
install_routine_job = gets.chomp

print "Nginx ipv6?( Y/default No)......."
nginx_need_ipv6 = gets.chomp

if %x[uname].split("\n").first == 'Linux'

#init submodule
  cd "#{$script_root}"
  `git submodule init`
  `git submodule update`

#mongo
  cd "#{$script_root}/mongo/bin"  
  `sudo cp * /usr/sbin/`
  `sudo mkdir -p /data/db/`
  cd "#{$script_root}"  
  `sudo cp inits/mongo/mongodb /etc/init.d/`
  `sudo chmod +x /etc/init.d/mongodb`
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
  `sudo chmod +x /etc/init.d/redis_6379`
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
  version = %x[gem list passenger].scan(/\d.\d.\d/)
  `sudo apt-get install libcurl4-openssl-dev`
  `./auto/configure  --add-module=#{$gem_home}/gems/passenger-#{version}/ext/nginx --prefix=#{$user_home}/nginx --with-cc-opt=-Wno-error`
  `make`
  `make install`
  `sudo cp #{$script_root}/inits/nginx/nginx /etc/init.d/`
  `sudo chmod +x /etc/init.d/nginx`
  `sudo cp #{$script_root}/confs/nginx/nginx.conf #{$user_home}/nginx/conf/`
    puts 'Please edit nginx conf for detial'
  `sudo update-rc.d nginx defaults`
    puts 'Please edit /etc/init.d/nginx set conf file to #{$user_home}/nginx/conf/nginx.conf'
#varnish
  `sudo apt-get install varnish`

#mysql
  if install_musql.upcase == "Y"
  `sudo apt-get install libmysqld-dev`
  `gem install mysql2 -v '0.3.11'`    
  end
  
 #iroutine_job
  if install_routine_job.upcase == "Y"
    cd "#{$script_root}/god_settings"

  end

  #$init project
  if $caller_project_folder
    cd $caller_project_folder
    `bundle install`
    `rake assets:precompile`
  end

end # of linux

