Solving the Profile Manger Riddle...

While you won't need to start from scratch you will need to create a New Certificate Authority'
go open /System/Library/CoreServices/DirectoryUtility and choose /LDAPv3/127.0.0.1
click the lock and authenticate with your directory admin

in the viewing popup button choose CertificateAuthorities and remove all the entries from there

Next in keychain find all of the references to the Previous Certificate Authorities and Intermediate CA's and  certificate files signed by those CA's and remove both the Cert and the key.
* any key that dosn't have an exposure triangle can be removed'

next you need to purge /var/root/Library/Application Support/Certificate Authorities/

    sudo rm /var/root/Library/Application Support/Certificate Authorities/
    
then wipe the profile manger db

    /Applications/Server.app/Contents/ServerRoot/usr/share/devicemgr/backend/wipeDB.sh

after all of these steps are completed re-run the Profile Manger setup using the server.app
Check that you Have a New CA, and IntermediateCA listed in the CertificateAuthority section of Directory Utility.
if you don't repeat these steps wiping all of the Certificates for Directory Utility and Keychain access