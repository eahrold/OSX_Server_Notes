Make Sure you copy the Intermediate Certificate from the Master to The Replica and vice versa, before enabling SSL  -- ML server 2.2.1 only copies things one way.


If you're going to be using the MDM Services for remote management, the OD master must be your MDM server.  The MDM server cannot be a replica by default because SCEP fails if it's not, I suspect this is due the crl needing to be on the mdm master.  However there's also a setting from serveradmin to specify the OD master, which is set to 127.0.0.1 by default, and changing that may make things work. 

This command is your friend, and gives you a bit more controll of how things are set up.
Also 

sudo slapconfig -createldapmasterandadmin --allow_local_realm --certAuthName "My Server Cert Auth" --certAdminEmail admin@myserver.com --certOrgName "My Server Unit" diradmin "Directory Admin" 1000 dc=my,dc=server,dc=com MY.SERVER.COM
