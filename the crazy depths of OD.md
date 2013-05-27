the crazy depths

here's a list of ldpa modificatioss

in "Config"
ldapreplicas: needs to be updated with the actual GUID for the new master

passwordserver should look like this

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


in "ComputerGroups"
com.apple.opendirectory.group
GroupMembers needs to be GUID of master


D37ADFB7-A048-4365-B003-4B1B6C0D00CA