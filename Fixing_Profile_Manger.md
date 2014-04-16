## A real fix for Profile Manager Errors.

While you won't need to start from scratch you will need to create a New Certificate Authority  

First using the Server.app create a dummy temp certificate in the certificate pane.
set all services to use that.  

Then open /System/Library/CoreServices/DirectoryUtility and choose /LDAPv3/127.0.0.1
click the lock and authenticate as your directory admin

in the viewing: popup button choose CertificateAuthorities and remove all the entries from there

Next in Keychain Access, choose the System keychain and find all of the references to the previous Certificate Authorities, Intermediate CAs and certificate files signed by those CA's and remove both the certificate and the key for each.  You'll get a better overview if you choose "Keys" as the catagory in the left hand window.
_* if your keychain is cluttered by a bunch of keys with your FQDN, you can get rid of the ones without a toggle triangle really are not in use and can safely be removed_


This next step is where I found the magic...
purge /var/root/Library/Application Support/Certificate Authorities/

    sudo rm /var/root/Library/Application Support/Certificate Authorities/
    
Finally wipe the profile manger db

    /Applications/Server.app/Contents/ServerRoot/usr/share/devicemgr/backend/wipeDB.sh

after all of these steps are completed re-run the Profile Manger setup using the server.app  

Check that you Have a New Open Directory Certificate Authority, AND a new IntermediateCA listed in the CertificateAuthority section of Directory Utility.
if you don't have both, repeat these steps wiping all of the Certificates for Directory Utility and Keychain access.

