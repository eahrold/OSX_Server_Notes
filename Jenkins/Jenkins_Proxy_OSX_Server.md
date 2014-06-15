##Run Jenkins via proxy os x server using webapp

you need to do this to add the args to the Jenkins start script...

if you've installed from the jenkins official .pkg then do this

    sudo defaults write /Library/Preferences/org.jenkins-ci prefix /jenkins


then put the org.jenkins-ci.webapp.plist file in 

	/Library/Servers/Web/Config/apache2/webapps/"

and the httpd_jenkins-ssl.conf file in 
	
	/Library/Servers/Web/Config/apache2/webapps/
