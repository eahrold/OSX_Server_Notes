###Things to remember When installing puppet and Puppet Dash


When Running under passenger, the puppet user needs to have a home directory set to /dev/null
otherwise you could get errors about "could not set global defaults..."

Puppet Install
	Master Location /usr/share/puppet
	Dashboard Local /usr/share/puppet-dashboard




###Homebrew MySQL

####fix ownership on /usr/local/var/mysql
	chown -RL mysql:mysql /usr/local/var/mysql	


####set mysql as UserName on launchd 
	defaults write /usr/local/Cellar/mysql/5.5.29/homebrew.mxcl.mysql.plist UserName mysql	

