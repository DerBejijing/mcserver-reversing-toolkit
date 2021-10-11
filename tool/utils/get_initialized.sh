#!/bin/bash

TMP_LOC=""

return_false () {
	echo "incomplete"
	if [[ -n $1 ]]; then
		cd $TMP_LOC
	fi
	exit 0
}

if [[ -n $1 ]]; then
	TMP_LOC=$(pwd)
	cd $1
fi

if ! [[ -d "./tool" ]]; then
	return_false
elif ! [[ -d "./tool/utils" ]]; then
	return_false
elif ! [[ -d "./tool/tmp" ]]; then
	return_false
elif ! [[ -d "./tool/server_installers" ]]; then
	return_false
elif ! [[ -d "./tool/decompilers" ]]; then
	return_false
elif ! [[ -d "./tool/decompilers/bin" ]]; then
	return_false
elif ! [[ -d "./decompiled_jar" ]]; then
	return_false
elif ! [[ -d "./patched_jar" ]]; then
	return_false
elif ! [[ -d "./server_jar" ]]; then
	return_false
fi

echo "ok"

if [[ -n $1 ]]; then
	cd $TMP_LOC
fi