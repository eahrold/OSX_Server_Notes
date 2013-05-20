#!/bin/bash


serverAddress=$1

if [ -f /usr/sbin/xtendsancli ] ; then
	target=$(/usr/sbin/xtendsancli discoverTargets -address $serverAddress -verbose | head -1)
	/usr/sbin/xtendsancli addTargets -address $serverAddress "$target"
	/usr/sbin/xtendsancli loginTargets -address $serverAddress "$target"
else 
	echo "no file"
fi
