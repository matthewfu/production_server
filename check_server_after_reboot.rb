require 'fileutils'
include FileUtils

def check_ps(cmd,has_string_reg,find_count=1)
  `#{cmd}`.split("\n").each do |item|
    puts item
    find_count = find_count - 1 if(item.match(has_string_reg) and !item.match(/grep/) )
  end
  find_count == 0 ? true : false
end

$test_object={}

ARGV.each_with_index do |argv,index|
  case argv
  when "--all" #test all
    $test_object[:all] = true
  when "-nginx" 
    $test_object[:nginx] = true
  when '-redis'
    $test_object[:redis] = true
  when '-mongodb'
    $test_object[:mongo] = true
  when '-varnish'
    $test_object[:varnish] = true
  when '-god'
    $test_object[:god] = true
  end
end

#nginx
  if $test_object[:nginx] or $test_object[:all]
    puts  "Nginx........#{check_ps("ps -aux | grep nginx",/nginx/) ? "OK" : "Failed"}"
  end

#redis
  if $test_object[:redis] or $test_object[:all]
    puts  "Redis........#{check_ps("ps -aux | grep redis-server",/redis-server/) ? "OK" : "Failed"}"
  end

#mongodb
  if $test_object[:mongodb] or $test_object[:all]
    puts  "Mongodb........#{check_ps("ps -aux | grep mongod",/mongod/) ? "OK" : "Failed"}"
  end

#varnish
  if $test_object[:varnish] or $test_object[:all]
    puts "Varish........TODO"
  end

#god
  if $test_object[:god] or $test_object[:all]
    puts "god........TODO"
  end