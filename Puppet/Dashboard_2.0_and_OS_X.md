Puppet Dash 2.0 on os x...


Must user RVM to get ruby env working properly
if not installed
```
brew install rvm
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