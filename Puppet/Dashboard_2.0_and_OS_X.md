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
sudo dscl . create /Users/puppet-dashboard home /dev/null
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
su puppet-dashboard

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

then follow the dashboard instructions  
download puppet-dashboard form sodabrew and install in /usr/local/www/ (or per your environment)
```
cd /usr/local/www/
git clone https://github.com/sodabrew/puppet-dashboard.git
cd puppet-dashboard

gem install bundler
bundle install --path vendor/bundle

// config the database file
cp config/database.yml.example  
//set to the pgsql user and db above
//IMPORTANT: (as of this writing)must also add "host: localhost"  to the puppet-dashboard config/database.yaml

// setup the settings.yml
cp config/settings.yml.example config/settings.yml
echo "secret_token: '$(bundle exec rake secret)'" > config/settings.yml 
// for the most part everywhere it says 'puppet' you will change to your FQDN

RAILS_ENV=production bundle exec rake db:setup
RAILS_ENV=production bundle exec rake assets:precompile

//test it out 
bundle exec rails server
```

####Generating Certs and Connecting to the Puppet Master

```
$ sudo -u puppet-dashboard rake cert:create_key_pair
$ sudo -u puppet-dashboard rake cert:request
```
You’ll need to sign the certificate request on the master by running puppet cert sign dashboard. Then, from Dashboard’s directory again, run:  
```
$ sudo -u puppet-dashboard rake cert:retrieve
```

####then to get phusion passenger up and running  (adjust the ruby version)   
```
// do some maintenance... 
rvmsudo rvm get stable && rvm reload && rvmsudo rvm repair all

//then
gem install passenger
/usr/local/rvm/gems/ruby-2.1.1/bin/passenger-install-apache2-module
```
