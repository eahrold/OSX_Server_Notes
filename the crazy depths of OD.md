the crazy depths

here's a list of modifications to do post Archive Restore
use Directory Utility to do this.

First off the GUID of the Master Needs to be fixed in a couple of places.

get the GUID from  here , it's the new ID
	in "Config"
		ldapreplicas -- XMLPlist

then enter that GUID into the Computers record of my.server.com$

and also in "ComputerGroups"
	com.apple.opendirectory.group
		GroupMembers needs to be GUID of master


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




