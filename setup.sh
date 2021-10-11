#!/bin/bash

DIR_TOOL=./tool
DIR_SERVER_JAR=./server_jar
DIR_DECOMPILED_JAR=./decompiled_jar
DIR_PATCHED_JAR=./patched_jar

DIR_DECOMPILERS=${DIR_TOOL}/decompilers
DIR_DECOMPILERS_BIN=${DIR_DECOMPILERS}/bin
DIR_UTILS=${DIR_TOOL}/utils
DIR_TMP=${DIR_TOOL}/tmp

FILETRACKER=${DIR_TOOL}/files.txt
SERVER_ARGS=${DIR_TOOL}/args.txt

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_LIGHT_BLUE='\033[1;34m'
COLOR_YELLOW='\033[1;33m'
COLOR_RESET='\033[0m'



setup_files () {

	rm -rf $DIR_PATCHED_JAR
	rm -rf $DIR_SERVER_JAR
	rm -rf $DIR_DECOMPILED_JAR
	rm -rf $DIR_TMP
	rm -rf $DIR_DECOMPILERS_BIN
	rm $FILETRACKER
	rm $SERVER_ARGS

	mkdir $DIR_PATCHED_JAR
	mkdir $DIR_SERVER_JAR
	mkdir $DIR_DECOMPILED_JAR
	mkdir $DIR_TMP
	mkdir $DIR_DECOMPILERS_BIN

	touch $FILETRACKER
	touch $SERVER_ARGS


	chmod +x *.sh

	TMP_LOC=$(pwd)
	
	cd $DIR_UTILS
	chmod +x *.sh
	cd $TMP_LOC

	cd $DIR_DECOMPILERS
	chmod +x *.sh
	cd $TMP_LOC

}




if [[ $1 = "--confirm" ]]; then
	CONTINUE=yes
else
	read -r -p "This will setup all files / folders and delete existing. Are you sure you want to continue? [y/n]" CONTINUE
fi


if [[ $CONTINUE =~ ^(yes|y)$ ]]; then
	setup_files
	exit 0
else
	echo -e "${COLOR_RED}Aborted${COLOR_RESET}"
	exit 0
fi
