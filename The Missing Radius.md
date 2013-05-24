airport shared secret

##radiusconfig -addclient BASESTAION SHORTNAME
radiusconfig -addclient 192.168.2.9 


radiusconfig -naslist


radiusconfig -installcerts /etc/certificates/certname.key.pem /etc/certificates/certname.cert.pem /etc/certificates/certname.chain.pem