here's a list of modifications to do post Archive Restore
use Directory Utility to do this.

####THIS MUST BE DONE!!!
Otherwise it will show up as a replica of itself were you to ever add a replica to the conifguration.
It also helps with SASL binding and a varitey of other things.

First off the GUID of the Master Needs to be fixed in a couple of places.

get the GUID from  here , it's the new ID

	Config
		-ldapreplicas
			-XMLPlist

then enter that GUID into the 

	Computers  
		-my.server.com$
			-GeneratedUID

and also in 

	ComputerGroups
		-com.apple.opendirectory.group
			-GroupMembers


passwordserver should look like this... no duplicate arrays or Replica dicsts at all.

	<?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
	<plist version="1.0">
	<dict>
		<key>ID</key>
		<string>5C9AEG5F2472FFD98FASDF77D9E38B491</string>
		<key>Parent</key>
		<dict>
			<key>IP</key>
			<array>
				<string>192.168.2.21</string>
			</array>
		</dict>
	</dict>
	</plist>


#####For some reason, apple dosn't reset a few things quite right
in particular apple-group-memberguida and apple-group-nestedgroup are only set with index of *eq*, but with Profile manager the need to be *sub* as well.  You will see errors in your /var/log/slapd.log like this

	bdb_substring_candidates: (apple-group-nestedgroup) not indexed

the easiest way is to fix this is by using Directory Editor*.  Go to your /LDAPv3/127.0.0.1, login as diradmin, then navigate to the OLCDBDConfig.  Go to your dc=my,dc=server,dc=com  find the value for each of the following and change to what's here

	apple-group-nestedgroup    eq,sub
	apple-group-memberguid     eq,sub
	altSecurityIdentities      eq,sub


* you can also fix it with ldapmodify, but I havn't figured out how yet. 

dn: olcDatabase={1}bdb,cn=config.cn=OLCDatabaseIndex
changetype: modify
replace: apple-group-memberguid
apple-group-memberguid: eq,sub



