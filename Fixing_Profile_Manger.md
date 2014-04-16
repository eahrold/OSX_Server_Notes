## A real fix for Profile Manager Errors.

While you won't need to start from scratch you will need to create a New Certificate Authority  

====
if you need to back up your config do this in server 3.0
```
sudo pg_dump -h /Library/Server/ProfileManager/Config/var/PostgreSQL --username=_devicemgr device_management > ~/Desktop/device_management.sql
```
or if using server 3.1
```
sudo pg_dump -h /Library/Server/ProfileManager/Config/var/PostgreSQL --username=_devicemgr devicemgr_v2m0 > ~/Desktop/device_management.sql

```
or if apple has changed things yet again here's how to find the db name to backup...
```
sudo find /Library/Server/ -name .s.PGSQL*
	## and look for the one that most resembels Profile Manager then 
	## in the next command you'll want to omit the .s.PGSQL part and just put the directory
sudo psql -h /path/to/the/above results/Socket/ --username=_devicemgr template1  
	template1=#\list
	##press enter an it should show you the proper database name
```
====
First using the Server.app create a dummy temp certificate in the certificate pane.
set all services to use that.  

Then open /System/Library/CoreServices/DirectoryUtility and choose /LDAPv3/127.0.0.1
click the lock and authenticate as your directory admin

in the viewing: popup button choose CertificateAuthorities and remove all the entries from there

Next in Keychain Access, choose the System keychain and find all of the references to the previous Certificate Authorities, Intermediate CAs and certificate files signed by those CA's and remove both the certificate and the key for each.  You'll get a better overview if you choose "Keys" as the catagory in the left hand window.
_* if your keychain is cluttered by a bunch of keys with your FQDN, you can get rid of the ones without a toggle triangle really are not in use and can safely be removed_


This next step is where I found the magic...
purge /var/root/Library/Application Support/Certificate Authorities/

    sudo rm /var/root/Library/Application Support/Certificate Authorities/
    
Finally wipe the profile manger db

    /Applications/Server.app/Contents/ServerRoot/usr/share/devicemgr/backend/wipeDB.sh

after all of these steps are completed re-run the Profile Manger setup using the server.app  

Check that you Have a New Open Directory Certificate Authority, AND a new IntermediateCA listed in the CertificateAuthority section of Directory Utility.
if you don't have both, repeat these steps wiping all of the Certificates for Directory Utility and Keychain access. If you do you should be ready to re-enroll

###Untested...
now you should be able to restore your devicemgr settings using
sudo dropdb -h /Library/Server/ProfileManager/Config/var/PostgreSQL --username=_devicemgr devicemgr_v2m0
sudo createdb -h /Library/Server/ProfileManager/Config/var/PostgreSQL --username=_devicemgr devicemgr_v2m0
sudo psql -h /Library/Server/ProfileManager/Config/var/PostgreSQL --username=_devicemgr devicemgr_v2m0 -f ~/Desktop/device_management.sql