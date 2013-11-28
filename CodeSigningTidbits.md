Code signing tidbits
Get the Certificate leaf for Privlidged Helper Tools

	 codesign -d -r  - /path/to/app
	 
To Sign Frameworks and other stubborn items in xcode add

	--deep
	
	
to "Other Code Signing Flags" in Build Settings...



for helper tools

	-sectcreate __TEXT __info_plist ./helper-tool-name/helper-Info.plist -sectcreate __TEXT __launchd_plist helper-tool-name/helper-Launchd.plist
