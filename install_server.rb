require 'fileutils'
include FileUtils

$script_root = pwd()
if %x[uname].split("\n").first == 'Linux'
  cd "#{$script_root}/mongo"  
    %x[sudo aptitude install scons build-essential]
    %x[sudo aptitude install git-core build-essential scons]
    puts 'This usually takes time'
    %x[scons all]
    %x[sudo scons --prefix=/usr/bin/mongo install]

#redis
  cd "#{$script_root}/redis"
  %x[make]
  %x[sudo cp src/redis-server /usr/local/bin/]
  %x[sudo cp src/redis-cli /usr/local/bin/]
  
end # of linux

