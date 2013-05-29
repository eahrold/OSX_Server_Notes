#!/bin/bash

#
#
#  These commands need to be run on the server source side....
#  then move the files to some where else
#  to get a list of what's avaliable do -- sudo psql -h /Library/Server/PostgreSQL\ For\ Server\ Services/Socket -U _postgres --list
## ./pg_dump -h /Library/Server/PostgreSQL\ For\ Server\ Services/Socket --username=caldav caldav > ~/Desktop/caldav.sql
##./pg_dump -h /Library/Server/PostgreSQL\ For\ Server\ Services/Socket --username=_devicemgr device_management > ~/Desktop/device_management.sql

##   !!!!! don't use this script.   There are no checks included... It just bulldozes throught. 

$1 = $FILE_PATH

[ $(whoami) != "root" ] && echo must be root! && exit 0

if [ -f $FILE_PATH ] ; then 
serveradmin stop calendar
serveradmin stop devicemgr
serveradmin stop postgres_server
serveradmin start postgres_server


PGDIR="/Applications/Server.app/Contents/ServerRoot/usr/bin"
BK_FILE_Dir="~/Desktop/"

## gotta love apple for not being posix complient e.g. /Library/Server/PostgreSQL\ For\ Server\ Services/Socket -- nices spaces!

$PGDIR/dropdb -h /Library/Server/PostgreSQL\ For\ Server\ Services/Socket -U caldav caldav
$PGDIR/createdb -h /Library/Server/PostgreSQL\ For\ Server\ Services/Socket -U caldav caldav
$PGDIR/psql -h /Library/Server/PostgreSQL\ For\ Server\ Services/Socket -U caldav caldav -f $BK_FILE_Dir/caldav.sql

$PGDIR/dropdb -h /Library/Server/PostgreSQL\ For\ Server\ Services/Socket -U _devicemgr device_management
$PGDIR/createdb -h /Library/Server/PostgreSQL\ For\ Server\ Services/Socket -U _devicemgr device_management
$PGDIR/psql -h /Library/Server/PostgreSQL\ For\ Server\ Services/Socket -U _devicemgr device_management -f $BK_FILE_Dir/device_management.sql

serveradmin start calendar
serveradmin start devicemgr
fi