#### About PostgresSQL

	/Applications/Server.app/Contents/ServerRoot/usr/share/devicemgr/backend/wipeDB.sh
and you can take a look at the avaliable tables and their owners via this

	sudo psql -h /Library/Server/PostgreSQL\ For\ Server\ Services/Socket -U _postgres --list
then back up the db's

	cd /Applications/Server.app/Contents/ServerRoot/usr/bin
	 ./pg_dump -h /Library/Server/PostgreSQL\ For\ Server\ Services/Socket --username=caldav caldav > ~/Desktop/caldav.sql
	 ./pg_dump -h /Library/Server/PostgreSQL\ For\ Server\ Services/Socket --username=_devicemgr device_management > ~/Desktop/device_management.sql