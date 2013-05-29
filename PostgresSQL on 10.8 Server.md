#### About PostgresSQL

To make OS X a little more posix...

	sudo ln -s PostgreSQL\ For\ Server\ Services/Socket/ /var/pgsql_server_socket


and you can take a look at the avaliable tables and their owners via this

	sudo psql -h /Library/Server/PostgreSQL\ For\ Server\ Services/Socket -U _postgres --list

	serveradmin start postgres_server
then back up the db's

	cd /Applications/Server.app/Contents/ServerRoot/usr/bin
	 ./pg_dump -h /Library/Server/PostgreSQL\ For\ Server\ Services/Socket --username=caldav caldav > ~/Desktop/caldav.sql
	 ./pg_dump -h /Library/Server/PostgreSQL\ For\ Server\ Services/Socket --username=_devicemgr device_management > ~/Desktop/device_management.sql  
  

here's how to wipe the Profile Manager

	 /Applications/Server.app/Contents/ServerRoot/usr/share/devicemgr/backend/wipeDB.sh




	 sudo ./pg_dumpall  -h /var/pgsql_server_socket --username=_postgres > ~/Desktop/pg_all.sql

	 sudo serveradmin stop postgres_server
	 sudo serveradmin start postgres_server

	 sudo ./createdb -h /var/pgsql_server_socket -U _postgres postgres
	 sudo ./psql -h /var/pgsql_server_socket -U _postgres -f ~/Desktop/pg_all.sql
