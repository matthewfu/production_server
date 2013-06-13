#Steps
- sudo apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion libxslt-dev libxml2-dev libssl-dev zlib1g-dev openjdk-6-jre-headless chkconfig imagemagick libcurl4-openssl-dev


-mysql : apt-get install libmysqld-dev 

- ssh-keygen 

- \curl -L https://get.rvm.io | bash -s stable 
- source ~/.profile
- rvm install 1.9.3
- echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile
- source ~/.rvm/scripts/rvm
- rvm --default use 1.9.3
- git clone [Your project]
- git clone https://github.com/matthewfu/production_server.git
- cd production_server
- ruby install_server.rb
- sudo reboot
- gem install therubyracer

god_settings
============

#Run
- gem install god
- rvm wrapper ruby-version bootup god

#Install
- 1.Move this folder to /etc/god
- 2.Link the *.god files to conf.d  
- 3.Link init.d/god to /etc/init.d/god  ==>  sudo ln -s /etc/god/init.d/god  /etc/init.d/god 

#Change
- Edit init.d/god/  GOD_BIN to bootup_god path
- Edit conf.d/*.god(resque setting)   rails_root to rails root's path, w.group to specific name if needed

#Finish
- sudo update-rc.d god defaults


git config --global url."https://".insteadOf git://