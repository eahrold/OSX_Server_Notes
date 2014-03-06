###Things to remember When installing puppet and Puppet Dash


When Running under passenger, the puppet user needs to have a home directory set to /dev/null
otherwise you could get errors about "could not set global defaults..."

Puppet Install
	Master Location /usr/share/puppet
	Dashboard Local /usr/share/puppet-dashboard


Fix overwhelmed delayed_jobs
	
	mysql -u dashboard -p
	USE dashboard SELECT * FROM sys.Tables
	TRUNCATE TABLE delayed_jobs;
	
if getting MySQL lock error edit the /etc/my.cnf 
```
innodb_lock_wait_timeout = 500
```
500 seems to get the job done.

###Homebrew MySQL

####fix ownership on /usr/local/var/mysql
	chown -RL mysql:mysql /usr/local/var/mysql	


####set mysql as UserName on launchd 
	defaults write /usr/local/Cellar/mysql/5.5.29/homebrew.mxcl.mysql.plist UserName mysql	

