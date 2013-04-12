#Steps
- sudo apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion libxslt-dev libxml2-dev libssl-dev zlib1g-dev openjdk-6-jre-headless chkconfig
- sudo apt-get install libcurl4-dev 
- sudo apt-get install imagemagick

- ssh-keygen 

- \curl -L https://get.rvm.io | bash -s stable 
- source ~/.profile
- rvm install 1.9.3
- echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile
- source ~/.rvm/scripts/rvm
- rvm --default use 1.9.3
- ruby install_server.rb
- sudo reboot
- sudo gem install therubyracer
