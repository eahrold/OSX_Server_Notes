Code signing tidbits
Get the Certificate leaf for Privlidged Helper Tools

	 codesign -d -r  - /path/to/app
	 
To Sign Frameworks add

	--deep
	
	
to "Other Code Signing Flags" in Build Settings...


