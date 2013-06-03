you can get a minimal NAT up and running with a few tweaks to the /etc/pf.anchors/com.apple file.  Included is and example.  The only modification you'll need to make is in the 900.NATrules file.  Just change the external_interface and internale_interface to fit your environment.

you may also need to do 

	sudo sysctl -w net.inet.ip.forwarding=1 
for testing

and edit you /etc/sysctl.conf file to include 

	net.inet.ip.forwarding=1
for a more perminant setting