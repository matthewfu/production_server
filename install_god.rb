require 'fileutils'
include FileUtils

$project_folder = nil
$script_root = nil
$config_file = nil

ARGV.each_with_index do |argv,index|
  case argv
  when "-p" #project
    $project_folder = ARGV[index + 1]
  when "-f" #config
    $config_file = ARGV[index + 1]
  when '-r' #root
    $script_root = ARGV[index + 1]
  end
end

$script_root = pwd() if $script_root.nil?
raise "Project folder must be assign by using -p" if $config_file.nil?

$gem_home = ENV["GEM_HOME"]
$user_home = ENV["HOME"]

if %x[uname].split("\n").first == 'Linux'
  `gem install god`
  `rvm wrapper ruby-version bootup god`
  `sudo mkdir -p /etc/god`

  `cd #{$project_folder}/config`
  `ls`.split("\n").each |file| do
    if file.match(/.god$/)
      `ln -s  #{$project_folder}/config/#{file} /etc/god/#{file}`
    end
     `sudo ln -s #{$script_root}/init.d/god  /etc/init.d/god `
  end
end