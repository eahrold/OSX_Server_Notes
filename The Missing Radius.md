####Setting up an airport base station

#####radiusconfig -addclient BASE_STATION  SHORTNAME
	radiusconfig -addclient 192.168.2.9 airport_ex1

##### make sure it got added correctly
	radiusconfig -naslist

##### install the certs
######This command will do that using the Cert that your os x server website is using,
	DEFAULTCERT=$(serveradmin settings web | grep -i web:defaultSecureSite:sslCertificateIdentifier | awk '{print $3}'|sed 's/\"//g')
	radiusconfig -installcerts /etc/certificates/${DEFAULTCERT}.key.pem /etc/certificates/${DEFAULTCERT}.cert.pem /etc/certificates/${DEFAULTCERT}.chain.pem

	radiusconfig -setconfig private_key_password Apple:UseCertAdmin

#####Check that all is well...
	radiusd -sfX

#####Finally launch it using the launchd 
	launchctl load /System/Library/LaunchDaemons/org.freeradius.radiusd.plist


#####if while testing you're banging your head against a wall because your client computer can't authenticate,  remove the 802.1X Password for the Wireless from your login keychain and it should re-ask for username and password.

