###Puppet Dash 2.0 on os x...

####make sure you've got the xcode cli tools installed in a common location.  
```
xcode-select --install
```

####Install rvm in a multi-user mode (! make sure you're NOT logged in as root!)  
```
\curl -sSL https://get.rvm.io | sudo bash -s stable
```

if it is already installed do some maintenance

```
rvm get stable
rvm cleanup all
```

####create a puppet-dashboard user and group  
```
sudo dscl . create /Users/puppet-dashboard home /bin/bash
sudo dscl . create /Users/puppet-dashboard passwd *
sudo dseditgroup -o create -n . puppet-dashboard
sudo dseditgroup -o edit -a puppet-dashboard -t user puppet-dashboard
```

####set the rvm group to include puppetdashboard and puppet user  
```
sudo dseditgroup -o edit -a puppet-dashboard -t user rvm
sudo dseditgroup -o edit -a puppet -t user rvm
```

then install ruby and set version to use...  
```
sudo su
su puppetdashboard

// make sure openssl gets installed for rvm
rvm pkg install openssl
rvm install ruby
rvm use ruby-2.1.1  // or which ever one was downloaded above
```

Get libxml2 ... get from homebrew  
```
brew install libxml2
```

set up PostgresDB (mavericks):  
```
sudo serveradmin start postgres
sudo createdb -U _postgres dashboard
sudo psql -d dashboard -U _postgres // gets you into psql

CREATE USER dashboard WITH PASSWORD 'mydashpass';
GRANT ALL PRIVILEGES ON DATABASE dashboard to dashboard;
```

and set usename/password/db name etc. in the config/databse.yaml
IMPORTANT: (as of this writing)must also add "host: localhost"  to the puppet-dashboard config/database.yaml

then follow the dashboard instructions  
download puppet-dashboard form sodabrew and install in /usr/local/www/ (or per your environment)
```
cd /usr/local/www/
git clone https://github.com/sodabrew/puppet-dashboard.git
cd puppet-dashboard

gem install bundler
bundle install --path vendor/bundle
echo "secret_token: '$(bundle exec rake secret)'" 
RAILS_ENV=production bundle exec rake db:setup
RAILS_ENV=production bundle exec rake assets:precompile

//test it out 
bundle exec rails server
```

####then to get phusion passenger up and running  (adjust the ruby version)   
```
// do some maintenance... 
rvmsudo rvm get stable && rvm reload && rvmsudo rvm repair all

//then
gem install passenger
/usr/local/rvm/gems/ruby-2.1.1/bin/passenger-install-apache2-module
```
