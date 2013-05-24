####Setting up an airport base station

#####radiusconfig -addclient BASE_STATION  SHORTNAME
	radiusconfig -addclient 192.168.2.9 airport_ex1

##### make sure it got added correctly
	radiusconfig -naslist

##### install the certs
	DEFAULTCERT=$(serveradmin settings web | grep -i web:defaultSecureSite:sslCertificateIdentifier | awk '{print $3}'|sed 's/\"//g')
	radiusconfig -installcerts /etc/certificates/${DEFAULTCERT}.key.pem /etc/certificates/${DEFAULTCERT}.cert.pem /etc/certificates/${DEFAULTCERT}.chain.pem

#####Check that all is well...
	radiusd -sfX

#####Finally launch it using the launchd 
	launchctl load /System/Library/LaunchDaemons/org.freeradius.radiusd.plist