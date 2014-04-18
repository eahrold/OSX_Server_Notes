#!/bin/bash

#############################################
# OSX Server 3.1 Postgres Backup Script     #
#############################################

set -ex 

BACKUP_DIR="~/ServerBackups/"

POSTGRES_SOCKET_DIR="/var/pgsql_socket"
CALDAV_SCOKET_DIR="/var/run/caldavd/PostgresSocket/"
DEVICEMGR_SOCKET_DIR="/Library/Server/ProfileManager/Config/var/PostgreSQL/"


TIMESTAMP=`date +%m%d%y%H%M`
FINAL_DEST=`eval echo ${BACKUP_DIR}${TIMESTAMP}`

## Use the same method as bender for backwards compatability...
OD_ARCHIVE_PASSWORD=`/sbin/ifconfig | /usr/bin/grep -m 1 ether | /usr/bin/awk '{print $2}' | /usr/bin/sed 's/://g' | /usr/bin/cut -c 5-`


backup_postgres(){
	

	### dump all of OSX's standard postgres, what you would be using for your own websites, etc...
	if( -d "${POSTGRES_SOCKET_DIR}" ); then
	sudo pg_dumpall  -h "${POSTGRES_SOCKET_DIR}" --username=_postgres > "${FINAL_DEST}"/os_x_pg_backup.sql
	else
		echo "The Standard Postgres Socket directory is not set correctly or does not exist"
	fi

	### backup the Calendar and Contacts Database...
	if( -d "${CALDAV_SCOKET_DIR}" ); then
		sudo pg_dump -h "${CALDAV_SCOKET_DIR}" --username=caldav caldav > "${FINAL_DEST}"/caldav.sql
	else
		echo "The Calendar Postgres Socket directory is not set correctly or does not exist"
	fi
 
	### backup the Device Manager DB
	if( -d "${DEVICEMGR_SOCKET_DIR}" ); then
		sudo pg_dump -h "${DEVICEMGR_SOCKET_DIR}" --username=_devicemgr device_management > "${FINAL_DEST}"/device_manager.sql
	else
		echo "The Device Manager Postgres Socket directory is not set correctly or does not exist"
	fi
}

backup_ldap(){
	# slapconfig -backupdb "${FINAL_DEST}"/ODArchive.dmg -P "$OD_ARCHIVE_PASSWORD" 
	OD_CMD="${FINAL_DEST}"/.tmp_od
	echo "dirserv:backupArchiveParams:archivePassword = $OD_ARCHIVE_PASSWORD" > "$OD_CMD"
	echo "dirserv:backupArchiveParams:archivePath = ${FINAL_DEST}/ODArchive" >> "$OD_CMD"
	echo "dirserv:command = backupArchive" >> "$OD_CMD"

	serveradmin command < "$OD_CMD"
}

####  Do the backup... 
mkdir -p -m 700 "${FINAL_DEST}"

if [[ ! -d  "${FINAL_DEST}" ]] ; then
	echo "Could Not Write to the specified destination, check the path"
	exit 1
fi

backup_ldap
