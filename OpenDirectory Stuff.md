####Make Sure you copy the Intermediate Certificate from the Master to The Replica and vice versa, before enabling SSL  
ML server 2.2.1 only copies things one way.


####MDM stuff
If you're going to be using the MDM Services for remote management, the OD master must be your MDM server.  The MDM server cannot be a replica by default because SCEP fails if it's not, I suspect this is due the crl needing to be on the mdm master.  However there's also a setting from serveradmin to specify the OD master, which is set to 127.0.0.1 by default, and changing that may make things work. 


#### slapconfig is your friend, and gives you a bit more control of how things are set up.  and a wealth of information on what's being done
in fact you could theoretically reverse engeneer slapconfig and run all of the commmands individually

	sudo slapconfig -createldapmasterandadmin --allow_local_realm --certAuthName "My Server Cert Auth" --certAdminEmail admin@myserver.com --certOrgName "My Server Unit" diradmin "Directory Admin" 1000 dc=my,dc=server,dc=com MY.SERVER.COM

also this if you need to recreate your root certificates.

	sudo slapconfig -createrootcertauthority "My Server Cert Auth" admin@myserver.com "My Server Unit"


You also will want to make sure you bi-directional replicas set on your master and replica
run this command on both your master and replica

	sudo slapconfig -getmasterconfig

it should look like this on the master/replica

	Master LDAP server
	Updated: 2013-05-25 20:20:29 +0000
	
	List Of Replicas
	replica.server.com - OK

if you replica dosn't have a "List of replicas", you can add it by doing this
first get the guid of ther server and the serverID

	dscl /LDAPv3/127.0.0.1 -read Computers/master.server.com$ GeneratedUID | awk '{print $2}'
	dscl /LDAPv3/127.0.0.1 -read Computers/master.server.com$ apple-ldap-serverid | awk '{print $2}'

place the reutrned values in this command

	sudo slapconfig -addreplica --serverID 2 --guid 1234123FX-AZ07-4AF2-82ED-12K1KJ41234 master.server.com


#####do this when importing a large set of users, but revert to yes once done!
	sudo slapconfig -setfullsyncmode no	

####And if Kerberos isn't working
	sudo mkpassdb -kerberize
	sudo sso_util configure -r MY.SERVER.COM -f /LDAPv3/127.0.0.1 -a diradmin all	


#### Check you SSL connection to the OD server
	openssl s_client -connect myServerName:636

to keep an eye on things

	tail -f /var/log/slapd.log

#### About PostgresSQL

	/Applications/Server.app/Contents/ServerRoot/usr/share/devicemgr/backend/wipeDB.sh
and you can take a look at the avaliable tables and their owners via this

	sudo psql -h /Library/Server/PostgreSQL\ For\ Server\ Services/Socket -U _postgres --list
then back up the db's

	cd /Applications/Server.app/Contents/ServerRoot/usr/bin
	 ./pg_dump -h /Library/Server/PostgreSQL\ For\ Server\ Services/Socket --username=caldav caldav > ~/Desktop/caldav.sql
	 ./pg_dump -h /Library/Server/PostgreSQL\ For\ Server\ Services/Socket --username=_devicemgr device_management > ~/Desktop/device_management.sql

#### Fixing slapd issues (Maybe)

in case of log entries like this
	
	slapd[6708]: <= bdb_equality_candidates: (uniqueMember) not indexed


on the OD server do 
	$ kinit diradmin
	$ ldapmodify
then at after the section that looks like this
	
	SASL/GSSAPI authentication started
	SASL username: diradmin@OD.MYHOME.PRIVATE
	SASL SSF: 56
	SASL data security layer installed.

enter this text right in the window
	dn: olcDatabase={1}bdb,cn=config
	changetype: modify
	add: olcDbIndex
	olcDbIndex: uniqueMember eq

make sure you press enter after the last line and then 
do Control-D...  After that reindex by doing

	launchctl unload /System/Library/LaunchDaemons/org.openldap.slapd.plist
	sudo slapindex
	launchctl load /System/Library/LaunchDaemons/org.openldap.slapd.plist