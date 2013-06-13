require 'fileutils'
include FileUtils
# require 'pry'
require 'erb'

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

print "Enter project folder location....(Default: #{$user_home}/orbit)"
project_loc = gets.chomp 
project_loc = "#{$user_home}/orbit" if project_loc.empty?

print "Need Mysql for connecting LDAP?( Y/default No)......."
install_musql = gets.chomp

print "Need God for delay and routine job?( Y/default No)......."
install_routine_job = gets.chomp

print "Nginx ipv6?( Y/default No)......."
nginx_need_ipv6 = gets.chomp

if %x[uname].split("\n").first == 'Linux'

`rvm gemset use global`

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
  `sudo touch /var/log/mongodb`
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

#puts "#nginx"
  `gem install passenger -v 4.0.3`
  cd "#{$script_root}/nginx"
  passenger_version = %x[gem list passenger].scan(/\d.\d.\d/).first
  nginx_root = "#{$user_home}/nginx"
  `sudo apt-get install libcurl4-openssl-dev`
  `./auto/configure  --add-module=#{$gem_home}/gems/passenger-#{passenger_version}/ext/nginx --prefix="#{nginx_root}" --with-cc-opt=-Wno-error`
  `make`
  `make install`
  worker_processes = 16
  nginx_conf = ERB.new(File.new("#{$script_root}/confs/nginx/nginx.conf.erb").read)
  File.open("#{nginx_root}/conf/nginx.conf", 'w') { |file| file.write(nginx_conf.result) }
 
  nginx_init = ERB.new(File.new("#{$script_root}/inits/nginx/nginx.erb").read)
  `mkdir -p  #{$script_root}/tmp`
  File.open("#{$script_root}/tmp/nginx_init", 'w') { |file| file.write(nginx_init.result) } 

  `sudo cp #{$script_root}/tmp/nginx_init /etc/init.d/nginx` 
  `sudo chmod +x /etc/init.d/nginx` 
  `sudo update-rc.d nginx defaults`

#varnish
  # `sudo apt-get install varnish`

#mysql
  if install_musql.upcase == "Y"
  `sudo apt-get install libmysqld-dev`
  `gem install mysql2 -v '0.3.11'`    
  end
  
 #routine_job
  if install_routine_job.upcase == "Y"
    `gem install god`
    `rvm wrapper #{ENV["RUBY_VERSION"]} bootup god`
    `sudo mkdir -p /etc/god`
    # cd "#{project_loc}/config"
    # `ls`.split("\n").each do |file|
    #   if file.match(/.god$/)
    #     `sudo ln -s  #{project_loc}/config/#{file} /etc/god/#{file}`
    #   end
    # end   

    god_conf = ERB.new(File.new("#{$script_root}/confs/god/config.erb").read)
    File.open("#{$script_root}/tmp/god_conf", 'w') { |file| file.write(god_conf.result) } 
    `sudo cp #{$script_root}/tmp/god_conf /etc/god/config` 

    god_init = ERB.new(File.new("#{$script_root}/inits/god/god.erb").read)
    File.open("#{$script_root}/tmp/god_init", 'w') { |file| file.write(god_init.result) } 

    `sudo cp #{$script_root}/tmp/god_init /etc/init.d/god` 
    `sudo chmod +x /etc/init.d/god` 
    `sudo update-rc.d god defaults`

    `sudo mkdir -p /var/log/resque`

  end

  #$init project
  if project_loc
    cd project_loc
    `gem update debugger`
    `bundle install`
    `rake assets:precompile`
  end

end # of linux

