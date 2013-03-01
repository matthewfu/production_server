#Steps
- sudo apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion
- sudo apt-get install libxslt-dev libxml2-dev licurl4-dev libssl-dev zlib1g-dev
- sudo apt-get install imagmagick
- sudo apt-get install openjdk-6-jre-headless
- sudo gem install therubyracer
- \curl -L https://get.rvm.io | bash -s stable 
- source ~/.profile
- rvm install 1.9.3
- echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile
- source ~/.rvm/scripts/rvm
- rvm --default use 1.9.3


mongo:
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
sudo echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen" > /etc/apt/sources.list.d/10gen.list
sudo apt-get update
sudo apt-get install mongodb-10gen

nginx/passenger:
sudo gem install passenger
sudo passenger-install-nginx-module