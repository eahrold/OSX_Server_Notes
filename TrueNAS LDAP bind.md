the complete guide to os X OpenDirectory intergration on a FreeNAS / TrueNAS 

This guide will show how to set up for User Home Accounts hosted via AFP including
automount for login window access.

###SETTING UP LDAP
	Hostname: your.hostname.com
	Base DN: dc=your,dc=hostname,dc=com
	Allow Anoymous Binding: your choice
	Root bind DN: uid=diradmin,cn=users,dc=your,dc=hostname,dc=com  
	Root bind Password:  *********
		(make sure the user name and password will get you logged in using workgroup manger)
	Password Encryption: md5
	User Suffix:  cn=users
	Group Suffix: cn=groups
	Password Suffix: cn=users
	Machine Suffix:  cn=computers
	Encryption Mode:  (depends if you have SSL enabled for OpenDirectory in Server Admin)
	
	Self signed certificate :	if you set encryption mode to on,
								and your server uses a self signed 	
								certificate to do the encryption,
								copy and paste the cert in this box
	
	you can get self signed cert using  
	```
	 openssl s_client -connect your.ldap.server:636 -showcerts
	```  
	then copy and paste from the first "-----BEGIN CERTIFICATE-----"
	to the last "-----END CERTIFICATE-----"  
	
	there will most likely be more than one since it a trust chain
	
	Auxiliary Parameters: (these should be the default)
						ldap_version 3
						timelimit 30
						bind_timelimit 30
						bind_policy soft
						pam_ldap_attribute uid
	

### SETTING UP AFP SHARE
	1) For this example we'll add a zpool and then a zfs dataset named Users that will act as our Users home directories
	
	
### TWEAKING FREENAS CLI Style  

####1) configure /etc/pam.d/netatalk  (pre 8.0.1)  
	
####2) add items to the /usr/share/skel folder with proper permissions  
	```  
	$ mkdir -m 700 Desktop Documents Downloads Library Movies Music Pictures  
	$ mkdir -m 755 Public
	$ mkdir -m 733 Public/DropBox 
	```  

####3) Add OS X Home Directory Style sym link in  
	```
	ln -s /mnt/Storage/Users /Network/Servers/freenas.server.com/Users
	```		
				
####4a)make sure to adjust /boot/loader.conf  (this may or may not be necissary, and based on you HW config)  
	```
	vfs.zfs.txg.timeout="5"
	vfs.zfs.zio.use_uma="0"
	vfs.zfs.prefetch_disable="1"

	ahci_load="yes"
	aio_load="YES"
	```
	
####4b) and adjust /conf/base/etc/sysctl.conf
	vfs.zfs.txg.write_limit_override=1073741824

		
	5) Make Some Customization to how netatalk is set up by FreeNAS 
	
		edit /etc/rc.d/ix-afpd to amend line to AppleVolumes.system file
			generate_av_system()
				{
					echo "#"
					echo "~ \$f"
					echo ""
				}		
  
 				((( you could just as easily add this to AppleVolumes.default by putting these lines before 								the closing bracket of the generate_av_default() function.  I use the previous because the file is left empty by 			default  )))

  
		this will allow a users home directory to show up as a mount option

		

		
SECTION 4) ADDING AUTOMOUNT RECORD IN SCHEMA
	1) In workgroup manager





Other Notes

all FreeNAS afp config files are in /etc/local/

