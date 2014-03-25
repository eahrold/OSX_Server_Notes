#### About PostgresSQL

First off make OS X Server a little more posix friendly...
```shell
sudo ln -s /Library/Server/PostgreSQL\ For\ Server\ Services/Socket/ /var/pgsql_server_socket
```
when you're working with the server postgres you'll want to use the provided postgres install so...
```shell
cd /Applications/Server.app/Contents/ServerRoot/usr/bin
```
and you can take a look at the avaliable tables and their owners via this
```shell
sudo ./psql -h /var/pgsql_server_socket -U _postgres --list
serveradmin start postgres_server
```
then back up the db's
```shell
./pg_dump -h /Library/Server/PostgreSQL\ For\ Server\ Services/Socket --username=caldav caldav > ~/Desktop/caldav.sql
./pg_dump -h /Library/Server/PostgreSQL\ For\ Server\ Services/Socket --username=_devicemgr device_management > ~/Desktop/device_management.sql  
```
on Server 3.0 caldav is dynamic so use find to locate the actual dir it's a little different
```shell
CALDAV_SQL=`find /var/run/caldavd -name ccs_postgres_*`
./pg_dump -h ${CALDAV_SQL} --username=caldav caldav > ~/Desktop/caldav_`date +%m%d%y%H%M`.sql
```

but then they switched back to a static location on server 3.1
```
sudo pg_dump -h /var/run/caldavd/PostgresSocket/ --username=caldav caldav > ~/Desktop/caldav_`date +%m%d%y%H%M`.sql
```

and incase you need to kill all the connections before restoring
```
psql -h /var/run/caldavd/PostgresSocket/ --username=caldav

	caldav=# select pg_terminate_backend(pid) from pg_stat_activity where datname='caldav';
	caldav=# \q

sudo dropdb -h /var/run/caldavd/PostgresSocket/ -U caldav caldav
sudo createdb -h /var/run/caldavd/PostgresSocket/ -U caldav caldav
sudo psql -h /var/run/caldav/PostgresSocket/ -U caldav caldav -f /path/to/pgsql/file.sql
```


here's how to wipe the Profile Manager
```shell
/Applications/Server.app/Contents/ServerRoot/usr/share/devicemgr/backend/wipeDB.sh

sudo ./pg_dumpall  -h /var/pgsql_server_socket --username=_postgres > ~/Desktop/pg_all.sql

sudo serveradmin stop postgres_server
sudo serveradmin start postgres_server
```
then to restore
```shell
sudo ./createdb -h /var/pgsql_server_socket -U _postgres postgres
sudo ./psql -h /var/pgsql_server_socket -U _postgres -f ~/Desktop/pg_all.sql
```
