airport shared secret

#####radiusconfig -addclient BASESTAION SHORTNAME
	radiusconfig -addclient 192.168.2.9 

###### make sure it got added correctly
	radiusconfig -naslist

###### install the certs
	DEFAULTCERT=$(serveradmin settings web | grep -i web:defaultSecureSite:sslCertificateIdentifier | awk '{print $3}'|sed 's/\"//g')
	radiusconfig -installcerts /etc/certificates/${DEFAULTCERT}.key.pem /etc/certificates/${DEFAULTCERT}.cert.pem /etc/certificates/${DEFAULTCERT}.chain.pem