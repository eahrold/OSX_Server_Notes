##here's a list of modifications to do post Archive Restore
These are base on 10.8 sever.  Use Directory Utility to do this. (can also be done with ldapmodify*, but much more tedious)

####THIS MUST BE DONE!!!
When you restore from Archive, apple creates a new guid for the OD Master, but still has the old guid for the server itself.   Which leaves the LDAP database with two enteries for the same machine.  You need to fix this by updating the old machine record. Otherwise it will show up as a replica of itself (were you to ever add a replica to the conifguration).

_It also helps with successful SASL binding and a varitey of other things._

First off the GUID of the Master Needs to be fixed in a couple of places.  

get the GUID from  here , it's the new ID

```
Config
	-ldapreplicas
		-XMLPlist
```
	

you could also run  
`sudo serveradmin settings dirserv | grep GUID`

then enter that GUID into the
```
Computers  
	-my.server.com$
		-GeneratedUID
```

and also in 
```
ComputerGroups
	-com.apple.opendirectory.group
		-GroupMembers
```

passwordserver should look like this... no duplicate arrays or Replica dicsts at all.
```
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
```
  
  
###If you have an OD server with Multiple interfaces in a NAT environment
you will need to create a certificate with both interfaces listed 
*using server app go to "create a Trusted Certificate"
*make sure the check box of "let me override defaults" is checked

1. Identity Type "Leaf"

2. Continue along making changes to "Certificate Information" if you wish, but don't change anything else

3. at "Subject Alternate Name" add all of you Server's IP's in the iPAddress field with spaces seperating them

4. and make sure the dNSName is correct*

5. click continue... and if all goes well Server admin will ask you if you want to export the key.  click "Always Allow"  

6. Change the services to use the new Certificate.  
		
.  
.  

###For some reason, apple dosn't reset a few things quite right
in particular apple-group-memberguid and apple-group-nestedgroup are only set with index of *eq*, but with Profile manager the need to be *sub* as well.  You will see errors in your /var/log/slapd.log like this

	bdb_substring_candidates: (apple-group-nestedgroup) not indexed

the easiest way is to fix this is by using Directory Editor\*.   Go to your /LDAPv3/127.0.0.1, login as diradmin, then navigate to the OLCDBDConfig.  Go to your dc=my,dc=server,dc=com  find the value for each of the following and change to what's here

```
apple-group-nestedgroup    eq,sub
apple-group-memberguid     eq,sub
altSecurityIdentities      eq,sub
```



###* how to fix this with ldapmodify

In your terminal do

```
kinit diradmin
ldapmodify
```

then add these lines in the now open field

```
dn: olcDatabase={1}bdb,cn=config
changetype: modify
delete: olcDbIndex
olcDbIndex: apple-group-nestedgroup eq
olcDbIndex: apple-group-memberguid eq
olcDbIndex: altSecurityIdentities eq
-
add: olcDbIndex
olcDbIndex: apple-group-nestedgroup eq,sub
olcDbIndex: apple-group-memberguid eq,sub
olcDbIndex: altSecurityIdentities eq,sub
```

make sure you press enter after entering the last line then
press contorl-D. You should see this message

	modifying entry "olcDatabase={1}bdb,cn=config"

you can enter any number of values in the above command if you're seeing the substring error in your slapd log


I also was seeing these errors 

```
slapd[41150]: <= bdb_equality_candidates: (apple-transactionID) not indexed
slapd[41150]: <= bdb_equality_candidates: (apple-serialNumber) not indexed
slapd[41150]: <= bdb_equality_candidates: (apple-issuer) not indexed
```

here's the ldapmodify entry to fix those...

```
dn: olcDatabase={1}bdb,cn=config
changetype: modify
add: olcDbIndex
olcDbIndex: apple-transactionID eq
olcDbIndex: apple-serialNumber eq
olcDbIndex: apple-issuer eq
```

and then a few months later, after unsuccessfully enabling device management,
i needed to run this
```
dn: olcDatabase={1}bdb,cn=config
changetype: modify
add: olcDbIndex
olcDbIndex: entryUUID eq
olcDbIndex: apple-realname eq
olcDbIndex: apple-group-memberguid eq
olcDbIndex: apple-group-nestedgroup eq
olcDbIndex: macAddress eq
olcDbIndex: gidNumber eq
olcDbIndex: apple-hwuuid eq
olcDbIndex: apple-transactionID eq
olcDbIndex: apple-serialNumber eq
olcDbIndex: apple-issuer eq
olcDbIndex: objectClass eq
olcDbIndex: memberUid eq
olcDbIndex: ipHostNumber eq
olcDbIndex: ou apple-computers eq
olcDbIndex: uid eq,sub
olcDbIndex: ou eq
olcDbIndex: cn eq,sub
olcDbIndex: altSecurityIdentities eq,sub
```



helpful links
	
1. [oracle ldapmodify](http://docs.oracle.com/cd/E19528-01/819-0995/6n3cq3apv/index.html)  
2. [tldp.org](http://tldp.org/HOWTO/LDAP-HOWTO/utilities.html)  
3. []()