Make Sure you copy the Intermediate Certificate from the Master to The Replica and vice versa, before enabling SSL  -- ML server 2.2.1 only copies things one way.


If you're going to be using the MDM Services for remote management, the OD master must be your MDM server.  The MDM server cannot be a replica by default because SCEP fails if it's not, I suspect this is due the crl needing to be on the mdm master.  However there's also a setting from serveradmin to specify the OD master, which is set to 127.0.0.1 by default, and changing that may make things work. 


#### slapconfig is your friend, and gives you a bit more control of how things are set up.  and a wealth of information on what's being done
in fact you could theoretically reverse engeneer slapconfig and run all of the commmands individually

	sudo slapconfig -createldapmasterandadmin --allow_local_realm --certAuthName "My Server Cert Auth" --certAdminEmail admin@myserver.com --certOrgName "My Server Unit" diradmin "Directory Admin" 1000 dc=my,dc=server,dc=com MY.SERVER.COM

also this if you need to recreate your root certificates.

	sudo slapconfig -createrootcertauthority "My Server Cert Auth" admin@myserver.com "My Server Unit"

	sudo slapconfig -getmasterconfig
	sudo slapconfig -getmasterconfig	
do this when importing a large set of users, but revert to yes once done!
	sudo slapconfig -setfullsyncmode no
	
####And if Kerberos isn't working
	sudo mkpassdb -kerberize
	sudo sso_util configure -r MY.SERVER.COM -f /LDAPv3/127.0.0.1 -a diradmin all	


#### Check you SSL connection to the OD server
openssl s_client -connect myServerName:636

to keep an eye on things
		tail -f /var/log/slapd.log

/Applications/Server.app/Contents/ServerRoot/usr/share/devicemgr/backend/wipeDB.sh