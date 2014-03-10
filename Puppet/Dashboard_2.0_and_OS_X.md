Puppet Dash 2.0 on os x...

####create a puppet-dashboard user and group
```
sudo dscl . create /Users/puppetdashboard home /bin/bash
sudo dscl . create /Users/puppetdashboard passwd *
sudo dseditgroup -o create -n . puppetdashboard
sudo dseditgroup -o edit -a puppetdashboard -t user puppetdashboard
```

Must user RVM to get ruby env working properly
if not installed run

```
\curl -sSL https://get.rvm.io | sudo bash -s stable
```
 (this assumes you're setting this
up for more than just a testing environment.)

setup the users for the rvm group...
```
sudo dseditgroup -o edit -a rvm -t user puppetdashboard
sudo dseditgroup -o edit -a rvm -t user www
```
if installed do some maintenance

```
rvm get stable
rvm cleanup all
```

then

```
rvm install ruby
\\then set ruby to use it
 rvm use ruby-2.1.1  // or which ever one was downloaded
```

Need to make sure you libxml2 ... get from homebrew

```
brew install libxml2
```

set up postgres:

```
sudo createdb -U _postgres dashboard
sudo psql -d dashboard -U _postgres // gets you into psql

CREATE USER dashboard WITH PASSWORD 'mydashpass';
GRANT ALL PRIVILEGES ON DATABASE dashboard to dashboard
```


Must add  "host: localhost"  to database.yaml

then follow the dashboard instructions

```
gem install bundler
bundle install --path vendor/bundle
echo "secret_token: '$(bundle exec rake secret)'" 
bundle exec rake db:setup
bundle exec rails server
```

####then to get phusion passenger up and running 
make sure you've got the xcode cli tools installed in a common location.
```
xcode-select --install
```
```
/usr/local/www/gems/bin/passenger-install-apache2-module
```